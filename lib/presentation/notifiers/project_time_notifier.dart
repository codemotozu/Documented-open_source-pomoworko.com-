
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart';
// import 'package:pomoworko/presentation/notifiers/providers.dart';
// import 'dart:async';
// import '../repository/auth_repository.dart';


// final projectTimesProvider = StateNotifierProvider<ProjectTimesNotifier, Map<int, Map<DateTime, Duration>>>(
//   (ref) => ProjectTimesNotifier(ref),
// );

// class ProjectTimesNotifier extends StateNotifier<Map<int, Map<DateTime, Duration>>> {
//   final Ref _ref;
//   Timer? _timer;
//   DateTime? _startTime;
//   Duration _accumulatedTime = Duration.zero;
  
//   ProjectTimesNotifier(this._ref) : super({}) {
//     loadTimeframeData();
//   }

//   Future<void> loadTimeframeData() async {
//     final authRepository = _ref.read(authRepositoryProvider);
    
//     final weeklyResult = await authRepository.getTimeframeData('weekly');
//     if (weeklyResult.data != null) {
//       final weeklyData = weeklyResult.data as List<dynamic>;
//       for (var data in weeklyData) {
//         final projectIndex = data['projectIndex'] as int;
//         final date = DateTime.parse(data['date']);
//         final duration = Duration(seconds: data['duration'] as int);
//         addTimeToState(projectIndex, date, duration);
//       }
//     }
//   }

//   void startTimer(int containerIndex) {
//     if (_timer?.isActive ?? false) {
//       print('🔴 Timer already active, ignoring start request');
//       return;
//     }
    
//     print('\n🟢 TIMER START -------------');
//     print('⏰ Start time: ${DateTime.now()}');
//     print('💾 Accumulated time before start: ${_accumulatedTime.inSeconds}s');
    
