import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/timeframe_entry.dart';
import '../../models/user_model.dart';

class LocalStorageRepository {
  void setToken(String token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('x-auth-token', token);
    print("$token token set from local storage");
  }

  Future<String?> getToken() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? token = preferences.getString('x-auth-token');
    return token;
  }

  void setIsPremium(bool isPremium) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('isPremium', isPremium);
    print(
        "setIsPremium called with value from local storage repository: $isPremium");
  }

  Future<bool> getIsPremium() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('isPremium') ?? false;
  }

  void setIssuscriptionStatusCancelled(bool suscriptionStatusCancelled) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'suscriptionStatusCancelled', suscriptionStatusCancelled);
    print(
        "setIssuscriptionStatusCancelled called with value from local storage repository: $suscriptionStatusCancelled");
  }

  Future<bool> getsuscriptionStatusCancelled() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('suscriptionStatusCancelled') ?? false;
  }

  void setIsubscriptionStatusConfirmed(bool subscriptionStatusConfirmed) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'subscriptionStatusConfirmed', subscriptionStatusConfirmed);
    print(
        "setIsPremium called with value from local storage repository: $subscriptionStatusConfirmed");
  }

  Future<bool> getsubscriptionStatusConfirmed() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('subscriptionStatusConfirmed') ?? false;
  }

  // void setPomodoroTimer(int pomodoroTimer) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   await preferences.setInt('pomodoroTimer', pomodoroTimer);
  //   print("setPomodoroTimer called with value from local storage repository: $pomodoroTimer");
  // }

  // Future<int> getPomodoroTimer() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getInt('pomodoroTimer') ?? 25; // Valor predeterminado de 25 minutos
  // }

  void setPomodoroTimer(int pomodoroTimer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('pomodoroTimer', pomodoroTimer);
    print("setPomodoroTimer called with value: $pomodoroTimer");
  }

  Future<int> getPomodoroTimer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int pomodoroTimer = preferences.getInt('pomodoroTimer') ?? 25;
    print("getPomodoroTimer returned value: $pomodoroTimer");
    return pomodoroTimer;
  }

  void setShortBreakTimer(int shortBreakTimer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('shortBreakTimer', shortBreakTimer);
    print("setShortBreakTimer called with value: $shortBreakTimer");
  }

  Future<int> getShortBreakTimer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int shortBreakTimer = preferences.getInt('shortBreakTimer') ?? 5;
    print("getShortBreakTimer returned value: $shortBreakTimer");
    return shortBreakTimer;
  }

  void setLongBreakTimer(int longBreakTimer) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('longBreakTimer', longBreakTimer);
    print("setLongBreakTimer called with value: $longBreakTimer");
  }

  Future<int> getLongBreakTimer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int longBreakTimer = preferences.getInt('longBreakTimer') ?? 5;
    print("getLongBreakTimer returned value: $longBreakTimer");
    return longBreakTimer;
  }

  void setLongBreakInterval(int longBreakInterval) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('longBreakInterval', longBreakInterval);
    print("setLongBreakInterval called with value: $longBreakInterval");
  }

  Future<int> getLongBreakInterval() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    int longBreakInterval = preferences.getInt('longBreakInterval') ?? 4;
    print("getLongBreakInterval returned value: $longBreakInterval");
    return longBreakInterval;
  }

  void setSelectedSound(String selectedSound) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('selectedSound', selectedSound);
  }

  Future<String> getSelectedSound() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('selectedSound') ??
        'assets/sounds/Flashpoint.wav';
  }

  void setBrowserNotificationsEnabled(bool browserNotificationsEnabled) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'browserNotificationsEnabled', browserNotificationsEnabled);
    print(
        "setBrowserNotificationsEnabled called with value: $browserNotificationsEnabled");
  }

  Future<bool> getBrowserNotificationsEnabled() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('browserNotificationsEnabled') ?? false;
  }

  void setPomodoroColor(String color) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('pomodoroColor', color);
  }

  Future<String> getPomodoroColor() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('pomodoroColor') ?? '#74F143';
  }

//continue
  void setShortBreakColor(String color) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('shortBreakColor', color);
  }
    //continue
    //continue
    Future<String> getShortBreakColor() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.getString('shortBreakColor') ?? '#ff9933';
    }

    //continue
    void setLongBreakColor(String color) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('longBreakColor', color);
    }

    //continue
    Future<String> getLongBreakColor() async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      return preferences.getString('longBreakColor') ?? '#0891FF';
    }

  void setPomodoroStates(List<bool> states) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('pomodoroStates', jsonEncode(states));
  }

  Future<List<bool>> getPomodoroStates() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? statesString = preferences.getString('pomodoroStates');
    if (statesString != null) {
      List<dynamic> decodedList = jsonDecode(statesString);
      return decodedList.cast<bool>();
    }
    return [];
  }

  //* TASK CARD ITEMS BELOW MY "SUCCESS LIST"

    void setToDoHappySadToggle(bool toDoHappySadToggle) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
        'toDoHappySadToggle', toDoHappySadToggle);
    print(
        "setToDoHappySadToggle called with value: $toDoHappySadToggle");
  }

  Future<bool> getToDoHappySadToggle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('ToDoHappySadToggle') ?? false;
  }

