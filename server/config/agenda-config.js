const Agenda = require("agenda");
const mongoose = require("mongoose");
const User = require("../models/user"); // Import the User model
const cron = require("node-cron");
const moment = require("moment-timezone");
const fs = require("fs");
const { JSDOM } = require("jsdom");
const { priority } = require("agenda/dist/job/priority");

// const connectToMongoDB = async () => {
//     try {
//         await mongoose.connect(process.env.MONGO_DB_URL);
//         console.log('Connected to MongoDB');
//     } catch (error) {
//         console.error('Failed to connect to MongoDB', error);
//     }
// };

// Correctly instantiate the Agenda class with the `new` keyword
// const agendaInstance = new Agenda({
//     db: { address: process.env.MONGO_DB_URL, collection: 'agendaJobs' }
// });
const agenda = new Agenda({
  db: { address: process.env.MONGO_DB_URL, collection: "agendaJobs" },
});

/*
let cronJobForTimeZones = {}; 

agendaInstance.define('update-time-zones', async (job, done) => {
  console.log(`Running job: ${job.attrs.name}`);
  // Your cron job logic here

  const user = await  User.findById(req.user);

  if (!user) {
    return res.status(404).json({ error: "User not found" });
  }

  
    // Schedule the cron job if not already scheduled
    if (!cronJobForTimeZones[user._id]) {
      cronJobForTimeZones[user._id]  =
      //  cron.schedule("0 0 * * *", async () => {
           //* this is updated each second
      cron.schedule("* * * * * *", async () => {
      
        try {
          const user = await User.findById(user._id);
          if (!user) {
            console.log(`User not found: ${user._id}. Stopping cron job.`);
            cronJobForTimeZones[user._id].stop();
            delete cronJobForTimeZones[user._id];
            return;
          }
            const userLocalTimeZone = moment()
              .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)
              .format();
            const iana = Intl.DateTimeFormat().resolvedOptions().timeZone;
            const currentTimeZoneVersion = `${moment.tz.version}-${moment.tz.dataVersion}`;
            const convertUserLocalTimeZoneToUTC = moment()
              .tz(Intl.DateTimeFormat().resolvedOptions().timeZone)
              .utc()
              .format();
  
               // Log the old and new userLocalTimeZone
            console.log(` User ${user._id}   userLocalTimeZone: ${userLocalTimeZone}`);
          
  
            // Update the user's time zone if necessary
            if ( user.currentTimeZoneVersion !== currentTimeZoneVersion
               || user.iana !== iana
              || user.userLocalTimeZone !== userLocalTimeZone ) {
  
              user.iana = iana;
              user.userLocalTimeZone = userLocalTimeZone;
              user.currentTimeZoneVersion = currentTimeZoneVersion;
              user.convertUserLocalTimeZoneToUTC = convertUserLocalTimeZoneToUTC;
              await user.save();
            }
            await user.save();

            console.log('Time zones   updated  successfully if is a new user or old user');
        } catch (error) {
          console.error("Error   updating time zones:", error);
        }
      });
      console.log(`cronJobForTimeZones  scheduled  for  user: ${user._id}`);
    }

    
  // res.json({ user, token: req.token });
  // console.log("User data refreshed:", user );


  console.log('Updating time zones... ');
  done();
});

*/

agenda.define("welcome", {priority: 'lowest'}, () => {
  console.log("Welcome to Agenda  cc");
});

agenda.define("scrape_hn",{priority: 'high'}, async () => {
  const response = await fetch("https://news.ycombinator.com/");
  const html = await response.text();

  const document = new JSDOM(html).window.document;
  const articlesTiles = [...document.querySelectorAll(".athing")];
  const articleScores = articlesTiles.map(article => article.nextSibling);

  const links = articlesTiles.map(article =>
    article.querySelector(".titleline > a")
  );
  const scores = articleScores.map(score => score.querySelector(".score"));
  const articles = links.map((link, index) => {
    let score = scores[index]?.textContent || 0
    return {
      name: link.textContent,
      url: link.href,
      score: typeof score === 'string' ? parseInt(score.split()[0])  : score
    };
  })                                  

  articles.sort((a,b) => {
    return b.score -a.score
  })

  fs.writeFileSync(
    'top_articles.json',
    JSON.stringify(articles.slice(0,5), null, '\t')

  )

  await fetch('https://uptime.betterstack.com/api/v1/heartbeat/TBGoAeRD4nuw5q8KfjhXGWov')
  // console.log(articles[0])
  // console.log(articles[articles.length-1])
});

async function startAgenda() {
  await agenda.start();
  // await agenda.every('1 second', 'welcome');
  await agenda.every("1 second", "scrape_hn");
}
startAgenda().catch((err) => {
  console.error("Error starting Agenda:", err);
});

async function graceful() {
  await agenda.stop();
  await agenda.cancel('scrape_hn');
  await agenda.cancel('welcome');
  process.exit(0);
}

process.on("SIGTERM", graceful);
process.on("SIGINT", graceful);

// agendaInstance.on('ready',async  () => {
//     console.log('Connected to Agenda');
//  await    agendaInstance.start(); // Ensure agenda starts processing jobs `
//     connectToMongoDB();
// });

// module.exports = agendaInstance;
module.exports = agenda;
