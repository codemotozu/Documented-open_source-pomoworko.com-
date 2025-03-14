

import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../infrastructure/data_sources/hive_services.dart';
import '../widgets/custom_timer_palette.dart';
import 'persistent_container_notifier.dart';
import 'project_time_notifier.dart';
import 'providers.dart';

class TimerNotifier extends StateNotifier<int> {
  TimerNotifier(int state, this.ref, this._audioPlayer) : super(state) {
    _setupJavaScriptHandlers();
  }

  AnimationController? controller;
  CustomTimePainter? painter;
  AudioPlayer _audioPlayer;
  final Ref ref;
  
  bool _isRunning = false;
  bool _mounted = false;
  bool _isDisposed = false;
  String _currentSoundPath = '';
  DateTime? startTime;
  int _initialDuration = 0;
  bool isFirstStart = true;

  void _setupJavaScriptHandlers() {
    js.context['flutter_inappwebview'] = js.JsObject.jsify({
      'callHandler': (String method, [dynamic arg1, dynamic arg2]) async {
        switch (method) {
          case 'updateTimer':
            _handleTimerUpdate(arg1 as int);
            break;
          case 'timerComplete':
            await _handleTimerComplete();
            break;
          case 'onVisibilityChange':
            _handleVisibilityChange(arg1 as String, arg2 as int);
            break;
        }
      }
    });
  }