//añade aqui mas codigo 


  // Añadir métodos para manejar el estado de eliminación de tareas
  void setTaskDeletionByTrashIcon(bool taskDeletionByTrashIcon) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setBool('taskDeletionByTrashIcon', taskDeletionByTrashIcon);
    print("setTaskDeletionByTrashIcon called with value: $taskDeletionByTrashIcon");
  }

  Future<bool> getTaskDeletionByTrashIcon() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool('taskDeletionByTrashIcon') ?? false;
  }

  // Método para guardar el historial de eliminación de tareas por usuario
  Future<void> saveTaskDeletionHistory(String taskId, String userId, bool deletedByTrashIcon) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String key = 'taskDeletion_${userId}_$taskId';
    final Map<String, dynamic> deletionInfo = {
      'timestamp': DateTime.now().toIso8601String(),
      'deletedByTrashIcon': deletedByTrashIcon,
    };
    await preferences.setString(key, json.encode(deletionInfo));
  }

  // Método para obtener el historial de eliminación de una tarea
  Future<Map<String, dynamic>?> getTaskDeletionHistory(String taskId, String userId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String key = 'taskDeletion_${userId}_$taskId';
    final String? deletionInfo = preferences.getString(key);
    if (deletionInfo != null) {
      return json.decode(deletionInfo);
    }
    return null;
  }

  // Nuevos métodos para TaskCardTitle
  void setTaskCardTitle(String taskCardTitle) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString('taskCardTitle', taskCardTitle);
    print("setTaskCardTitle called with value: $taskCardTitle");
  }

  Future<String> getTaskCardTitle() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString('taskCardTitle') ?? '';
  }
  

  void saveProjectNames(List<String> projectNames) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('projectNames', projectNames);
  }

  Future<List<String>> getProjectNames() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('projectNames') ?? 
      ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];
  }




 void setSelectedContainerIndex(int index) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setInt('selectedContainerIndex', index);
  }

  Future<int> getSelectedContainerIndex() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getInt('selectedContainerIndex') ?? 0;
  }










void setWeeklyTimeframes(List<TimeframeEntry> timeframes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList();
    await preferences.setString('weeklyTimeframes', jsonEncode(timeframesMap));
    print("setWeeklyTimeframes called with ${timeframes.length} entries");
  }

  Future<List<TimeframeEntry>> getWeeklyTimeframes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? timeframesString = preferences.getString('weeklyTimeframes');
    if (timeframesString != null) {
      final List<dynamic> decodedList = jsonDecode(timeframesString);
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  void setMonthlyTimeframes(List<TimeframeEntry> timeframes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList();
    await preferences.setString('monthlyTimeframes', jsonEncode(timeframesMap));
    print("setMonthlyTimeframes called with ${timeframes.length} entries");
  }

  Future<List<TimeframeEntry>> getMonthlyTimeframes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? timeframesString = preferences.getString('monthlyTimeframes');
    if (timeframesString != null) {
      final List<dynamic> decodedList = jsonDecode(timeframesString);
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  void setYearlyTimeframes(List<TimeframeEntry> timeframes) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final List<Map<String, dynamic>> timeframesMap = 
        timeframes.map((entry) => entry.toMap()).toList();
    await preferences.setString('yearlyTimeframes', jsonEncode(timeframesMap));
    print("setYearlyTimeframes called with ${timeframes.length} entries");
  }

  Future<List<TimeframeEntry>> getYearlyTimeframes() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? timeframesString = preferences.getString('yearlyTimeframes');
    if (timeframesString != null) {
      final List<dynamic> decodedList = jsonDecode(timeframesString);
      return decodedList
          .map((entry) => TimeframeEntry.fromMap(entry as Map<String, dynamic>))
          .toList();
    }
    return [];
  }


  // En local_storage_repository.dart

Future<void> clearProjectTimeframes(int projectIndex) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  
  // Limpiar weekly timeframes
  final weeklyTimeframes = await getWeeklyTimeframes();
  final filteredWeekly = weeklyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList();
   setWeeklyTimeframes(filteredWeekly);
  
  // Limpiar monthly timeframes
  final monthlyTimeframes = await getMonthlyTimeframes();
  final filteredMonthly = monthlyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList();
   setMonthlyTimeframes(filteredMonthly);
  
  // Limpiar yearly timeframes
  final yearlyTimeframes = await getYearlyTimeframes();
  final filteredYearly = yearlyTimeframes.where((tf) => tf.projectIndex != projectIndex).toList();
   setYearlyTimeframes(filteredYearly);
}
}
