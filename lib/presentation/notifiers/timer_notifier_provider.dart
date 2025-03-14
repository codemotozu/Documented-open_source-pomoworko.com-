import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/auth_repository.dart';
import 'providers.dart';
import 'timer_notifier.dart';

final userPomodoroTimerProvider = StateProvider<int>((ref) {
  final user = ref.watch(userProvider);
  final pomodoroTimer = ref.watch(pomodoroTimerProvider);
  return user != null ? user.pomodoroTimer : pomodoroTimer;
});

final userShortBreakTimerProvider = StateProvider<int>((ref) {
  final user = ref.watch(userProvider);
  final shortBreakTimer = ref.watch(shortBreakProvider);
  return user != null ? user.shortBreakTimer : shortBreakTimer;
});


final userLongBreakTimerProvider = StateProvider<int>((ref) {
  final user = ref.watch(userProvider);
  final longBreakTimer = ref.watch(longBreakProvider);
  return user != null ? user.longBreakTimer : longBreakTimer;
});

final timerNotifierProvider = StateNotifierProvider<TimerNotifier, int>((ref) {
  final audioPlayer = ref.watch(audioPlayerProvider);
  final userPomodoroTimer = ref.watch(userPomodoroTimerProvider);
  final userShortBreakTimer = ref.watch(userShortBreakTimerProvider);
  final userLongBreakTimer = ref.watch(userLongBreakTimerProvider);


  TimerNotifier timerNotifier;

  if (ref.read(currentTimerTypeProvider.notifier).state == 'Pomodoro') {
      timerNotifier = TimerNotifier(userPomodoroTimer * 60, ref, audioPlayer);

  } else if (ref.read(currentTimerTypeProvider.notifier).state ==
      'Short Break') {
        timerNotifier = TimerNotifier(userShortBreakTimer * 60, ref, audioPlayer);

  } else {
    timerNotifier =
        TimerNotifier((userLongBreakTimer) * 60, ref, audioPlayer);
  }

  timerNotifier.loadSounds();
  timerNotifier.init();
  return timerNotifier;
});


