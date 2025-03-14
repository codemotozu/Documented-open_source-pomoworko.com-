import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../infrastructure/data_sources/hive_services.dart';
import '../notifiers/persistent_container_notifier.dart';
import '../notifiers/project_state_notifier.dart';
import '../notifiers/providers.dart';
import '../notifiers/timer_notifier_provider.dart';
import '../repository/auth_repository.dart';



class PlayPauseButton extends ConsumerStatefulWidget {
  final AnimationController controller;

  const PlayPauseButton({
    super.key,
    required this.controller,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends ConsumerState<PlayPauseButton> {
  DateTime? startTime;
  String? currentProject;

  @override
  void initState() {
    super.initState();
    html.window.addEventListener('beforeunload', (html.Event e) {
      html.BeforeUnloadEvent event = e as html.BeforeUnloadEvent;
      final isTimerRunning = ref.read(isTimerRunningProvider);
      if (isTimerRunning) {
        event.returnValue = "Please click on the 'Pause' button to save changes.";
      }
    });
  }

  @override
  void dispose() {
    startTime = null;
    html.window.removeEventListener('beforeunload', (html.Event e) {});
    super.dispose();
  }

  Future<void> _savePomodoroStatesToDatabase() async {
    final pomodoroStates = ref.read(pomodoroNotifierProvider).pomodoros;
    await ref.read(authRepositoryProvider).updatePomodoroStates(pomodoroStates);
  }

  Duration _calculatePreciseDuration(DateTime start) {
    final currentTime = DateTime.now();
    final rawDifference = currentTime.difference(start);
    
    // Si hay milisegundos (menos de 1000ms), redondear hacia abajo
    final elapsedSeconds = rawDifference.inSeconds;
    
    print('⚡ Raw difference in ms: ${rawDifference.inMilliseconds}');
    print('⏱️ Adjusted seconds: $elapsedSeconds');
    
    return Duration(seconds: elapsedSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final isTimerRunning = ref.watch(isTimerRunningProvider);
    final projectNames = ref.watch(projectStateNotifierProvider);
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider) ?? 0;
    final currentTimerType = ref.watch(currentTimerTypeProvider);

    void changeFavicon(String faviconPath) {
      final js.JsObject document = js.JsObject.fromBrowserObject(js.context['document']);
      final link = document.callMethod('querySelector', ['link[rel="icon"]']);
      if (link != null) {
        link.href = faviconPath;
      } else {
        print('Link element not found!');
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
        ),
        FloatingActionButton.extended(
          heroTag: 'fab',
          icon: Icon(isTimerRunning
              ? CupertinoIcons.pause_fill
              : CupertinoIcons.play_fill),
          label: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 67, maxHeight: 20),
            child: RichText(
              text: TextSpan(
                text: isTimerRunning ? 'Pause' : 'Start',
                style: GoogleFonts.nunito(
                  color: const Color(0xffF2F2F2),
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          backgroundColor: const Color(0xFF121212),
          onPressed: () async {
            if (isTimerRunning) {
              // Detener el temporizador
              ref.read(timerNotifierProvider.notifier).stopTimer();
              widget.controller.stop();

              changeFavicon('icons/orange_android-chrome-192x192.png');
              html.document.title = "Relax";

              // Calcular y guardar la duración solo si estamos en modo Pomodoro
              if (startTime != null && currentTimerType == 'Pomodoro') {
                print('\n🔴 TIMER PAUSE -------------');
                final duration = _calculatePreciseDuration(startTime!);
                final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
                
                print('⏱️ Session duration: ${duration.inSeconds}s');
                
                // Solo guardamos en el almacenamiento del pomodoro
                await HiveServices.savePomodoroDuration(duration);
                
                // Resetear startTime
                startTime = null;
              }

              await _savePomodoroStatesToDatabase();
            } else {
              print('\n🟢 TIMER START -------------');
              print('⏰ Start time: ${DateTime.now()}');
              
              if (currentTimerType == 'Pomodoro') {
                startTime = DateTime.now();
                print('💾 Timer started at: $startTime');
              }

              bool ongoingPomodoro = await HiveServices.retrieveOngoingPomodoro();
              bool unfinishedPomodoro = await HiveServices.retrieveUnfinishedPomodoro();

              if (currentTimerType == 'Pomodoro') {
                final pomodoroState = ref.read(pomodoroNotifierProvider);

                bool shouldStartNewPomodoro = pomodoroState.pomodoros.isEmpty ||
                    (pomodoroState.pomodoros.isNotEmpty &&
                        pomodoroState.pomodoros.last);

                if (!ongoingPomodoro && (shouldStartNewPomodoro || unfinishedPomodoro)) {
                  ref.read(currentPomodorosProvider.notifier).state++;
                  ref.read(pomodoroNotifierProvider.notifier).startNewPomodoro();
                  await _savePomodoroStatesToDatabase();
                }
              }

              // Iniciar el temporizador
              ref.read(timerNotifierProvider.notifier).startTimer();
              if (widget.controller.isCompleted) {
                widget.controller.reset();
              }
              widget.controller.forward();
              
              await HiveServices.saveOngoingPomodoro(true);
              await HiveServices.saveUnfinishedPomodoro(false);
              changeFavicon('icons/green_android-chrome-192x192.png');
              html.document.title = "Focus";
            }
          },
        ),
      ],
    );
  }
}