  Future<void> showWebNotification(String title, String body) async {
    try {
      if (html.Notification.supported) {
        if (html.Notification.permission == "granted") {
          html.Notification(title, body: body);
        } else {
          await html.Notification.requestPermission().then((permission) {
            if (permission == "granted") {
              html.Notification(title, body: body);
            }
          });
        }
      }
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

/*
  Future<void> playSound({required bool userTriggered}) async {
    try {
      if (!_isDisposed) {
        final selectedSound = ref.watch(selectedSoundProvider.notifier).state;
        
        // Asegurar que el audio esté listo
        if (_audioPlayer.processingState != ProcessingState.ready) {
          await _audioPlayer.stop();
          await _audioPlayer.setAsset(selectedSound.path);
          await _audioPlayer.load();
        }
        
        // Intentar reproducir varias veces si es necesario
        for (int i = 0; i < 3; i++) {
          try {
            await _audioPlayer.seek(Duration.zero);
            await _audioPlayer.play();
            break;
          } catch (e) {
            if (i == 2) rethrow;
            await Future.delayed(Duration(milliseconds: 100));
          }
        }
      }
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

*/


Future<void> playSound({required bool userTriggered}) async {
  try {
    print("playSound called. User triggered: $userTriggered");

    final selectedSound = ref.watch(selectedSoundProvider.notifier).state;
    print("Selected sound path: ${selectedSound.path}");

    // Ensure audio player is ready
    if (_audioPlayer.processingState != ProcessingState.ready) {
      print("Audio player not ready, reinitializing...");
      await _audioPlayer.dispose();
      _audioPlayer = AudioPlayer();
      await _audioPlayer.setAsset(selectedSound.path);
      await _audioPlayer.load();
    }

    // Attempt playback with retries
    for (int i = 0; i < 3; i++) {
      try {
        print("Attempting to play sound. Attempt #$i");
        await _audioPlayer.seek(Duration.zero);
        await _audioPlayer.play();
        print("Sound played successfully.");
        break;
      } catch (e) {
        print("Error in playSound: $e");
        if (i == 2) rethrow; // Rethrow after retries
        await Future.delayed(Duration(milliseconds: 100));
      }
    }
  } catch (e) {
    print("Final error in playSound: $e");
  }
}


  Future<void> playSoundWithUserInteraction() async {
    await playSound(userTriggered: true);
  }

/*
  Future<void> loadSounds() async {
    if (!_isDisposed) {
      try {
        final selectedSound = ref.read(selectedSoundProvider.notifier).state;
        if (selectedSound.path != _currentSoundPath ||
            _audioPlayer.processingState != ProcessingState.ready) {
          await _audioPlayer.stop();
          await _audioPlayer.setAsset(selectedSound.path);
          await _audioPlayer.load();
          _currentSoundPath = selectedSound.path;
        }
      } catch (e) {
        print('Error loading sounds: $e');
      }
    }
  }
*/

Future<void> loadSounds() async {
  if (!_isDisposed) {
    try {
      final selectedSound = ref.read(selectedSoundProvider.notifier).state;

      // Stop any ongoing playback and ensure player is ready
      if (_audioPlayer.playing) {
        await _audioPlayer.stop();
      }

      if (selectedSound.path != _currentSoundPath || 
          _audioPlayer.processingState != ProcessingState.ready) {
        await _audioPlayer.dispose(); // Dispose the current player to prevent conflicts
        _audioPlayer = AudioPlayer(); // Reinitialize the player

        await _audioPlayer.setAsset(selectedSound.path);
        await _audioPlayer.load();
        _currentSoundPath = selectedSound.path;
        print("New sound loaded successfully: $_currentSoundPath");
      }
    } catch (e) {
      print('Error loading sounds: $e');
    }
  }
}


  void init() {
    _mounted = true;
    loadSounds();  // Precargar sonidos al iniciar

    ref.listen<String>(currentTimerTypeProvider, (timerType, _) {
      if (timerType == 'Pomodoro') {
        painter?.color = ref.read(darkPomodoroColorProvider);
      } else if (timerType == 'Short Break') {
        painter?.color = ref.read(darkShortBreakColorProvider);
      } else {
        painter?.color = ref.read(darkLongBreakColorProvider);
      }
    });

    ref.listen<String>(selectedSoundProvider.select((value) => value.path),
        (previousSound, newSound) async {
      if (previousSound != newSound) {
        await _audioPlayer.stop();
        await loadSounds();
      }
    });
  }

  void _handleTimerUpdate(int remainingTime) {
    if (!_isDisposed && _isRunning && _mounted) {
      state = remainingTime;
      
      if (remainingTime % 1 == 0) {
        HiveServices.saveRemainingTimerValue(
          ref.read(currentTimerTypeProvider), remainingTime);
      }
    }
  }

  void _handleVisibilityChange(String visibility, int elapsedSeconds) {
    if (!_isDisposed && _mounted && _isRunning) {
      if (visibility == 'visible') {
        if (elapsedSeconds > 0) {
          final newState = state - elapsedSeconds;
          if (newState <= 0) {
            _handleTimerComplete();
          } else {
            state = newState;
          }
        }
      }
      // Recargar sonidos cuando la página vuelve a ser visible
      loadSounds();
    }
  }

  String _getNotificationBody() {
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      int longBreakInterval = ref.read(longBreakIntervalProvider);
      int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);
      
      if ((completedWorkPeriods + 1) % longBreakInterval == 0) {
        return 'Time for a long break!';
      } else {
        return 'Time for a short break!';
      }
    } else {
      return 'Time to get back to work!';
    }
  }
/*
  Future<void> _handleTimerComplete() async {
    if (!_mounted || _isDisposed) return;
    
    _isRunning = false;
    state = 0;

    // Asegurar que el sonido y la notificación se ejecuten
    try {
      if (ref.read(browserNotificationsProvider)) {
        // Intentar mostrar la notificación incluso en segundo plano
        html.window.postMessage('showNotification', '*');
        await showWebNotification('Timer Finished', _getNotificationBody());
      }
      
      // Reproducir el sonido inmediatamente
      await playSound(userTriggered: false).timeout(
        Duration(seconds: 2),
        onTimeout: () async {
          // Si falla, intentar reproducir nuevamente
          await loadSounds();
          await playSound(userTriggered: false);
        },
      );
    } catch (e) {
      print('Error handling timer completion: $e');
    }

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      final exactDuration = Duration(seconds: _initialDuration);
      await HiveServices.savePomodoroDuration(exactDuration);
      
      final selectedContainerIndex = ref.read(persistentContainerIndexProvider) ?? 0;
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      ref.read(projectTimesProvider.notifier).addTime(
        selectedContainerIndex, 
        today, 
        exactDuration
      );
      
      ref.read(pomodoroNotifierProvider.notifier).finishCurrentPomodoro();
    }

    ref.read(isTimerRunningProvider.notifier).state = false;
    int longBreakInterval = ref.read(longBreakIntervalProvider);
    int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);

    await _updateTimerState(completedWorkPeriods, longBreakInterval);
  }
*/
 void changeFavicon(String faviconPath) {
      final js.JsObject document = js.JsObject.fromBrowserObject(js.context['document']);
      final link = document.callMethod('querySelector', ['link[rel="icon"]']);
      if (link != null) {
        link.href = faviconPath;
      } else {
        print('Link element not found!');
      }
    }

Future<void> _handleTimerComplete() async {
    if (!_mounted || _isDisposed) return;
    
    _isRunning = false;
    state = 0;

    // Cambiar el título del documento para mostrar el mensaje de completado
 changeFavicon('icons/red_android-chrome-192x192.png');
    html.document.title = "Time is up!";
    // Asegurar que el sonido y la notificación se ejecuten
    try {
      if (ref.read(browserNotificationsProvider)) {
        // Intentar mostrar la notificación incluso en segundo plano
        html.window.postMessage('showNotification', '*');
        await showWebNotification('Timer Finished', _getNotificationBody());
      }
      
      // Reproducir el sonido inmediatamente
      await playSound(userTriggered: false).timeout(
       const Duration(seconds: 1),
        onTimeout: () async {
          // Si falla, intentar reproducir nuevamente
          await loadSounds();
          await playSound(userTriggered: false);
        },
      );
    } catch (e) {
      print('Error handling timer completion: $e');
    }

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      final exactDuration = Duration(seconds: _initialDuration);
      await HiveServices.savePomodoroDuration(exactDuration);
      
      final selectedContainerIndex = ref.read(persistentContainerIndexProvider) ?? 0;
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      ref.read(projectTimesProvider.notifier).addTime(
        selectedContainerIndex, 
        today, 
        exactDuration
      );
      
      ref.read(pomodoroNotifierProvider.notifier).finishCurrentPomodoro();
    }

