import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

import '../../common/widgets/domain/entities/sound_entity.dart';
import '../../common/widgets/domain/entities/todo_entity.dart';
import '../../infrastructure/data_sources/hive_services.dart';
import '../repository/local_storage_repository.dart';
import 'pomodoro_notifier.dart';


final completedWorkPeriodsProvider = StateProvider<int>((ref) => 0);

final pomodoroTimerProvider = StateProvider<int>((ref) => 0);



final shortBreakProvider = StateProvider<int>((ref) => 0);
final longBreakProvider = StateProvider<int>((ref) => 0);

final currentTimerProvider =
    StateProvider<int>((ref) => ref.read(pomodoroTimerProvider));

final longBreakIntervalProvider = StateProvider<int>((ref) => 4);

final timerInitProvider = FutureProvider<void>((ref) async {
  final pomodoroTime = await HiveServices.retrieveDefaultPomodoroTimerValue(
      HiveServices.pomodoroKey);
  ref.read(pomodoroTimerProvider.notifier).state = pomodoroTime;

  final shortBreakTime = await HiveServices.retrieveDefaultShortBreakTimerValue(
      HiveServices.shortBreakKey);
  ref.read(shortBreakProvider.notifier).state = shortBreakTime;

  final longBreakTime = await HiveServices.retrieveDefaultLongBreakTimerValue(
      HiveServices.longBreakKey);
  ref.read(longBreakProvider.notifier).state = longBreakTime;

  final longBreakInterval =
      await HiveServices.retrieveDefaultLongBreakIntervalValue(
          HiveServices.longBreakIntervalKey);
  ref.read(longBreakIntervalProvider.notifier).state = longBreakInterval;
});

final soundInitProvider = FutureProvider<void>((ref) async {
  final alarmSoundPath = await HiveServices.retrieveAlarmSoundValue();
  final soundList = ref.read(soundListProvider);
  final sound = soundList.firstWhere((sound) => sound.path == alarmSoundPath);

  ref.read(selectedSoundProvider.notifier).updateSound(sound);
});

final isTimerRunningProvider = StateProvider<bool>((ref) => false);

final audioPlayerProvider = Provider<AudioPlayer>((ref) => AudioPlayer());

// final selectedSoundProvider = StateNotifierProvider<SoundNotifier, Sound>(
//     (ref) => SoundNotifier(initialSound: ref.watch(soundListProvider).first));

final selectedSoundProvider = StateNotifierProvider<SelectedSoundNotifier, Sound>((ref) {
  final soundMap = ref.watch(soundMapProvider);
  return SelectedSoundNotifier(soundMap: soundMap);
});

class SelectedSoundNotifier extends StateNotifier<Sound> {
  final Map<String, Sound> soundMap;

  SelectedSoundNotifier({required this.soundMap}) 
    : super(soundMap['assets/sounds/Flashpoint.wav']!);

  void updateSound(Sound newSound) {
    state = newSound;
  }

  void updateSoundFromPath(String path) {
    state = soundMap[path] ?? soundMap['assets/sounds/Flashpoint.wav']!;
  }
}


final soundMapProvider = Provider<Map<String, Sound>>((ref) {
  final sounds = ref.watch(soundListProvider);
  return {for (var sound in sounds) sound.path: sound};
});

final soundListProvider = Provider<List<Sound>>((ref) => [
      const Sound(
        path: 'assets/sounds/Flashpoint.wav',
        friendlyName: 'Flashpoint ⚡',
      ),
      const Sound(
        path: 'assets/sounds/Plink.wav',
        friendlyName: 'Plink 🎯',
      ),
      const Sound(
        path: 'assets/sounds/Blink.wav',
        friendlyName: 'Blink 👁️',
      ),
    ]);

// final notificationToggleProvider =
//     StateNotifierProvider<NotificationToggle, bool>(
//         (ref) => NotificationToggle());

// 2. Actualizar el provider de notificaciones (providers.dart)
final browserNotificationsProvider = StateNotifierProvider<BrowserNotificationsNotifier, bool>((ref) {
  return BrowserNotificationsNotifier();
});

class BrowserNotificationsNotifier extends StateNotifier<bool> {
  BrowserNotificationsNotifier() : super(false);

