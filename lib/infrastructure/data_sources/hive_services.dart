import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../presentation/notifiers/providers.dart';



class HiveServices {
  static const boxName = "timerBox";
  static const pomodoroKey = "pomodoroTimer";
  
/// * MONGO DB
  static const shortBreakKey = "shortBreakTimer";
  static const longBreakKey = "longBreakTimer";
  static const longBreakIntervalKey = "longBreakInterval";
  static const alarmSoundKey = "alarmSound";
  static const notificationSwitchKey = "notificationSwitch";
  static const pomodoroColorKey = "pomodoroColor";
  static const darkPomodoroColorKey = "darkPomodoroColor";
  static const shortBreakColorKey = "shortBreakColor";
  static const darkShortBreakColorKey = "darkShortBreakColor";
  static const longBreakColorKey = "longBreakColor";
  static const darkLongBreakColorKey = "darkLongBreakColor";
  static const themeModeKey = "themeMode";
  static const userProgressKey = "userProgress";
  static const currentTimerTypeKey = "currentTimerType";
  static const ongoingPomodoroKey = "ongoingPomodoro";
  static const unfinishedPomodoroKey = "unfinishedPomodoro";
  static const animationProgressKey = "animationProgress";
  static const baseHeightKey = "baseHeight";
  static const todoListLengthKey = "todoListLength";
  static const checkboxStatePrefix = "checkboxState_";
  static const titlePrefix = "title_";
  static const descriptionPrefix = "description_";
  static const _keyToken = 'x-auth-token';
  static const pomodoroDurationsKey = "pomodoroDurations";
  static const pomodoroTimeKey = 'pomodoroRemainingTime';
  static const shortBreakTimeKey = 'shortBreakRemainingTime';
  static const longBreakTimeKey = 'longBreakRemainingTime';
  static const lastPomodoroDateKey = 'lastPomodoroDateKey';
  static const pomodoroEndTimeKey = 'pomodoroEndTime';
  static const shortBreakEndTimeKey = 'shortBreakEndTime';
  static const longBreakEndTimeKey = 'longBreakEndTime';

  static Future<Box> openBox() async {
    return await Hive.openBox(boxName);
  }

  static Future<void> saveTimerValue(String key, int value) async {
    final box = await openBox();
    box.put(key, value);
  }

  static Future<int> retrieveDefaultPomodoroTimerValue(String key) async {
    final box = await openBox();
    return box.get(key, defaultValue: 25);
  }
/// * MONGO DB
  static Future<int> retrieveDefaultShortBreakTimerValue(String key) async {
    final box = await openBox();
    return box.get(key, defaultValue: 5);
  }

  static Future<int> retrieveDefaultLongBreakTimerValue(String key) async {
    final box = await openBox();
    return box.get(key, defaultValue: 15);
  }

  static Future<int> retrieveDefaultLongBreakIntervalValue(String key) async {
    final box = await openBox();
    return box.get(key, defaultValue: 4);
  }

  static Future<void> saveAllTimerValues(int pomodoro, int shortBreak,
      int longBreak, int longBreakInterval) async {
    await saveTimerValue(pomodoroKey, pomodoro);
    await saveTimerValue(shortBreakKey, shortBreak);
    await saveTimerValue(longBreakKey, longBreak);
    await saveTimerValue(longBreakIntervalKey, longBreakInterval);
  }

  static Future<void> retrieveAllTimerValues(Ref ref) async {
    ref.read(pomodoroTimerProvider.notifier).state =
        await retrieveDefaultPomodoroTimerValue(pomodoroKey);
    ref.read(shortBreakProvider.notifier).state =
        await retrieveDefaultShortBreakTimerValue(shortBreakKey);
    ref.read(longBreakProvider.notifier).state =
        await retrieveDefaultLongBreakTimerValue(longBreakKey);
    ref.read(longBreakIntervalProvider.notifier).state =
        await retrieveDefaultLongBreakIntervalValue(longBreakIntervalKey);
  }

  static Future<void> saveAlarmSoundValue(String value) async {
    final box = await openBox();
    box.put(alarmSoundKey, value);
  }

  static Future<String> retrieveAlarmSoundValue() async {
    final box = await openBox();
    return box.get(alarmSoundKey, defaultValue: 'assets/sounds/Flashpoint.wav');
  }

  static Future<void> saveNotificationSwitchState(bool state) async {
    final box = await openBox();
    box.put(notificationSwitchKey, state);
  }

