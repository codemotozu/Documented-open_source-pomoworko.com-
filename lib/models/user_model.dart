import 'dart:convert';

import 'timeframe_entry.dart';



class UserModel {
  final String email;
  final String name;
  final String profilePic;
  final String uid;
  final String token;
  final bool isPremium;
  final String subscriptionId;
  final bool suscriptionStatusCancelled;
  final bool subscriptionStatusConfirmed;
  final bool subscriptionStatusPending;
  final DateTime? nextBillingTime;
  final DateTime? startTimeSubscriptionPayPal;
  final DateTime? paypalSubscriptionCancelledAt;
  final DateTime? userLocalTimeZone;
  final int pomodoroTimer;
  final int shortBreakTimer;
  final int longBreakTimer;
  final int longBreakInterval;
  final String selectedSound;
  final bool browserNotificationsEnabled;
  final String pomodoroColor;
  final String shortBreakColor;
  final String longBreakColor;
  final List<bool> pomodoroStates;
  final bool toDoHappySadToggle;
  final bool taskDeletionByTrashIcon;
  final String taskCardTitle;
  final List<String> projectName; 
  final int selectedContainerIndex;
   final List<TimeframeEntry> weeklyTimeframes;
  final List<TimeframeEntry> monthlyTimeframes;
  final List<TimeframeEntry> yearlyTimeframes;


