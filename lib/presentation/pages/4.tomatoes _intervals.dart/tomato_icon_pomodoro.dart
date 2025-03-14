import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../notifiers/providers.dart';

class TomatoIconPomodoro extends ConsumerStatefulWidget {
  const TomatoIconPomodoro({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TomatoIconPomodoroState();
}

class _TomatoIconPomodoroState extends ConsumerState<TomatoIconPomodoro> {
  @override
  Widget build(BuildContext context) {
    final pomodoroState = ref.watch(pomodoroNotifierProvider);
    final ScrollController horizontal = ScrollController();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      floatingActionButton: Transform.translate(
        offset: const Offset(5, 13),
        child: CupertinoButton(
          color: const Color.fromARGB(255, 0, 0, 0),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          borderRadius: BorderRadius.circular(12),
          onPressed: () {
            ref.read(pomodoroNotifierProvider.notifier).resetPomodoros();
          },
          child: const Tooltip(
            message: 'Restart Pomodoro(s)',
            child: Icon(
              CupertinoIcons.arrow_counterclockwise,
              color: Color(0xffF2F2F2),
              size: 28.0,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 23),
        child: Scrollbar(
          controller: horizontal,
          child: SingleChildScrollView(
            controller: horizontal,
            scrollDirection: Axis.horizontal,
            child: Row(
              children: pomodoroState.pomodoros.map((isCompleted) {
                return IconButton(
                  onPressed: null,
                  icon: isCompleted
                      ? Image.asset('assets/icons/tomatoDone.png')
                      : Image.asset('assets/icons/tomatoUndone.png'),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