  static Future<bool> retrieveNotificationSwitchState() async {
    final box = await openBox();
    return box.get(notificationSwitchKey, defaultValue: false);
  }

  static Future<void> saveColorValue(String key, Color value) async {
    final box = await openBox();
    box.put(key, value.value);
  }

  static Future<Color> retrieveColorValue(
      String key, Color defaultValue) async {
    final box = await openBox();
    int colorValue = box.get(key, defaultValue: defaultValue.value);
    return Color(colorValue);
  }

  static Future<void> saveAllColorValues(
    
      Color darkPomodoroColor,
      Color darkShortBreakColor,
      Color darkLongBreakColor) async {
    // await saveColorValue(pomodoroColorKey, pomodoroColor);
    await saveColorValue(darkPomodoroColorKey, darkPomodoroColor);
    // await saveColorValue(shortBreakColorKey, shortBreakColor);
    await saveColorValue(darkShortBreakColorKey, darkShortBreakColor);
    // await saveColorValue(longBreakColorKey, longBreakColor);
    await saveColorValue(darkLongBreakColorKey, darkLongBreakColor);
  }

  static Future<void> retrieveAllColorValues(Ref ref) async {
    // ref.read(pomodoroColorProvider.notifier).state =
    //     await retrieveColorValue(pomodoroColorKey, const Color(0xFF74F143));
    ref.read(darkPomodoroColorProvider.notifier).state =
        await retrieveColorValue(darkPomodoroColorKey, const Color.fromARGB(255, 0, 0, 0));
    // ref.read(shortBreakColorProvider.notifier).state =
    //     await retrieveColorValue(shortBreakColorKey, const Color(0xffff9933));
    ref.read(darkShortBreakColorProvider.notifier).state =
        await retrieveColorValue(
            darkShortBreakColorKey, const Color.fromARGB(255, 0, 0, 0));

    // ref.read(longBreakColorProvider.notifier).state =
    //     await retrieveColorValue(longBreakColorKey, const Color(0xFF43DDF1));
    ref.read(darkLongBreakColorProvider.notifier).state =
        await retrieveColorValue(
            darkLongBreakColorKey, const Color.fromARGB(255, 0, 0, 0));
  }

  static Future<void> saveThemeMode(ThemeMode mode) async {
    final box = await openBox();
    box.put(themeModeKey, mode == ThemeMode.dark ? 'dark' : 'dark');
  }

