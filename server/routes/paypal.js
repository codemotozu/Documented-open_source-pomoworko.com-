

const express = require("express");
const auth = require("../middlewares/auth");
const User = require("../models/user");
const paypalRouter = express.Router();
const jwt = require("jsonwebtoken");
const axios = require("axios");
const cron = require("node-cron");

// Use cookie-parser middleware. This is required for `csurf` to work properly.

// const webhookRateLimiter = rateLimit({
//   windowMs: 15 * 60 * 1000, // 15 minutes
//   max: 100, // Limit each IP to 100 requests per `window` (here, per 15 minutes)
//   standardHeaders: true, // Return rate limit info in the `RateLimit-*` headers
//   legacyHeaders: false, // Disable the `X-RateLimit-*` headers
//   message: "Too many requests from this IP, please try again after 15 minutes",
// });

paypalRouter.post("/create-plan", async (req, res) => {
  try {
    const plan = {
      product_id: process.env.PAYPAL_SANDBOX_BUSSINESS_PRODUCT_ID, // Debes crear un producto en tu cuenta de PayPal y usar su ID aquí
      name: "Basic Subscription",
      status: "ACTIVE",
      billing_cycles: [
        {
          frequency: {
            interval_unit: "MONTH",
            interval_count: 1,
          },
          tenure_type: "REGULAR",
          sequence: 1,
          total_cycles: 12,
          pricing_scheme: {
            fixed_price: {
              value: "10",
              currency_code: "USD",
            },
          },
        },
      ],
      payment_preferences: {
        auto_bill_outstanding: true,
        setup_fee: {
          value: "10",
          currency_code: "USD",
        },
        setup_fee_failure_action: "CONTINUE",
        payment_failure_threshold: 3,
      },
      taxes: {
        percentage: "10",
        inclusive: false,
      },
    };

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");

    const {
      data: { access_token },
    } = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/oauth2/token",
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
          username: process.env.PAYPAL_CLIENT_ID,
          password: process.env.PAYPAL_CLIENT_SECRET,
        },
      }
    );

    const response = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/billing/plans",
      plan,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    console.log(response.data);
    return res.json(response.data);
  } catch (error) {
    console.log(error);
    return res.status(500).json("Something goes wrong");
  }
});

paypalRouter.post("/create-subscription", auth, async (req, res) => {
  try {
    const userId = req.user;
    const subscriptionDetails = {
      plan_id: process.env.PAYPAL_SANDBOX_BUSSINESS_SUBSCRIPTION_PLAN_ID,
      custom_id: userId,
      application_context: {
        brand_name: "brand.com",
        //? i do not need to use my webhook as return url because it is triggers anyway
        // return_url: "http://localhost:3001/paypal/subscriptions/webhook",
        return_url: "http://localhost:3000/",
        cancel_url: "http://localhost:3001/paypal/cancel-subscription",
      },
    };

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");
    const authResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/oauth2/token",
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
          username: process.env.PAYPAL_CLIENT_ID,
          password: process.env.PAYPAL_CLIENT_SECRET,
        },
      }
    );

    const access_token = authResponse.data.access_token;

    const response = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/billing/subscriptions",
      subscriptionDetails,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    console.log("customID " + subscriptionDetails.custom_id);

    console.log("subscriptionId " + response.data.id);

    await User.findByIdAndUpdate(
      userId,
      {
        $set: {
          subscriptionId: response.data.id,
          subscriptionStatusPending: true,
          subscriptionStatusConfirmed: false,
          suscriptionStatusCancelled: false,
        },
      },
      { new: true }
    );

    console.log("Subscription created with pending status");

    console.error();
    return res.json({ subscriptionId: response.data.id, ...response.data });
  } catch (error) {
    console.log(error);
    return res.status(500).json("Something goes wrong");
  }
});