    ref.read(isTimerRunningProvider.notifier).state = false;
    int longBreakInterval = ref.read(longBreakIntervalProvider);
    int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);

    await _updateTimerState(completedWorkPeriods, longBreakInterval);
}


  Future<void> _updateTimerState(int completedWorkPeriods, int longBreakInterval) async {
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      completedWorkPeriods++;
      ref.read(completedWorkPeriodsProvider.notifier).state = completedWorkPeriods;
      await HiveServices.saveOngoingPomodoro(false);

      if (completedWorkPeriods % longBreakInterval == 0) {
        ref.read(currentTimerTypeProvider.notifier).state = 'Long Break';
      } else {
        ref.read(currentTimerTypeProvider.notifier).state = 'Short Break';
      }
      HiveServices.saveCurrentTimerType(ref.read(currentTimerTypeProvider));
    } else {
      ref.read(currentTimerTypeProvider.notifier).state = 'Pomodoro';
      await HiveServices.saveOngoingPomodoro(true);
      HiveServices.saveCurrentTimerType('Pomodoro');
      
      ref.read(currentPomodorosProvider.notifier).state++;
      ref.read(pomodoroNotifierProvider.notifier).startNewPomodoro();
    }
  }

  void startTimer() async {
    if (_isDisposed) return;
    
    _isRunning = true;
    _initialDuration = state;
    
    controller?.reset();
    controller?.forward();
    
    await HiveServices.saveOngoingPomodoro(true);
    
    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      startTime = DateTime.now();
      await HiveServices.saveStartTime(startTime!);
    } else {
      startTime = null;
    }

    js.context.callMethod('startTimer', [state]);
    ref.read(isTimerRunningProvider.notifier).state = true;
  }

  void stopTimer() async {
    if (!_isRunning) return;

    _isRunning = false;
    
    final elapsedSeconds = js.context.callMethod('stopTimer') as int;

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro' && startTime != null) {
      final duration = Duration(seconds: elapsedSeconds);
      await HiveServices.savePomodoroDuration(duration);
      
      final selectedContainerIndex = ref.read(persistentContainerIndexProvider) ?? 0;
      final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
      ref.read(projectTimesProvider.notifier).addTime(
        selectedContainerIndex, 
        today, 
        duration
      );
    }

    if (state > 0) {
      HiveServices.saveRemainingTimerValue('remainingTime', state);
      final timerType = ref.read(currentTimerTypeProvider);
      HiveServices.saveRemainingTimerValue(timerType, state);
    }
    
    ref.read(isTimerRunningProvider.notifier).state = false;
    _audioPlayer.pause();
    controller?.stop();
    await HiveServices.saveOngoingPomodoro(false);
  }

  void updateDuration(int newDuration) {
    stopTimer();
    int durationInSeconds;

    if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
      durationInSeconds = ref.read(pomodoroTimerProvider) * 60;
    } else if (ref.read(currentTimerTypeProvider) == 'Short Break') {
      durationInSeconds = ref.read(shortBreakProvider) * 60;
    } else {
      durationInSeconds = ref.read(longBreakProvider) * 60;
    }

    state = durationInSeconds;
    _initialDuration = durationInSeconds;
    controller?.duration = Duration(seconds: durationInSeconds);
    HiveServices.saveCurrentTimerType(ref.read(currentTimerTypeProvider));
  }

  @override
  void dispose() {
    _mounted = false;
    _isRunning = false;
    _isDisposed = true;
    js.context.callMethod('stopTimer');
    _audioPlayer.dispose();
    controller?.dispose();
    super.dispose();
  }

  void updateColor() {
    final themeMode = ref.read(themeModeProvider);

    if (themeMode == ThemeMode.dark) {
      if (ref.read(currentTimerTypeProvider) == 'Pomodoro') {
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);
        _updateNextColorProvider(darkShortBreakColorProvider, darkLongBreakColorProvider);
      } else if (ref.read(currentTimerTypeProvider) == 'Short Break') {
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkShortBreakColorProvider);
        ref.read(nextColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);
      } else {
        ref.read(currentColorProvider.notifier).state =
            ref.read(darkLongBreakColorProvider);
        ref.read(nextColorProvider.notifier).state =
            ref.read(darkPomodoroColorProvider);
      }
    }
  }

  void _updateNextColorProvider(
    StateProvider<Color> shortBreakColorProvider,
    StateProvider<Color> longBreakColorProvider
  ) {
    int longBreakInterval = ref.read(longBreakIntervalProvider);
    int completedWorkPeriods = ref.read(completedWorkPeriodsProvider);

    if (longBreakInterval == 1) {
      ref.read(nextColorProvider.notifier).state =
          ref.read(longBreakColorProvider);
    } else if (longBreakInterval == 2) {
      if (completedWorkPeriods % longBreakInterval == 0) {
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);
      } else {
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);
      }
    } else if (longBreakInterval == 3) {
      if (completedWorkPeriods % longBreakInterval < 2) {
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);
      } else {
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);
      }
    } else if (longBreakInterval == 4) {
      if (completedWorkPeriods % longBreakInterval < 3) {
        ref.read(nextColorProvider.notifier).state =
            ref.read(shortBreakColorProvider);
      } else {
        ref.read(nextColorProvider.notifier).state =
            ref.read(longBreakColorProvider);
      }
    }
  }
}