  static Future<ThemeMode> retrieveThemeMode() async {
    final box = await openBox();
    String mode = box.get(themeModeKey, defaultValue: 'dark');
    return mode == 'dark' ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> saveUserProgress(List<bool> progress) async {
    final box = await openBox();
    box.put(userProgressKey, progress);
  }

  static Future<List<bool>> retrieveUserProgress() async {
    final box = await openBox();
    List<dynamic> dynamicList = box.get(userProgressKey, defaultValue: []);
    return dynamicList.cast<bool>();
  }

  static Future<void> saveCurrentTimerType(String timerType) async {
    final box = await openBox();
    box.put(currentTimerTypeKey, timerType);
  }

  static Future<String> retrieveCurrentTimerType() async {
    final box = await openBox();
    return box.get(currentTimerTypeKey, defaultValue: 'Pomodoro');
  }

  static Future<void> saveOngoingPomodoro(bool ongoingPomodoro) async {
    final box = await openBox();
    box.put(ongoingPomodoroKey, ongoingPomodoro);
  }

  static Future<bool> retrieveOngoingPomodoro() async {
    final box = await openBox();
    return box.get(ongoingPomodoroKey, defaultValue: false);
  }

  static Future<void> saveUnfinishedPomodoro(bool unfinishedPomodoro) async {
    final box = await openBox();
    box.put(unfinishedPomodoroKey, unfinishedPomodoro);
  }

  static Future<bool> retrieveUnfinishedPomodoro() async {
    final box = await openBox();
    return box.get(unfinishedPomodoroKey, defaultValue: false);
  }

  static Future<void> saveAnimationProgress(double progress) async {
    final box = await openBox();
    box.put(animationProgressKey, progress);
  }

  static Future<double> retrieveAnimationProgress() async {
    final box = await openBox();
    return box.get(animationProgressKey, defaultValue: 0.0);
  }

  static Future<void> saveBaseHeight(double height) async {
    final box = await openBox();
    box.put(baseHeightKey, height);
  }

  static Future<double> retrieveBaseHeight() async {
    final box = await openBox();
    return box.get(baseHeightKey, defaultValue: 0.0);
  }

  static Future<void> saveTodoListLength(int length) async {
    final box = await openBox();
    box.put(todoListLengthKey, length);
  }

  static Future<int> retrieveTodoListLength() async {
    final box = await openBox();
    return box.get(todoListLengthKey, defaultValue: 0);
  }

  static Future<void> saveCheckboxState(String todoId, bool isActive) async {
    final box = await openBox();
    box.put(checkboxStatePrefix + todoId, isActive);
  }

  static Future<bool?> retrieveCheckboxState(String todoId) async {
    final box = await openBox();
    bool? value = box.get(
      checkboxStatePrefix + todoId,
    );
    return value;
  }

  static Future<void> deleteCheckboxState(String todoId) async {
    final box = await openBox();
    box.delete(checkboxStatePrefix + todoId);
  }

  static Future<void> saveTodoTitle(String todoId, String title) async {
    final box = await openBox();
    box.put(titlePrefix + todoId, title);
  }

  static Future<String?> retrieveTodoTitle(String todoId) async {
    final box = await openBox();
    return box.get(titlePrefix + todoId);
  }

  static Future<void> saveTodoDescription(
      String todoId, String description) async {
    final box = await openBox();
    box.put(descriptionPrefix + todoId, description);
  }

  static Future<String?> retrieveTodoDescription(String todoId) async {
    final box = await openBox();
    return box.get(descriptionPrefix + todoId);
  }

  static Future<void> deleteTodoTitle(String todoId) async {
    final box = await openBox();
    box.delete(titlePrefix + todoId);
  }

  static Future<void> deleteTodoDescription(String todoId) async {
    final box = await openBox();
    box.delete(descriptionPrefix + todoId);
  }

  static Future<void> saveTodoUUIDList(List<String> uuidList) async {
    final box = await openBox();
    box.put('uuidList', uuidList);
  }

  static Future<List<String>?> retrieveTodoUUIDList() async {
    final box = await openBox();
    var retrievedList = box.get('uuidList');

    if (retrievedList != null) {
      return List<String>.from(retrievedList);
    }
    return null;
  }

  static Future<void> deleteTodoUUID(String uuidToDelete) async {
    final box = await openBox();
    var currentUUIDList = box.get('uuidList');

    if (currentUUIDList != null) {
      List<String> updatedList = List<String>.from(currentUUIDList);
      updatedList.remove(uuidToDelete);
      box.put('uuidList', updatedList);
    }
  }

  static Future<void> saveFocusedTodoUUID(String? uuid) async {
    final box = await openBox();
    box.put('focusedUUID', uuid);
  }

  static Future<String?> retrieveFocusedTodoUUID() async {
    final box = await openBox();
    return box.get('focusedUUID');
  }

  static Future<void> saveTodoFocusState(String id, bool isFocused) async {
    final box = await openBox();
    await box.put('$id-isFocused', isFocused);
  }

  static Future<void> setToken(String token) async {
    final box = await openBox();
    box.put(_keyToken, token);
  }

  static Future<String?> getToken() async {
    final box = await openBox();
    String? token = box.get(_keyToken);
    return token;
  }

  static Future<void> savePomodoroDuration(Duration duration) async {
    final box = await openBox();
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});
    Map<String, int> durations =
        rawDurations.map((key, value) => MapEntry(key as String, value as int));

    String today = DateFormat('dd/MM/yyyy').format(DateTime.now());

    if (durations.containsKey(today)) {
      durations[today] = durations[today]! + duration.inSeconds;
    } else {
      durations[today] = duration.inSeconds;
    }