paypalRouter.post("/subscription-activated/webhook", async (req, res) => {
  try {
    const webhookEvent = req.body;

    const verification = {
      auth_algo: req.headers["paypal-auth-algo"],
      cert_url: req.headers["paypal-cert-url"],
      transmission_id: req.headers["paypal-transmission-id"],
      transmission_sig: req.headers["paypal-transmission-sig"],
      transmission_time: req.headers["paypal-transmission-time"],
      webhook_id: process.env.WEBHOOK_ID_CREATE_SUBSCRIPTION,
      webhook_event: webhookEvent,
    };

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");

    const authResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/oauth2/token",
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
          username: process.env.PAYPAL_CLIENT_ID,
          password: process.env.PAYPAL_CLIENT_SECRET,
        },
      }
    );

    const access_token = authResponse.data.access_token;

    const verifyResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature",
      verification,
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    if (verifyResponse.data.verification_status === "SUCCESS") {
      // Handle different event types as needed
      if (webhookEvent.event_type === "BILLING.SUBSCRIPTION.ACTIVATED") {
        // Extracting the custom_id and subscription ID from the webhook event
        const userId = webhookEvent.resource.custom_id;
        const subscriptionId = webhookEvent.resource.id;
        const nextBillingTime =
          webhookEvent.resource.billing_info.next_billing_time;
        const startTimeSubscriptionPayPal = webhookEvent.resource.start_time;
        console.log(startTimeSubscriptionPayPal);
        console.log(
          `Attempting to confirm subscription for user ${userId} with subscription ID ${subscriptionId}`
        );

        try {
          // Updating the user's subscription status to 'confirmed'
          const updatedUser = await User.findOneAndUpdate(
            { _id: userId, subscriptionId: subscriptionId },
            {
              $set: {
                subscriptionStatusConfirmed: true,
                subscriptionStatusPending: false,
                suscriptionStatusCancelled: false,
                isPremium: true,
                nextBillingTime: nextBillingTime,
                startTimeSubscriptionPayPal: startTimeSubscriptionPayPal,
                custom_id: userId,
                plan_id:
                  process.env.PAYPAL_SANDBOX_BUSSINESS_SUBSCRIPTION_PLAN_ID,
              },
            },
            { new: true }
          );

          if (updatedUser) {
            console.log("Subscription confirmed for user:", userId);
          } else {
            console.log(
              "No matching user document to update or subscription ID mismatch./subscription-activated/webhook"
            );
          }

          return res.status(200).send("Subscription confirmed");
        } catch (error) {
          console.error("Error confirming subscription:", error);
          return res.status(500).send("Error updating subscription status.");
        }
      }
    } else {
      console.log("Failed to verify webhook signature:", verifyResponse.data);
      return res.status(401).send("Webhook signature verification failed");
    }
  } catch (error) {
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      console.error("Error data:", error.response.data);
      console.error("Error status:", error.response.status);
      console.error("Error headers:", error.response.headers);
    } else if (error.request) {
      // The request was made but no response was received
      console.error("No response received:", error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      console.error("Error", error.message);
    }
    return res
      .status(500)
      .send("An error occurred while handling the webhook event.");
  }
});

paypalRouter.get("/success", (req, res) => {
  //only show the redirect page if the weebhook is successfull

  res.redirect("http://localhost:3000/#/");
});



paypalRouter.get("/start-time-subscription", auth, async (req, res) => {
  try {
    const userId = req.user; // Assuming `auth` middleware populates `req.user` with the user ID
    const user = await User.findById(userId); // Fetch the user from your database
    if (!user || !user.subscriptionId) {
      return res
        .status(404)
        .json({ error: "Subscription not found for the user" });
    }

    const access_token = response.data.access_token;

    const response = await axios.get(
      `https://api.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}`,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    const startTimeSubscriptionPayPal = response.data.start_time;
    console.log("response.data.start_time" + startTimeSubscriptionPayPal);

    return res.json({ startTimeSubscriptionPayPal });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "An error occurred while fetching the next billing date",
    });
  }
});



paypalRouter.get( "/paypal-subscription-cancelled-at", auth,async (req, res) => {
    try {
      const userId = req.user; // Assuming `auth` middleware populates `req.user` with the user ID
      const user = await User.findById(userId); // Fetch the user from your database
      if (!user || !user.subscriptionId) {
        return res
          .status(404)
          .json({ error: "Subscription not found for the user" });
      }

      const access_token = response.data.access_token;

      const response = await axios.get(
        `https://api.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}`,
        {
          headers: {
            Authorization: `Bearer ${access_token}`,
          },
        }
      );
      const paypalSubscriptionCancelledAt = response.data.status_update_time;

      console.log(
        "PAY_ATENTION: paypalSubscriptionCancelledAt:  response.data.status_update_time" +
          paypalSubscriptionCancelledAt
      );

      return res.json({ paypalSubscriptionCancelledAt });
    } catch (error) {
      console.error(error);
      return res.status(500).json({
        error: "An error occurred while fetching paypalSubscriptionCancelledAt date",
      });
    }
  }
);


paypalRouter.get("/next-billing", auth, async (req, res) => {
  try {
    const userId = req.user; // Assuming `auth` middleware populates `req.user` with the user ID
    const user = await User.findById(userId); // Fetch the user from your database
    if (!user || !user.subscriptionId) {
      return res
        .status(404)
        .json({ error: "Subscription not found for the user" });
    }

    const access_token = response.data.access_token;

    const response = await axios.get(
      `https://api.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}`,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    const nextBillingTime = response.data.billing_info.next_billing_time;
    return res.json({ nextBillingTime });
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "An error occurred while fetching the next billing date",
    });
  }
});