  void toggle() {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}

final currentTimerTypeProvider = StateProvider<String>((ref) => 'Pomodoro');

final currentTimerTypeDarkModeProvider =
    StateProvider<String>((ref) => 'Pomodoro');

final currentColorProvider = StateProvider<Color>((ref) {

    return ref.watch(darkPomodoroColorProvider);
  
});

final colorInitProvider = FutureProvider<void>((ref) async {
  await HiveServices.retrieveAllColorValues(ref);
});

final darkPomodoroColorProvider = StateProvider<Color>((ref) {
   return const Color(0xFF74F143);
});

final darkShortBreakColorProvider = StateProvider<Color>((ref) {
   return const Color(0xffff9933);
});


final darkLongBreakColorProvider = StateProvider<Color>((ref) {
  return const Color(0xFF0891FF);
});


final pomodoroColorModeProvider = Provider<Color>((ref) {
    return ref.watch(darkPomodoroColorProvider.notifier).state;
  
});

final shortBreakColorModeProvider = Provider<Color>((ref) {
    return ref.watch(darkShortBreakColorProvider.notifier).state;
  
});

final longBreakColorModeProvider = Provider<Color>((ref) {
    return ref.watch(darkLongBreakColorProvider.notifier).state;
  
});

class EventNotifier extends StateNotifier<String> {
  EventNotifier() : super("");

  void notify(String eventName) {
    state = "";
    state = eventName;
  }
}

final eventNotifierProvider =
    StateNotifierProvider<EventNotifier, String>((ref) => EventNotifier());

final nextTimerTypeProvider = StateProvider<String>((ref) {
  return 'Pomodoro';
});

final nextColorProvider = StateProvider<Color>((ref) {
  final nextTimerType = ref.watch(nextTimerTypeProvider);
  final themeMode = ref.read(themeModeProvider);

  if (themeMode == ThemeMode.dark) {
    // For dark mode
    switch (nextTimerType) {
      case 'Short Break':
        return const Color(0xFF74F143);
      case 'Long Break':
        return
        //
        //const Color.fromARGB(255, 255, 202, 55)
         const Color(0xffff9933)
         ;
      default:
        return const Color(0xFF43DDF1); 
    }
  } else {
    switch (nextTimerType) {
      case 'Short Break':
        return ref.watch(darkShortBreakColorProvider.notifier).state;
      case 'Long Break':
        return ref.watch(darkLongBreakColorProvider.notifier).state;
      case 'Pomodoro':
        // Decide the next color based on completed work periods.
        int longBreakInterval =
            ref.read(longBreakIntervalProvider.notifier).state;
        int completedWorkPeriods =
            ref.read(completedWorkPeriodsProvider.notifier).state;

        if ((completedWorkPeriods + 1) % longBreakInterval == 0) {
          return ref.watch(darkLongBreakColorProvider.notifier).state;
        } else {
          return ref.watch(darkShortBreakColorProvider.notifier).state;
        }
      default:
        return Colors.black;
    }
  }
});

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.light) {
    loadThemeMode();
  }

  Future<void> loadThemeMode() async {
    final savedThemeMode = await HiveServices.retrieveThemeMode();
    state = savedThemeMode;
  }

  void toggle() async {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      await HiveServices.saveThemeMode(ThemeMode.dark);
    } else {
      state = ThemeMode.dark;
      await HiveServices.saveThemeMode(ThemeMode.dark);
    }
  }
}

final currentPomodorosProvider = StateProvider<int>((ref) => 0);

final pomodoroNotifierProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>(
        (ref) => PomodoroNotifier(ref));

final isFirstStartProvider = StateProvider<bool>((ref) => true);

final timerFinishedProvider = StateProvider<bool>((ref) => false);

final focusedTaskTitleProvider = StateProvider<String>((ref) => '');
final focusedTaskProvider = StateProvider<Todo?>((ref) => null);

final taskColorsProvider = StateProvider<Map<String, Color>>((ref) => {});

final selectedProyectContainerProvider = StateProvider<int?>((ref) => null);


//* TASK CARD ITEMS BELOW MY "SUCCESS LIST"

final toDoHappySadToggleProvider = StateNotifierProvider<ToDoHappySadToggleNotifier, bool>((ref) {
  return ToDoHappySadToggleNotifier();
});

class ToDoHappySadToggleNotifier extends StateNotifier<bool> {
  ToDoHappySadToggleNotifier() : super(false);

  void toggle() async {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}


// Provider para el historial de eliminaciones de tareas
final taskDeletionsProvider = StateNotifierProvider<TaskDeletionsToggleNotifier, bool>((ref) {
  return TaskDeletionsToggleNotifier();
});

class TaskDeletionsToggleNotifier extends StateNotifier<bool> {
  TaskDeletionsToggleNotifier() : super(false);

  void toggle() async {
    state = !state;
  }

  void set(bool value) {
    state = value;
  }
}


final taskCardTitleProvider = StateNotifierProvider<TaskCardTitleNotifier, String>((ref) {
  return TaskCardTitleNotifier();
});

class TaskCardTitleNotifier extends StateNotifier<String> {
  TaskCardTitleNotifier() : super('');

  void updateTitle(String title) {
    state = title;
  }

  void reset() {
    state = '';
  }
}

// En providers.dart, agrega este provider:

final localStorageRepositoryProvider = Provider<LocalStorageRepository>((ref) {
  return LocalStorageRepository();
});