const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
dotenv.config(); 

const path = require('path');
const cors = require('cors');
const authRouter = require('./routes/auth');
const paypalRouter = require('./routes/paypal'); 
const agendaInstance = require('./config/agenda-config');

dotenv.config(); 
// * IF YOU WANT TO WORK THE APP IN PRODUCTION YOU HAVE 
// * TO ADD "process.env.PORT" auth_services.dart AND THE FRONT END GOOGLE API
// * IN THE "web/index.html" FILE

const PORT = process.env.PORT || 3001;

const app = express();

if(process.env.NODE_ENV === 'production') {
   app.use((req, res, next) => {
     if (req.header('x-forwarded-proto') !== 'https')
       res.redirect(`https://${req.header('host')}${req.url}`)
     else
       next()
   })
}

app.use(cors());
app.use(express.json());
app.use('/auth',authRouter);
app.use('/paypal', paypalRouter);

const DB =  process.env.MONGO_DB_URL;


// mongoose.connect(DB).then(() => {
//    console.log("Connection successful");
// }).catch((err) => {
//    console.log(err);

// });

mongoose.connect(DB, {
 }).then(() => {
   console.log("Connection successful");
   agendaInstance.start(); // Start the Agenda instance
   console.log('Agenda instance started');

 }).catch((err) => {
   console.log(err);
 });

// Serve static files from the Flutter web app build output directory
app.use(express.static(path.join(__dirname,)));

// Serve the index.html file as the entry point to your Flutter web app
app.get('*', (req, res) => {
   res.sendFile(path.join(__dirname, 'index.html'));
});

/**
 * 
 * 
 // Servir archivos estáticos desde el directorio 'web'
app.use(express.static(path.join(__dirname, '..', 'web')));

// Servir el archivo index.html como punto de entrada a tu aplicación web Flutter
app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '..', 'web', 'index.html'));
});

 */


app.listen(PORT, () => {
   console.log(`Server is running on port ${PORT}`);
});