    box.put(pomodoroDurationsKey, durations);
  }


  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForWeek() async {
    final box = await openBox();
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});
    DateTime now = DateTime.now();
    DateTime lastWeek = now.subtract(const Duration(days: 7));

    Map<String, Duration> weeklyData = {};
    rawDurations.forEach((key, value) {
      DateTime date = DateFormat('dd/MM/yyyy').parse(key);
      if (date.isAfter(lastWeek)) {
        weeklyData[key as String] = Duration(seconds: value as int);
      }
    });
    return weeklyData;
  }

  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForMonth() async {
    final box = await openBox();
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});
    DateTime now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month - 1, now.day);

    Map<String, Duration> monthlyData = {};
    Map<String, Duration> yearlyData = {};

    for (int i = 0; i <= now.difference(startDate).inDays; i++) {
      String key =
          DateFormat('dd/MM/yyyy').format(startDate.add(Duration(days: i)));
      if (rawDurations.containsKey(key)) {
        monthlyData[key] = Duration(seconds: rawDurations[key] as int);
      } else {
        monthlyData[key] = Duration.zero;
      }
    }
    for (int i = 0; i < 7 * 53; i++) {
      DateTime date = DateTime.now().subtract(Duration(days: i));
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      yearlyData[formattedDate] = const Duration(seconds: 0); // default value
    }

    return monthlyData;
  }

  static Future<Map<String, Duration>>
      retrievePomodoroDurationsForYear() async {
    final box = await openBox();
    Map<dynamic, dynamic> rawDurations =
        box.get(pomodoroDurationsKey, defaultValue: {});
    DateTime now = DateTime.now();

    Map<int, Duration> monthlyData = {};
    for (var i = 1; i <= 12; i++) {
      monthlyData[i] = Duration.zero;
    }

    rawDurations.forEach((key, value) {
      DateTime date = DateFormat('dd/MM/yyyy').parse(key);
      if (date.year == now.year) {
        monthlyData[date.month] =
            monthlyData[date.month]! + Duration(seconds: value as int);
      }
    });

    Map<String, Duration> result = {};
    monthlyData.forEach((month, duration) {
      String monthName = DateFormat('MMM').format(DateTime(now.year, month));
      result[monthName] = duration;
    });

    Map<String, Duration> sortedResult = {};
    List<String> sortedMonths = generateYearMonths();
    for (var month in sortedMonths) {
      if (result.containsKey(month)) {
        sortedResult[month] = result[month]!;
      }
    }

    return sortedResult;
  }

  static List<String> generateYearMonths() {
    final now = DateTime.now();
    List<String> months = List.generate(
      12,
      (index) => DateFormat('MMM').format(
        DateTime(now.year, index + 1),
      ),
    );
    return [...months.sublist(now.month), ...months.sublist(0, now.month)];
  }



  static Future<Map<String, Duration>> retrieveGithubYearlyChartData() async {
    final box = await openBox();
    Map<dynamic, dynamic> rawData =
        box.get(pomodoroDurationsKey, defaultValue: {});

    DateTime today = DateTime.now();
    Map<String, Duration> yearlyData = {};

    for (int i = 0; i < 365; i++) {
      DateTime date = today.subtract(Duration(days: i));
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);
      yearlyData[formattedDate] = const Duration(seconds: 0);
    }

    rawData.forEach((key, value) {
      DateTime date = DateFormat('dd/MM/yyyy').parse(key as String);
      String dateKey = DateFormat('dd/MM/yyyy').format(date);
      yearlyData.update(
          dateKey, (existing) => existing + Duration(seconds: value as int),
          ifAbsent: () => Duration(seconds: value as int));
    });

    return yearlyData;
  }



  static Future<void> saveRemainingTimerValue(
      String timerType, int value) async {
    final box = await openBox();
    String key;
    switch (timerType) {
      case 'Pomodoro':
        key = pomodoroTimeKey;
        break;
      case 'Short Break':
        key = shortBreakTimeKey;
        break;
      case 'Long Break':
        key = longBreakTimeKey;
        break;
      default:
        return;
    }
    box.put(key, value);
  }

  static Future<int> retrieveRemainingTimerValue(String timerType) async {
    final box = await openBox();
    String? key;
    switch (timerType) {
      case 'Pomodoro':
        key = pomodoroTimeKey;
        break;
      case 'Short Break':
        key = shortBreakTimeKey;
        break;
      case 'Long Break':
        key = longBreakTimeKey;
        break;
      default:
        key = null;
    }
    if (key == null) {
      throw Exception('Unsupported timer type: $timerType');
    }
    return box.get(key);
  }

  static Future<void> saveStartTime(DateTime startTime) async {
    final box = await openBox();
    box.put('startTimeKey', startTime.toIso8601String());
  }

  static Future<DateTime?> retrieveStartTime() async {
    final box = await openBox();
    String? isoDate = box.get('startTimeKey');
    if (isoDate != null) {
      return DateTime.parse(isoDate);
    }
    return null;
  }

  Future<void> setCsrfToken(String csrfToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('csrfToken', csrfToken);
  }

  Future<String?> getCsrfToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('csrfToken');
  }
}