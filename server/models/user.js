const mongoose = require("mongoose");
const { DateTime } = require("luxon");

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
  },
  profilePic: {
    type: String,
    required: true,
    trim: true,
  },
  isPremium: {
    type: Boolean,
    required: true,
    default: false,
  },
  subscriptionId: {
    type: String,
    required: false,
  },
  suscriptionStatusCancelled: {
    type: Boolean,
    required: false,
    default: false,
  },
  subscriptionStatusConfirmed: {
    type: Boolean,
    required: false,
    default: false,
  },
  subscriptionStatusPending: {
    type: Boolean,
    required: false,
    default: false,
  },
  nextBillingTime: {
    type: Date,
    required: false,
  },

  startTimeSubscriptionPayPal: {
    type: Date,
    required: false,
  },

  paypalSubscriptionCancelledAt: {
    type: Date,
    required: false,
  },

  getCurrentTimeAfterRefresh: {
    type: Date,
    required: false,
  },

  userLocalTimeZone: {
    type: String,
    required: true,
  },
 
  iana: {
    type: String,
    required: true,
  },

  convertUserLocalTimeZoneToUTC: {
    type: String,
    required: true,
  },
  currentTimeZoneVersion: {
    type: String,
    required: true,
  },
  custom_id: {
    type: String,
    required: false,
  },
  plan_id: {
    type: String,
    required: false,
  },
  pomodoroTimer: {
    type: Number,
    required: true,
    default: 25,
  
  },
  shortBreakTimer: {
    type: Number,
    required: true,
    default: 5,
  },
  longBreakTimer: {
    type: Number,
    required: true,
    default: 15,
  },

  longBreakInterval:{
    type: Number,
    required: true,
    default: 4,
  },
  selectedSound: {
    type: String,
    enum: ['assets/sounds/Flashpoint.wav', 'assets/sounds/Plink.wav', 'assets/sounds/Blink.wav'],
    default: 'assets/sounds/Flashpoint.wav'
  },
  browserNotificationsEnabled: {
    type: Boolean,
    required: true,
    default: false,
  },
  pomodoroColor: {
    type: String,
    default: '#74F143',
  },
  shortBreakColor: {
    type: String,
    default: '#ff9933',
  },
  longBreakColor: {
    type: String,
    default: '#0891FF',
  },

  pomodoroStates: {
    type: [Boolean],
    default: [],
  },

  toDoHappySadToggle: {
    type: Boolean,
    required: true,
    default: false,
  },

  taskDeletionByTrashIcon: {
    type: Boolean,
    required: true,
    default: false,
  },


  taskCardTitle: {
    type: String,
    required: false,
  },

  projectName: [{
    type: String,
    required: false,
  }],

  selectedContainerIndex: {
    type: Number,
    default: 0
  },
 

  weeklyTimeframes: [{
    projectIndex: Number,
    date: Date,
    duration: Number, // Store duration in seconds
  }],

  monthlyTimeframes: [{
    projectIndex: Number,
    date: Date,
    duration: Number,
  }],

  yearlyTimeframes: [{
    projectIndex: Number,
    date: Date,
    duration: Number,
  }]

});

const User = mongoose.model("User", userSchema);
module.exports = User;