paypalRouter.get("/update-subscription-status-confirmed", auth, async (req, res) => {
  try {
    const userId = req.user; // Assuming `auth` middleware populates `req.user` with the user ID
    const user = await User.findById(userId); // Fetch the user from your database
    if (!user || !user.subscriptionId) {
      return res
        .status(404)
        .json({ error: "Subscription not found for the user" });
    }

    const access_token = response.data.access_token;

    const response = await axios.get(
      `https://api.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}`,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    try {
      // Updating the user's subscription status to 'confirmed'
      const updatedUser = await User.findOneAndUpdate(
        { _id: userId, subscriptionId: subscriptionId },
        {
          $set: {
            subscriptionStatusConfirmed: true,
            subscriptionStatusPending: false,
            suscriptionStatusCancelled: false,
            isPremium: true,
          },
        },
        { new: true }
      );

      if (updatedUser) {
        console.log("Subscription confirmed for user:", userId);
      } else {
        console.log(
          "No matching user document to update or subscription ID mismatch./subscription-activated/webhook"
        );
      }

      return res.status(200).send("Subscription confirmed");
    } catch (error) {
      console.error("Error confirming subscription:", error);
      return res.status(500).send("Error updating subscription status.");
    }
   } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "An error occurred while fetching the next billing date",
    });
  }
});

paypalRouter.get("/update-subscription-status-cancelled", auth, async (req, res) => {
  try {
    const userId = req.user; // Assuming `auth` middleware populates `req.user` with the user ID
    const user = await User.findById(userId); // Fetch the user from your database
    if (!user || !user.subscriptionId) {
      return res
        .status(404)
        .json({ error: "Subscription not found for the user" });
    }

    const access_token = response.data.access_token;

    const response = await axios.get(
      `https://api.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}`,
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    try {
      // Updating the user's subscription status to 'confirmed'
      const updatedUser = await User.findOneAndUpdate(
        { _id: userId, subscriptionId: subscriptionId },
        {
          $set: {
            subscriptionStatusConfirmed: false,
            subscriptionStatusPending: false,
            suscriptionStatusCancelled: true,
            isPremium: true,
          },
        },
        { new: true }
      );

      if (updatedUser) {
        console.log("Subscription confirmed for user:", userId);
      } else {
        console.log(
          "No matching user document to update or subscription ID mismatch./subscription-activated/webhook"
        );
      }

      return res.status(200).send("Subscription confirmed");
    } catch (error) {
      console.error("Error confirming subscription:", error);
      return res.status(500).send("Error updating subscription status.");
    }
   } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "An error occurred while fetching the next billing date",
    });
  }
});

let cronJobs = {}; // Object to hold cron jobs for each user