//     _startTime = DateTime.now();
    
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_startTime != null) {
//         final currentTime = DateTime.now();
//         final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;
        
//         print('⏱️ Running time: ${elapsedSeconds}s');
//         print('🔄 Total time: ${(_accumulatedTime.inSeconds + elapsedSeconds)}s');
//       }
//     });
//   }

//   void pauseTimer(int containerIndex) {
//     print('\n🔴 TIMER PAUSE -------------');
    
//     if (_startTime == null) {
//       print('❌ Cannot pause: Timer was not started');
//       return;
//     }

//     final currentTime = DateTime.now();
//     final rawDifference = currentTime.difference(_startTime!);
    
//     // Usamos directamente los segundos sin ajustes adicionales
//     final elapsedSeconds = rawDifference.inSeconds;
        
//     print('⚡ Raw difference in ms: ${rawDifference.inMilliseconds}');
//     print('⏱️ Adjusted seconds: $elapsedSeconds');
    
//     final duration = Duration(seconds: elapsedSeconds);
    
//     print('⏱️ Elapsed this session: ${elapsedSeconds}s');
//     print('💾 Previous accumulated: ${_accumulatedTime.inSeconds}s');
    
//     _accumulatedTime += duration;
    
//     print('📊 New total accumulated: ${_accumulatedTime.inSeconds}s');
//     print('⏰ Pause time: $currentTime');
    
//     addTime(containerIndex, currentTime, duration);
    
//     _timer?.cancel();
//     _timer = null;
//     _startTime = null;
//   }

//   bool isTimerActive() {
//     return _timer?.isActive ?? false;
//   }

//   Duration getCurrentDuration() {
//     if (_startTime == null) return _accumulatedTime;
    
//     final currentTime = DateTime.now();
//     // Usamos directamente los segundos sin ajustes
//     final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;
//     return _accumulatedTime + Duration(seconds: elapsedSeconds);
//   }

//   void resetTimer() {
//     _timer?.cancel();
//     _timer = null;
//     _startTime = null;
//     _accumulatedTime = Duration.zero;
//     print('🔄 Timer reset - Accumulated time: ${_accumulatedTime.inSeconds}s');
//   }

//   void addTimeToState(int containerIndex, DateTime date, Duration newDuration) {
//     final normalizedDate = DateTime(date.year, date.month, date.day);
    
//     final existingDuration = state[containerIndex]?[normalizedDate] ?? Duration.zero;
//     // Aseguramos que las duraciones usen solo segundos completos
//     final totalDuration = Duration(seconds: (existingDuration + newDuration).inSeconds);
    
//     final currentContainerMap = state[containerIndex] ?? {};
    
//     state = {
//       ...state,
//       containerIndex: {
//         ...currentContainerMap,
//         normalizedDate: totalDuration,
//       },
//     };
//   }

//   Future<void> addTime(int containerIndex, DateTime date, Duration duration) async {
//     addTimeToState(containerIndex, date, duration);

//     try {
//       final authRepository = _ref.read(authRepositoryProvider);
//       final normalizedDate = DateTime(date.year, date.month, date.day);
      
//       final currentContainerMap = state[containerIndex] ?? {};
//       final totalDuration = currentContainerMap[normalizedDate] ?? Duration.zero;

//       await authRepository.addTimeframeData(
//         projectIndex: containerIndex,
//         date: date,
//         duration: totalDuration.inSeconds,
//         timeframeType: 'weekly',
//       );
//     } catch (e) {
//       print('❌ Error saving timeframe data: $e');
//     }
//   }

// /*
//   // Los métodos de obtención de tiempo ya manejan Duration, que naturalmente redondea a segundos
//   Duration getProjectTime(int containerIndex, DateTime date) {
//     final normalizedDate = DateTime(date.year, date.month, date.day);
//     return state[containerIndex]?[normalizedDate] ?? Duration.zero;
//   }

//   Duration getProjectTimeForMonth(int containerIndex, DateTime date) {
//     final normalizedDate = DateTime(date.year, date.month, date.day);
//     return state[containerIndex]?[normalizedDate] ?? Duration.zero;
//   }

//   Duration getProjectTimeForYear(int containerIndex, DateTime date) {
//     final normalizedDate = DateTime(date.year, date.month, 1);
//     final containerMap = state[containerIndex];
//     if (containerMap == null) return Duration.zero;

//     return containerMap.entries
//         .where((entry) => 
//           entry.key.year == date.year && 
//           entry.key.month == date.month)
//         .fold(Duration.zero, (prev, curr) => prev + curr.value);
//   }
// */

// Duration getProjectTime(int containerIndex, DateTime date) {
//   final normalizedDate = DateTime(date.year, date.month, date.day);
//   return state[containerIndex]?[normalizedDate] ?? Duration.zero;
// }

// // Método para vista mensual - acumula todo el tiempo del mes

// Duration getProjectTimeForMonth(int containerIndex, DateTime date) {
//   final normalizedDate = DateTime(date.year, date.month, date.day);
//   return state[containerIndex]?[normalizedDate] ?? Duration.zero;
// }

// // Método para vista anual - acumula tiempo por mes
// Duration getProjectTimeForYear(int containerIndex, DateTime date) {
//   final containerMap = state[containerIndex];
//   if (containerMap == null) return Duration.zero;

//   return containerMap.entries
//       .where((entry) => 
//         entry.key.year == date.year && 
//         entry.key.month == date.month)
//       .fold(Duration.zero, (prev, curr) => prev + curr.value);
// }


//   Duration getTotalProjectTime(int containerIndex) {
//     final containerMap = state[containerIndex];
//     if (containerMap == null) return Duration.zero;
//     return containerMap.values.fold(Duration.zero, (prev, curr) => prev + curr);
//   }

//   Duration getMonthlyDuration(int containerIndex, DateTime date) {
//     final normalizedDate = DateTime(date.year, date.month, date.day);
//     return state[containerIndex]?[normalizedDate] ?? Duration.zero;
//   }

//   Duration getYearlyDuration(int containerIndex, DateTime date) {
//     final containerMap = state[containerIndex];
//     if (containerMap == null) return Duration.zero;

//     final currentMonthStart = DateTime(date.year, date.month, 1);
//     final nextMonthStart = DateTime(date.year, date.month + 1, 1);

//     return containerMap.entries
//         .where((entry) => 
//           entry.key.isAfter(currentMonthStart.subtract(const Duration(days: 1))) &&
//           entry.key.isBefore(nextMonthStart))
//         .fold(Duration.zero, (prev, curr) => prev + curr.value);
//   }
// /*
//   List<Duration> getYearlyData(int containerIndex, DateTime now) {
//     return List.generate(12, (index) {
//       final month = DateTime(now.year, index + 1);
//       return getYearlyDuration(containerIndex, month);
//     });
//   }
// */

// // Método helper para obtener datos anuales completos
// List<Duration> getYearlyData(int containerIndex, DateTime now) {
//   return List.generate(12, (index) {
//     // Calculamos el mes actual menos el índice para ir hacia atrás
//     int month = now.month - index;
//     int year = now.year;
    
//     // Ajustamos el año si necesitamos ir al año anterior
//     if (month <= 0) {
//       month += 12;
//       year -= 1;
//     }
    
//     final date = DateTime(year, month, 1);
//     return getProjectTimeForYear(containerIndex, date);
//   }).reversed.toList(); // Revertimos para mantener el orden cronológico
// }

// // Método helper para obtener datos mensuales completos

// List<Duration> getMonthlyData(int containerIndex, DateTime now) {
//   final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
  
//   return List.generate(daysInMonth, (index) {
//     final date = DateTime(now.year, now.month, daysInMonth - index);
//     return getProjectTime(containerIndex, date); // Usamos getProjectTime para obtener el tiempo real de cada día
//   });
// }

//   void resetState() {
//     state = {};
//     resetTimer();
//   }

// // En project_time_notifier.dart

// void clearProjectData(int projectIndex) async {
//   // Limpiar el estado actual
//   state = Map.from(state)..remove(projectIndex);
  
//   // Limpiar el almacenamiento local
//   await _ref.read(localStorageRepositoryProvider).clearProjectTimeframes(projectIndex);
  
//   // Resetear el timer si está activo para este proyecto
//   if (_startTime != null) {
//     resetTimer();
//   }
// }
// }














import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:pomoworko/presentation/notifiers/providers.dart';
import 'dart:async';
import '../repository/auth_repository.dart';

final projectTimesProvider = StateNotifierProvider<ProjectTimesNotifier, Map<int, Map<DateTime, Duration>>>(
  (ref) => ProjectTimesNotifier(ref),
);

class ProjectTimesNotifier extends StateNotifier<Map<int, Map<DateTime, Duration>>> {
  final Ref _ref;
  Timer? _timer;
  DateTime? _startTime;
  Duration _accumulatedTime = Duration.zero;
  final Set<String> _processedTimeframes = {};

  ProjectTimesNotifier(this._ref) : super({}) {
    loadTimeframeData();
  }

  Future<void> loadTimeframeData() async {
    print('📊 Loading timeframe data...');
    final authRepository = _ref.read(authRepositoryProvider);
    
    print('🔄 Loading weekly timeframes...');
    final result = await authRepository.getTimeframeData('weekly');
    if (result.data != null) {
      final count = (result.data as List).length;
      print('✅ Loaded $count weekly timeframes');
    } else {
      print('❌ Failed to load weekly timeframes: ${result.error}');
    }
    
    print('📊 Current state after loading:');
    state.forEach((projectIndex, timeEntries) {
      print('Project $projectIndex: ${timeEntries.length} entries');
    });
  }

  void startTimer(int containerIndex) {
    if (_timer?.isActive ?? false) {
      print('🔴 Timer already active, ignoring start request');
      return;
    }
    
    print('\n🟢 TIMER START -------------');
    print('⏰ Start time: ${DateTime.now()}');
    print('💾 Accumulated time before start: ${_accumulatedTime.inSeconds}s');
    
    _startTime = DateTime.now();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startTime != null) {
        final currentTime = DateTime.now();
        final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;
        
        print('⏱️ Running time: ${elapsedSeconds}s');
        print('🔄 Total time: ${(_accumulatedTime.inSeconds + elapsedSeconds)}s');
      }
    });
  }

  void pauseTimer(int containerIndex) {
    print('\n🔴 TIMER PAUSE -------------');
    
    if (_startTime == null) {
      print('❌ Cannot pause: Timer was not started');
      return;
    }

    final currentTime = DateTime.now();
    final rawDifference = currentTime.difference(_startTime!);
    final elapsedSeconds = rawDifference.inSeconds;
    
    print('⚡ Raw difference in ms: ${rawDifference.inMilliseconds}');
    print('⏱️ Adjusted seconds: $elapsedSeconds');
    
    final duration = Duration(seconds: elapsedSeconds);
    
    print('⏱️ Elapsed this session: ${elapsedSeconds}s');
    print('💾 Previous accumulated: ${_accumulatedTime.inSeconds}s');
    
    _accumulatedTime += duration;
    
    print('📊 New total accumulated: ${_accumulatedTime.inSeconds}s');
    print('⏰ Pause time: $currentTime');
    
    addTime(containerIndex, currentTime, duration);
    
    _timer?.cancel();
    _timer = null;
    _startTime = null;
  }

  bool isTimerActive() {
    return _timer?.isActive ?? false;
  }

  Duration getCurrentDuration() {
    if (_startTime == null) return _accumulatedTime;
    
    final currentTime = DateTime.now();
    final elapsedSeconds = currentTime.difference(_startTime!).inSeconds;
    return _accumulatedTime + Duration(seconds: elapsedSeconds);
  }

  void resetTimer() {
    _timer?.cancel();
    _timer = null;
    _startTime = null;
    _accumulatedTime = Duration.zero;
    print('🔄 Timer reset - Accumulated time: ${_accumulatedTime.inSeconds}s');
  }

  void addTimeToState(int containerIndex, DateTime date, Duration newDuration) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final timeframeKey = '$containerIndex-${normalizedDate.toIso8601String()}';
    
    // Create a new map for the entire state
    Map<int, Map<DateTime, Duration>> newState = Map.from(state);
    
    // Ensure the container map exists
    if (!newState.containsKey(containerIndex)) {
      newState[containerIndex] = {};
    }
    
    // Get the existing duration for this date, if any
    final existingDuration = newState[containerIndex]![normalizedDate] ?? Duration.zero;
    
    // Add the new duration to the existing one
    final totalDuration = Duration(seconds: existingDuration.inSeconds + newDuration.inSeconds);
    
    // Update the container map with the new total duration
    newState[containerIndex]![normalizedDate] = totalDuration;
    
    // Update the state with the new map
    state = newState;
    
    print('📊 Updated time for project $containerIndex on $normalizedDate:');
    print('➕ Added duration: ${newDuration.inSeconds}s');
    print('📈 New total: ${totalDuration.inSeconds}s');
  }

  void clearProcessedTimeframes() {
    _processedTimeframes.clear();
  }

  Future<void> addTime(int containerIndex, DateTime date, Duration duration) async {
    addTimeToState(containerIndex, date, duration);

    try {
      final authRepository = _ref.read(authRepositoryProvider);
      final normalizedDate = DateTime(date.year, date.month, date.day);
      
      final currentContainerMap = state[containerIndex] ?? {};
      final totalDuration = currentContainerMap[normalizedDate] ?? Duration.zero;

      await authRepository.addTimeframeData(
        projectIndex: containerIndex,
        date: date,
        duration: totalDuration.inSeconds,
        timeframeType: 'weekly',
      );
    } catch (e) {
      print('❌ Error saving timeframe data: $e');
    }
  }

  Duration getProjectTime(int containerIndex, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;
  }

  Duration getProjectTimeForMonth(int containerIndex, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;
  }

  Duration getProjectTimeForYear(int containerIndex, DateTime date) {
    final containerMap = state[containerIndex];
    if (containerMap == null) return Duration.zero;

    return containerMap.entries
        .where((entry) => 
          entry.key.year == date.year && 
          entry.key.month == date.month)
        .fold(Duration.zero, (prev, curr) => prev + curr.value);
  }

  Duration getTotalProjectTime(int containerIndex) {
    final containerMap = state[containerIndex];
    if (containerMap == null) return Duration.zero;
    return containerMap.values.fold(Duration.zero, (prev, curr) => prev + curr);
  }

  Duration getMonthlyDuration(int containerIndex, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return state[containerIndex]?[normalizedDate] ?? Duration.zero;
  }

  Duration getYearlyDuration(int containerIndex, DateTime date) {
    final containerMap = state[containerIndex];
    if (containerMap == null) return Duration.zero;

    final currentMonthStart = DateTime(date.year, date.month, 1);
    final nextMonthStart = DateTime(date.year, date.month + 1, 1);

    return containerMap.entries
        .where((entry) => 
          entry.key.isAfter(currentMonthStart.subtract(const Duration(days: 1))) &&
          entry.key.isBefore(nextMonthStart))
        .fold(Duration.zero, (prev, curr) => prev + curr.value);
  }

  List<Duration> getYearlyData(int containerIndex, DateTime now) {
    return List.generate(12, (index) {
      int month = now.month - index;
      int year = now.year;
      
      if (month <= 0) {
        month += 12;
        year -= 1;
      }
      
      final date = DateTime(year, month, 1);
      return getProjectTimeForYear(containerIndex, date);
    }).reversed.toList();
  }

  List<Duration> getMonthlyData(int containerIndex, DateTime now) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    
    return List.generate(daysInMonth, (index) {
      final date = DateTime(now.year, now.month, daysInMonth - index);
      return getProjectTime(containerIndex, date);
    });
  }

  void resetState() {
    state = {};
    resetTimer();
  }

  void clearProjectData(int projectIndex) async {
    state = Map.from(state)..remove(projectIndex);
    await _ref.read(localStorageRepositoryProvider).clearProjectTimeframes(projectIndex);
    
    if (_startTime != null) {
      resetTimer();
    }
  }
}