  UserModel({
    required this.email,
    required this.name,
    required this.profilePic,
    required this.uid,
    required this.token,
    required this.isPremium,
    required this.subscriptionId,
    required this.suscriptionStatusCancelled,
    required this.subscriptionStatusConfirmed,
    required this.subscriptionStatusPending,
    required this.nextBillingTime,
    required this.startTimeSubscriptionPayPal,
    required this.paypalSubscriptionCancelledAt,
    required this.userLocalTimeZone,
    required this.pomodoroTimer,
    required this.shortBreakTimer,
    required this.longBreakTimer,
    required this.longBreakInterval,
    required this.selectedSound,
    required this.browserNotificationsEnabled,
    required this.pomodoroColor,
    required this.shortBreakColor,
    required this.longBreakColor,
    required this.pomodoroStates,
    required this.toDoHappySadToggle,
    required this.taskDeletionByTrashIcon,
    required this.taskCardTitle,
    this.projectName = const ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '], // Default value
    required this.selectedContainerIndex,
     required this.weeklyTimeframes,
    required this.monthlyTimeframes,
    required this.yearlyTimeframes,

  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'profilePic': profilePic,
      'uid': uid,
      'token': token,
      'isPremium': isPremium,
      'subscriptionId': subscriptionId,
      'suscriptionStatusCancelled': suscriptionStatusCancelled,
      'subscriptionStatusConfirmed': subscriptionStatusConfirmed,
      'subscriptionStatusPending': subscriptionStatusPending,
      'nextBillingTime': nextBillingTime?.toIso8601String(),
      'startTimeSubscriptionPayPal':
          startTimeSubscriptionPayPal?.toIso8601String(),
      'paypalSubscriptionCancelledAt':
          paypalSubscriptionCancelledAt?.toIso8601String(),
      'userLocalTimeZone': userLocalTimeZone?.toIso8601String(),
      'pomodoroTimer': pomodoroTimer,
      'shortBreakTimer': shortBreakTimer,
      'longBreakTimer': longBreakTimer,
      'longBreakInterval': longBreakInterval,
      'selectedSound': selectedSound,
      'browserNotificationsEnabled': browserNotificationsEnabled,
      'pomodoroColor': pomodoroColor,
      'shortBreakColor': shortBreakColor,
      'longBreakColor': longBreakColor,
      'pomodoroStates': pomodoroStates,
      'toDoHappySadToggle': toDoHappySadToggle,
      'taskDeletionByTrashIcon': taskDeletionByTrashIcon,
      'taskCardTitle': taskCardTitle,
      'projectName': projectName,
      'selectedContainerIndex': selectedContainerIndex,
        'weeklyTimeframes': weeklyTimeframes.map((e) => e.toMap()).toList(),
      'monthlyTimeframes': monthlyTimeframes.map((e) => e.toMap()).toList(),
      'yearlyTimeframes': yearlyTimeframes.map((e) => e.toMap()).toList(),
   
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      uid: map['_id'] ?? '',
      token: map['token'] ?? '',
      isPremium: map['isPremium'] ?? false,
      subscriptionId: map['subscriptionId'] ?? '',
      suscriptionStatusCancelled: map['suscriptionStatusCancelled'] ?? false,
      subscriptionStatusConfirmed: map['subscriptionStatusConfirmed'] ?? false,
      subscriptionStatusPending: map['subscriptionStatusPending'] ?? false,
      nextBillingTime: map['nextBillingTime'] != null
          ? DateTime.parse(map['nextBillingTime']).toUtc()
          : null,
      startTimeSubscriptionPayPal: map['startTimeSubscriptionPayPal'] != null
          ? DateTime.parse(map['startTimeSubscriptionPayPal']).toUtc()
          : null,
      paypalSubscriptionCancelledAt:
          map['paypalSubscriptionCancelledAt'] != null
              ? DateTime.parse(map['paypalSubscriptionCancelledAt']).toUtc()
              : null,
      userLocalTimeZone: map['userLocalTimeZone'] != null
          ? DateTime.parse(map['userLocalTimeZone']).toUtc()
          : null,
      pomodoroTimer: map['pomodoroTimer'] ?? 0,
      shortBreakTimer: map['shortBreakTimer'] ?? 0,
      longBreakTimer: map['longBreakTimer'] ?? 0,
      longBreakInterval: map['longBreakInterval'] ?? 0,
      selectedSound: map['selectedSound'] ?? '',
      browserNotificationsEnabled: map['browserNotificationsEnabled'] ?? false,
      pomodoroColor: map['pomodoroColor'] ?? '#74F143',
      shortBreakColor: map['shortBreakColor'] ?? '#ff9933',
      longBreakColor: map['longBreakColor'] ?? '#0891FF',
      pomodoroStates: List<bool>.from(map['pomodoroStates'] ?? []),
      toDoHappySadToggle: map['toDoHappySadToggle'] ?? false,
      taskDeletionByTrashIcon: map['taskDeletionByTrashIcon'] ?? false,
      taskCardTitle: map['taskCardTitle'] ?? '',
      projectName: List<String>.from(map['projectName'] ?? ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']),
      selectedContainerIndex: map['selectedContainerIndex'] ?? 0,
      
       weeklyTimeframes: (map['weeklyTimeframes'] as List<dynamic>? ?? [])
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
      monthlyTimeframes: (map['monthlyTimeframes'] as List<dynamic>? ?? [])
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
      yearlyTimeframes: (map['yearlyTimeframes'] as List<dynamic>? ?? [])
          .map((e) => TimeframeEntry.fromMap(e as Map<String, dynamic>))
          .toList(),
    
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  UserModel copyWith({
    String? email,
    String? name,
    String? profilePic,
    String? uid,
    String? token,
    bool? isPremium,
    String? subscriptionId,
    bool? suscriptionStatusCancelled,
    bool? subscriptionStatusConfirmed,
    bool? subscriptionStatusPending,
    DateTime? nextBillingTime,
    DateTime? startTimeSubscriptionPayPal,
    DateTime? paypalSubscriptionCancelledAt,
    DateTime? userLocalTimeZone,
    int? pomodoroTimer,
    int? shortBreakTimer,
    int? longBreakTimer,
    int? longBreakInterval,
    String? selectedSound,
    bool? browserNotificationsEnabled,
    String? pomodoroColor,
    String? shortBreakColor,
    String? longBreakColor,
    List<bool>? pomodoroStates,
    bool? toDoHappySadToggle,
    bool? taskDeletionByTrashIcon,
    String? taskCardTitle,
    List<String>? projectName,
    int? selectedContainerIndex,
    
    List<TimeframeEntry>? weeklyTimeframes,
    List<TimeframeEntry>? monthlyTimeframes,
    List<TimeframeEntry>? yearlyTimeframes,
  }) {
    return UserModel(
      email: email ?? this.email,
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      uid: uid ?? this.uid,
      token: token ?? this.token,
      isPremium: isPremium ?? this.isPremium,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      suscriptionStatusCancelled:
          suscriptionStatusCancelled ?? this.suscriptionStatusCancelled,
      subscriptionStatusConfirmed:
          subscriptionStatusConfirmed ?? this.subscriptionStatusConfirmed,
      subscriptionStatusPending:
          subscriptionStatusPending ?? this.subscriptionStatusPending,
      nextBillingTime: nextBillingTime ?? this.nextBillingTime,
      startTimeSubscriptionPayPal:
          startTimeSubscriptionPayPal ?? this.startTimeSubscriptionPayPal,
      paypalSubscriptionCancelledAt:
          paypalSubscriptionCancelledAt ?? this.paypalSubscriptionCancelledAt,
      userLocalTimeZone: userLocalTimeZone ?? this.userLocalTimeZone,
      pomodoroTimer: pomodoroTimer ?? this.pomodoroTimer,
      shortBreakTimer: shortBreakTimer ?? this.shortBreakTimer,
      longBreakTimer: longBreakTimer ?? this.longBreakTimer,
      longBreakInterval: longBreakInterval ?? this.longBreakInterval,
      selectedSound: selectedSound ?? this.selectedSound,
      browserNotificationsEnabled:
          browserNotificationsEnabled ?? this.browserNotificationsEnabled,
      pomodoroColor: pomodoroColor ?? this.pomodoroColor,
      shortBreakColor: shortBreakColor ?? this.shortBreakColor,
      longBreakColor: longBreakColor ?? this.longBreakColor,
      pomodoroStates: pomodoroStates ?? this.pomodoroStates,
      toDoHappySadToggle: toDoHappySadToggle ?? this.toDoHappySadToggle,
      taskDeletionByTrashIcon:
          taskDeletionByTrashIcon ?? this.taskDeletionByTrashIcon,
      taskCardTitle: taskCardTitle ?? this.taskCardTitle,
      projectName: projectName ?? this.projectName,
      selectedContainerIndex: selectedContainerIndex ?? this.selectedContainerIndex,
        weeklyTimeframes: weeklyTimeframes ?? this.weeklyTimeframes,
      monthlyTimeframes: monthlyTimeframes ?? this.monthlyTimeframes,
      yearlyTimeframes: yearlyTimeframes ?? this.yearlyTimeframes,
   
    );
  }
}
