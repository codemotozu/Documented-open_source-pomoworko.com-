import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../common/utils/responsive_web.dart';
import '../presentation/notifiers/task_notifier.dart';
import '../presentation/pages/0.appbar_features/2_app_bar_icons/app_bar_features.dart';
import '../presentation/pages/3.chips_blog/1.chips_blog.dart';
import '../presentation/pages/4.tomatoes _intervals.dart/tomato_icon_pomodoro.dart';
import '../presentation/pages/5_animation_timer.dart/animation_timer.dart';
import '../presentation/pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/new_task_button.dart';
import '../presentation/pages/6.todo_task/todo_option_1.dart/glassmorphism_screen/todo_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double appBarHeight = 95;
    double tomatoIconPomodoroHeight = 50;
    double animationAndTimerPageHeight = 402;

    return SafeArea(
      child: ResponsiveWeb(
        child: Scaffold(
          backgroundColor:  const Color.fromARGB(255, 0, 0, 0),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return ListView(children: [
              Column(
                children: [
                  SizedBox(
                    height: appBarHeight,
                    child: const AppBarFeatures(),
                  ),
                  const ChipsBlog(),
                  SizedBox(
                    height: tomatoIconPomodoroHeight,
                    child: const TomatoIconPomodoro(),
                  ),
                  SizedBox(
                    height: animationAndTimerPageHeight,
                    child: const AnimationAndTimer(),
                  ),
                  const ToDoPage(),
                  Container(
                    color:
                        const Color.fromARGB(255, 0, 0, 0),

                    height: 79,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 23.0, right: 23.0, bottom: 23.0),
                      child: NewTaskButton(onNewTask: (
                        todo,
                      ) {
                        ref.read(taskListProvider.notifier).addTask(
                              todo,
                            );
                        setState(() {});
                      }),
                    ),
                  ),

                ],
              ),
            ]);
          }),

        ),

      ),

    );
  }
}