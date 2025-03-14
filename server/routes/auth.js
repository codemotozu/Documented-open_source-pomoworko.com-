const express = require("express");
const User = require("../models/user");
const jwt = require("jsonwebtoken");
const moment = require("moment-timezone");
const agendaInstance = require("../config/agenda-config");
const auth = require("../middlewares/auth");
const authRouter = express.Router();
const cron = require("node-cron");
let cronJobs = {};
let cronJobForTimeZones = {};

authRouter.post("/api/signup", async (req, res) => {
  try {
    const { name, email, profilePic } = req.body;
    let user = await User.findOne({ email });

    if (!user) {
      user = new User({
        email,
        profilePic,
        name,
        userLocalTimeZone: moment()
          .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)
          .format(),
        iana: Intl.DateTimeFormat().resolvedOptions().timeZone,
        currentTimeZoneVersion: `${moment.tz.version}-${moment.tz.dataVersion}`,
        convertUserLocalTimeZoneToUTC: moment()
          .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)
          .utc()
          .format(),
        isPremium: false,
        subscriptionStatusPending: true,
        suscriptionStatusCancelled: false,
        subscriptionStatusConfirmed: false,
        pomodoroTimer: 25,
        shortBreakTimer: 5,
        longBreakTimer: 15,
        longBreakInterval: 4,
        selectedSound: "assets/sounds/Flashpoint.wav",
        browserNotificationsEnabled: false,
        pomodoroColor: "#74F143",
        shortBreakColor: "#ff9933",
        longBreakColor: "#0891FF",
        pomodoroStates: [],
        toDoHappySadToggle: false,
        taskDeletionByTrashIcon: false,
        taskCardTitle: "",
        projectName: [],
        selectedContainerIndex: 0,
        weeklyTimeframes: [],
        monthlyTimeframes: [],
        yearlyTimeframes: [],
      });
    }

    user = await user.save();

    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.ACCESS_TOKEN_SECRET
    );

    await agendaInstance.schedule("1 second", "update-timezone", {
      userId: user._id,
    });
    console.log(`Scheduled job 'update-timezone' for user: ${user._id}`);

    res.json({
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        isPremium: user.isPremium,
        userLocalTimeZone: user.userLocalTimeZone,
        pomodoroTimer: user.pomodoroTimer,
        shortBreakTimer: user.shortBreakTimer,
        longBreakTimer: user.longBreakTimer,
        longBreakInterval: user.longBreakInterval,
        selectedSound: user.selectedSound,
        browserNotificationsEnabled: user.browserNotificationsEnabled,
        pomodoroColor: user.pomodoroColor,
        shortBreakColor: user.shortBreakColor,
        longBreakColor: user.longBreakColor,
        pomodoroStates: user.pomodoroStates,
        toDoHappySadToggle: user.toDoHappySadToggle,
        taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,
        taskCardTitle: user.taskCardTitle,
        projectName: user.projectName,
        selectedContainerIndex: user.selectedContainerIndex,
        weeklyTimeframes: user.weeklyTimeframes,
        monthlyTimeframes: user.monthlyTimeframes,
        yearlyTimeframes: user.yearlyTimeframes,
      },
      token,
    });
    console.log("user/api/signup  ", user);
    console.log("user/api/signup  ", token);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/login", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });

    if (!user || !(await user.comparePassword(password))) {
      return res.status(401).json({ error: "Invalid credentials" });
    }

    const token = jwt.sign(
      { id: user._id, email: user.email },
      process.env.ACCESS_TOKEN_SECRET
    );

    res.json({
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        isPremium: user.isPremium,
        userLocalTimeZone: user.userLocalTimeZone,
        pomodoroTimer: user.pomodoroTimer,
        shortBreakTimer: user.shortBreakTimer,
        longBreakTimer: user.longBreakTimer,
        longBreakInterval: user.longBreakInterval,
        selectedSound: user.selectedSound,
        browserNotificationsEnabled: user.browserNotificationsEnabled,
        pomodoroColor: user.pomodoroColor,
        shortBreakColor: user.shortBreakColor,
        longBreakColor: user.longBreakColor,
        pomodoroStates: user.pomodoroStates,
        toDoHappySadToggle: user.toDoHappySadToggle,
        taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,
        taskCardTitle: user.taskCardTitle,
        projectName: user.projectName,
        selectedContainerIndex: user.selectedContainerIndex,
        weeklyTimeframes: user.weeklyTimeframes,
        monthlyTimeframes: user.monthlyTimeframes,
        yearlyTimeframes: user.yearlyTimeframes,
      },
      token,
    });
    console.log("user/api/login  ", user);
    console.log("user/api/login  ", token);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-settings", auth, async (req, res) => {
  try {
    const {
      pomodoroTimer,
      shortBreakTimer,
      longBreakTimer,
      longBreakInterval,
      selectedSound,
      browserNotificationsEnabled,
      pomodoroColor,
      shortBreakColor,
      longBreakColor,
    } = req.body;

    const allowedSounds = [
      "assets/sounds/Flashpoint.wav",
      "assets/sounds/Plink.wav",
      "assets/sounds/Blink.wav",
    ];

    if (!allowedSounds.includes(selectedSound)) {
      return res.status(400).json({ error: "Invalid sound selection" });
    }

    if (
      pomodoroTimer === undefined ||
      shortBreakTimer === undefined ||
      longBreakTimer === undefined ||
      longBreakInterval === undefined ||
      selectedSound === undefined ||
      browserNotificationsEnabled === undefined ||
      pomodoroColor === undefined ||
      shortBreakColor === undefined ||
      longBreakColor === undefined
    ) {
      return res.status(400).json({
        error:
          "pomodoroTimer, shortBreakTimer, longBreakTimer and longBreakInterval are required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroTimer = pomodoroTimer;
    user.shortBreakTimer = shortBreakTimer;
    user.longBreakTimer = longBreakTimer;
    user.longBreakInterval = longBreakInterval;
    user.selectedSound = selectedSound;
    user.browserNotificationsEnabled = browserNotificationsEnabled;
    user.pomodoroColor = pomodoroColor;
    user.shortBreakColor = shortBreakColor;
    user.longBreakColor = longBreakColor;

    await user.save();

    res.json({
      message: "Settings updated successfully",
      pomodoroTimer: user.pomodoroTimer,
      shortBreakTimer: user.shortBreakTimer,
      longBreakTimer: user.longBreakTimer,
      longBreakInterval: user.longBreakInterval,
      selectedSound: user.selectedSound,
      browserNotificationsEnabled: user.browserNotificationsEnabled,
      pomodoroColor: user.pomodoroColor,
      shortBreakColor: user.shortBreakColor,
      longBreakColor: user.longBreakColor,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-pomodoro-states", auth, async (req, res) => {
  try {
    const { pomodoroStates } = req.body;

    if (pomodoroStates === undefined) {
      return res.status(400).json({
        error: "pomodoroStates is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroStates = pomodoroStates;
    await user.save();

    res.json({
      message: "Pomodoro states updated successfully",
      pomodoroStates: user.pomodoroStates,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/card-add-todo-task", auth, async (req, res) => {
  try {
    const { toDoHappySadToggle, taskDeletionByTrashIcon, taskCardTitle } =
      req.body;

    if (
      toDoHappySadToggle === undefined ||
      taskDeletionByTrashIcon === undefined ||
      taskCardTitle === undefined
    ) {
      return res.status(400).json({
        error: "toDoHappySadToggle is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.toDoHappySadToggle = toDoHappySadToggle;
    user.taskDeletionByTrashIcon = taskDeletionByTrashIcon;
    user.taskCardTitle = taskCardTitle;
    await user.save();

    res.json({
      message: "Todo task added successfully",
      toDoHappySadToggle: user.toDoHappySadToggle,
      taskDeletionByTrashIcon: user.taskDeletionByTrashIcon,
      taskCardTitle: user.taskCardTitle,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-project", auth, async (req, res) => {
  try {
    const { projectName, index } = req.body;

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (!user.projectName) {
      user.projectName = [];
    }

    if (index >= user.projectName.length) {
      user.projectName = [
        ...user.projectName,
        ...Array(index - user.projectName.length + 1).fill("add a project"),
      ];
    }
    user.projectName[index] = projectName;

    await user.save();

    res.json({
      message: "Project name and selected index updated successfully",
      projectName: user.projectName,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/update-container-index", auth, async (req, res) => {
  try {
    const { selectedContainerIndex } = req.body;

    if (selectedContainerIndex === undefined) {
      return res.status(400).json({
        error: "selectedContainerIndex is required",
      });
    }

    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.selectedContainerIndex = selectedContainerIndex;

    await user.save();

    res.json({
      message: "selectedContainerIndex updated successfully",

      selectedContainerIndex: user.selectedContainerIndex,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Add timeframe data for a project
authRouter.post("/api/timeframe/add", auth, async (req, res) => {
  try {
    const { projectIndex, date, duration, timeframeType } = req.body;

    // Create new timeframe entry
    const newTimeframe = {
      projectIndex,
      date: new Date(date),
      duration, // Duration in seconds
    };

    const updateQuery = {};
    const currentDate = new Date(date);

    switch (timeframeType) {
      case "weekly":
        // First pull any existing entries
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            weeklyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),
              },
            },
          },
        });

        // Then push the new entry
        updateQuery.$push = { weeklyTimeframes: newTimeframe };
        break;

      case "monthly":
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            monthlyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(currentDate.setHours(0, 0, 0, 0)),
                $lt: new Date(currentDate.setHours(23, 59, 59, 999)),
              },
            },
          },
        });

        updateQuery.$push = { monthlyTimeframes: newTimeframe };
        break;

      case "yearly":
        await User.findByIdAndUpdate(req.user, {
          $pull: {
            yearlyTimeframes: {
              projectIndex: projectIndex,
              date: {
                $gte: new Date(
                  Date.UTC(currentDate.getFullYear(), currentDate.getMonth(), 1)
                ),
                $lt: new Date(
                  Date.UTC(
                    currentDate.getFullYear(),
                    currentDate.getMonth() + 1,
                    0
                  )
                ),
              },
            },
          },
        });

        updateQuery.$push = { yearlyTimeframes: newTimeframe };
        break;

      default:
        return res.status(400).json({ error: "Invalid timeframe type" });
    }

    // Execute the update
    const user = await User.findByIdAndUpdate(req.user, updateQuery, {
      new: true,
      runValidators: true,
    });

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({ message: "Time frame data added successfully" });
  } catch (e) {
    console.error("Error in /api/timeframe/add:", e);
    res.status(500).json({ error: e.message });
  }
});

// Get weekly time frame data endpoint
authRouter.get("/api/timeframe/weekly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastWeek = new Date();
    lastWeek.setDate(lastWeek.getDate() - 7);

    const weeklyData = user.weeklyTimeframes.filter(
      (timeframe) => timeframe.date >= lastWeek
    );

    res.json(weeklyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get monthly time frame data endpoint
authRouter.get("/api/timeframe/monthly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastMonth = new Date();
    lastMonth.setMonth(lastMonth.getMonth() - 1);

    const monthlyData = user.monthlyTimeframes.filter(
      (timeframe) => timeframe.date >= lastMonth
    );

    res.json(monthlyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Get yearly time frame data endpoint
authRouter.get("/api/timeframe/yearly", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const lastYear = new Date();
    lastYear.setFullYear(lastYear.getFullYear() - 1);

    const yearlyData = user.yearlyTimeframes.filter(
      (timeframe) => timeframe.date >= lastYear
    );

    res.json(yearlyData);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});


authRouter.post("/delete-project", auth, async (req, res) => {
  try {
    const { projectIndex } = req.body;
    
    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    await User.findByIdAndUpdate(req.user, {
      $pull: {
        weeklyTimeframes: { projectIndex: projectIndex },
        monthlyTimeframes: { projectIndex: projectIndex },
        yearlyTimeframes: { projectIndex: projectIndex }
      }
    });

    if (projectIndex < user.projectName.length) {
      user.projectName[projectIndex] = "add a project";
    }

    await user.save();
    
    res.json({
      success: true,
      message: "Project and associated data deleted successfully"
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});



authRouter.get("/", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const iana = Intl.DateTimeFormat().resolvedOptions().timeZone;
    const userLocalTimeZone = moment().tz(iana).format();
    const currentTimeZoneVersion = `${moment.tz.version}-${moment.tz.dataVersion}`;
    const convertUserLocalTimeZoneToUTC = moment().tz(iana).utc().format();

    if (
      user.currentTimeZoneVersion !== currentTimeZoneVersion ||
      user.iana !== iana ||
      user.userLocalTimeZone !== userLocalTimeZone
    ) {
      user.iana = iana;
      user.userLocalTimeZone = userLocalTimeZone;
      user.currentTimeZoneVersion = currentTimeZoneVersion;
      user.convertUserLocalTimeZoneToUTC = convertUserLocalTimeZoneToUTC;
      await user.save();
      console.log(`Updated time zone for user: ${user._id}`);
    }

    if (user.suscriptionStatusCancelled === true) {
      user.getCurrentTimeAfterRefresh = new Date();
      if (user.getCurrentTimeAfterRefresh > user.nextBillingTime) {
        user.isPremium = false;
        console.log(`S ubscription expir  ed for user: ${user._id}`);
      }
      await user.save();
    }
    if (!cronJobForTimeZones[user._id]) {
      cronJobForTimeZones[user._id] = agendaInstance.create(
        " update-time-zones",
        { message: `Updating time zones for user ${user._id}` }
      );
      cronJobForTimeZones[user._id].repeatEvery("* * * * * *"); 
      cronJobForTimeZones[user._id].save();
      console.log(`Cron job scheduled for user ${user._id}`);
    }

    res.json({ user, token: req.token });
    console.log("User data refreshed:", user);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.post("/api/logout", auth, async (req, res) => {
  try {
    const user = await User.findById(req.user);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (cronJobForTimeZones[user._id]) {
      console.log(`Clearing cron job for user ${user._id}`);

      cronJobForTimeZones[user._id].remove();
      delete cronJobForTimeZones[user._id];
      console.log(`Cron job cleared for user ${user._id}`);
    }

    res.json({ msg: "Logged out successfully" });
    console.log("User logged out:", user._id);
  } catch (e) {
    console.error(e);
    res.status(500).json({ error: e.message });
  }
});

authRouter.delete(
  "/api/delete-premium-or-not-premium-user",
  auth,
  async (req, res) => {
    try {
      const user = await User.findByIdAndDelete(req.user);

      if (!user) {
        return res.status(404).json({ error: "User not found" });
      }

      if (cronJobForTimeZones[user._id]) {
        console.log(`Clearing cron job for user ${user._id}`);

        cronJobForTimeZones[user._id].remove();
        delete cronJobForTimeZones[user._id];
        console.log(`Cron job cleared for user ${user._id}`);
      }

      res.json({ msg: "Account deleted successfully" });
    } catch (e) {
      res.status(500).json({ error: e.message });
    }
  }
);

module.exports = authRouter;

authRouter.post("/update-settings", auth, async (req, res) => {
  try {
    const {
      pomodoroTimer,
      shortBreakTimer,
      longBreakTimer,
      longBreakInterval,
      selectedSound,
      browserNotificationsEnabled,
    } = req.body;

    const allowedSounds = [
      "assets/sounds/Flashpoint.wav",
      "assets/sounds/Plink.wav",
      "assets/sounds/Blink.wav",
    ];

    if (!allowedSounds.includes(selectedSound)) {
      return res.status(400).json({ error: "Invalid sound selection" });
    }

    if (
      pomodoroTimer === undefined ||
      shortBreakTimer === undefined ||
      longBreakTimer === undefined ||
      longBreakInterval === undefined ||
      selectedSound === undefined ||
      browserNotificationsEnabled === undefined
    ) {
      return res.status(400).json({
        error:
          "pomodoroTimer, shortBreakTimer, longBreakTimer and longBreakInterval are required",
      });
    }

    const user = await User.findById(req.user);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.pomodoroTimer = pomodoroTimer;
    user.shortBreakTimer = shortBreakTimer;
    user.longBreakTimer = longBreakTimer;
    user.longBreakInterval = longBreakInterval;
    user.selectedSound = selectedSound;
    user.browserNotificationsEnabled = browserNotificationsEnabled;

    await user.save();

    res.json({
      message: "Settings updated successfully",
      pomodoroTimer: user.pomodoroTimer,
      shortBreakTimer: user.shortBreakTimer,
      longBreakTimer: user.longBreakTimer,
      longBreakInterval: user.longBreakInterval,
      selectedSound: user.selectedSound,
      browserNotificationsEnabled: user.browserNotificationsEnabled,
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});