paypalRouter.post("/cancel-subscription/webhook", async (req, res) => {
  try {
    const webhookEvent = req.body;

    const verification = {
      auth_algo: req.headers["paypal-auth-algo"],
      cert_url: req.headers["paypal-cert-url"],
      transmission_id: req.headers["paypal-transmission-id"],
      transmission_sig: req.headers["paypal-transmission-sig"],
      transmission_time: req.headers["paypal-transmission-time"],
      webhook_id: process.env.WEBHOOK_ID_CANCEL_SUBSCRIPTION,
      webhook_event: webhookEvent,
    };

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");

    const authResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/oauth2/token",
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
          username: process.env.PAYPAL_CLIENT_ID,
          password: process.env.PAYPAL_CLIENT_SECRET,
        },
      }
    );

    const access_token = authResponse.data.access_token;

    const verifyResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/notifications/verify-webhook-signature",
      verification,
      {
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${access_token}`,
        },
      }
    );

    if (verifyResponse.data.verification_status === "SUCCESS") {
      // Handle different event types as needed
      if (webhookEvent.event_type === "BILLING.SUBSCRIPTION.CANCELLED") {
        // Extracting the custom_id and subscription ID from the webhook event
        const userId = webhookEvent.resource.custom_id;
        const subscriptionId = webhookEvent.resource.id;
        const paypalSubscriptionCancelledAt = webhookEvent.resource.status_update_time;
       
        console.log(
          "The user's subscription has been cancelled. The user's ID is: ",
          userId +" and the subscription id is: "+ subscriptionId
        );

        

        try {
          // Updating the user's subscription status to 'confirmed'
          const updatedUserCancelSubscription = await User.findOneAndUpdate(
            { _id: userId, subscriptionId: subscriptionId },
            {
              $set: {
                suscriptionStatusCancelled:true,
                subscriptionStatusPending:false,
                subscriptionStatusConfirmed:false,
                isPremium: true,
                paypalSubscriptionCancelledAt: paypalSubscriptionCancelledAt,
                custom_id: userId,
                plan_id:
                  process.env.PAYPAL_SANDBOX_BUSSINESS_SUBSCRIPTION_PLAN_ID,
              },
            },
            { new: true }
           
  
          );
   


          if (updatedUserCancelSubscription) {
            console.log("Subscription cancelled for  user:",userId +"and the subscription id is: "+ subscriptionId);
          
            // Initialize cron job to update current time and check subscription status every second
          
            if (!cronJobs[userId]) {

              //* this is updated each second
            cronJobs[userId] = cron.schedule("* * * * * *", async () => {
             //* this is updated each day
              // cronJobs[userId] = cron.schedule("0 0 * * *", async () => {

              try {
                // const users = await User.find({ suscriptionStatusCancelled: true });
                const user = await User.findById(userId);
                if (!user) {
                  console.log(`User not found: ${userId}. Stopping cron job.`);
                  cronJobs[userId].stop();
                  delete cronJobs[userId];
                  return;
                }
                user.getCurrentTimeAfterRefresh = new Date();
                console.log(` Updated getCurrentTimeAfterRefresh for user: ${user._id} to ${user.getCurrentTimeAfterRefresh}`);

                  if (user.suscriptionStatusCancelled == true && user.getCurrentTimeAfterRefresh > user.nextBillingTime) {
                    user.isPremium = false;
                    console.log(`Subscription expired for user: ${user._id}. Stopping cron job.`);

                     // Stop the cron job and delete it from the object
                     cronJobs[user._id].stop();
                     delete cronJobs[user._id];
                  }
                  
                  await user.save();
               

                console.log("Updated subscription times and statuses for cancelled subscriptions");
              } catch (error) {
                console.error("Error updating subscription times and statuses:", error);
              }
            });
          }


          } else {
            console.log(
              `Error cancelling subscription for user: ${userId} and the subscription id is: ${subscriptionId}. User not found.`,
             
            );
          }

          return res.status(200).send("Subscription cancelled");
        } catch (error) {
          console.error("Error cancelling subscription:", error);
          return res.status(500).send("Error updating subscription status");
        }
      }
    } else {
      console.log("Failed to verify webhook signature:", verifyResponse.data);
      return res.status(401).send("Webhook signature verification failed");
    }
  } catch (error) {
    if (error.response) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx
      console.error("Error data:", error.response.data);
      console.error("Error status:", error.response.status);
      console.error("Error headers:", error.response.headers);
    } else if (error.request) {
      // The request was made but no response was received
      console.error("No response received:", error.request);
    } else {
      // Something happened in setting up the request that triggered an Error
      console.error("Error", error.message);
    }
    return res
      .status(500)
      .send("An error occurred while handling the webhook event.");
  }
});

paypalRouter.delete("/cancel-subscription", auth, async (req, res) => {
  try {
    const userId = req.user;
    const user = await User.findById(userId);

    if (!user || !user.subscriptionId) {
      return res
        .status(404)
        .json({ error: "Subscription not found for the user" });
    }

    console.log("User subscription ID:", user.subscriptionId); // Add this line

    const params = new URLSearchParams();
    params.append("grant_type", "client_credentials");

    const authResponse = await axios.post(
      "https://api-m.sandbox.paypal.com/v1/oauth2/token",
      params,
      {
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        auth: {
          username: process.env.PAYPAL_CLIENT_ID,
          password: process.env.PAYPAL_CLIENT_SECRET,
        },
      }
    );

    const response = authResponse;
    const access_token = response.data.access_token;

    const cancelResponse = await axios.post(
      `https://api-m.sandbox.paypal.com/v1/billing/subscriptions/${user.subscriptionId}/cancel`,
      { },
      {
        headers: {
          Authorization: `Bearer ${access_token}`,
        },
      }
    );
    console.log(
      "PayPal API response from /cancel-subscription:",
      cancelResponse.data
    ); // Add this line
   
    if (cancelResponse.status === 204) {
      console.log(
        "Subscription cancellation request sent to PayPal  /cancel-subscription"
      );
      return res
        .status(200)
        .json({ message: "Subscription cancellation request sent" });
    } else {
      console.error("Failed to cancel subscription:", cancelResponse.data);
      return res.status(500).json({
        error: "Failed to cancel subscription",
        details: cancelResponse.data.details,
      });
    }
  } catch (error) {
    console.error(error);
    return res.status(500).json({
      error: "An error occurred while canceling the subscription",
      details: error.response?.data?.details,
    });
  }
});

module.exports = paypalRouter;