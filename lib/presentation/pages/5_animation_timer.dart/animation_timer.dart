import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/data_sources/hive_services.dart';
import '../../notifiers/providers.dart';
import '../../notifiers/timer_notifier_provider.dart';
import '../../widgets/app_tab_bar.dart';
import '../../widgets/custom_timer_palette.dart';
import '../../widgets/play_pause_button_widget.dart';
import '../../widgets/task_card.dart';


class AnimationAndTimer extends ConsumerStatefulWidget {
  const AnimationAndTimer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends ConsumerState<AnimationAndTimer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  AnimationController? controller;
  late Animation<double> animation;
  late final int eventNotifierListener;

  void updateAnimationControllerDuration() {
    int timerDuration;

    switch (ref.read(currentTimerTypeProvider.notifier).state) {
      case 'Pomodoro':
        timerDuration = ref.read(pomodoroTimerProvider.notifier).state;
        break;
      case 'Short Break':
        timerDuration = ref.read(shortBreakProvider.notifier).state;
        break;
      case 'Long Break':
        timerDuration = ref.read(longBreakProvider.notifier).state;
        break;
      default:
        timerDuration = 0;
        break;
    }

    controller?.duration = Duration(minutes: timerDuration);
    controller?.stop();
    controller?.reset();
  }

  @override
  void initState() {
    super.initState();

// *IF THE USER DONT SIGN IN THE ANIMATION WILL NOT BE SAVED
    HiveServices.retrieveCurrentTimerType().then((timerType) {
      ref.read(currentTimerTypeProvider.notifier).state = timerType;
      updateAnimationControllerDuration();
    });
    _tabController = TabController(length: 3, vsync: this);

    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: ref.read(pomodoroTimerProvider)),
    );

    animation = Tween<double>(begin: 0, end: 1).animate(controller!)
      ..addListener(() {
        setState(() {});
        HiveServices.saveAnimationProgress(controller!.value);
      });

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HiveServices.saveAnimationProgress(controller!.value);

        switch (_tabController.index) {
          case 0:
            ref.read(currentTimerTypeProvider.notifier).state = 'Pomodoro';
            ref.read(timerNotifierProvider.notifier).updateDuration(0);
            ref.read(timerNotifierProvider.notifier).updateColor();
            updateAnimationControllerDuration();
            controller?.reset();

            break;
          case 1:
            ref.read(currentTimerTypeProvider.notifier).state = 'Short Break';
            ref.read(timerNotifierProvider.notifier).updateDuration(0);
            ref.read(timerNotifierProvider.notifier).updateColor();
            updateAnimationControllerDuration();
            controller?.reset();

            break;
          case 2:
            ref.read(currentTimerTypeProvider.notifier).state = 'Long Break';
            ref.read(timerNotifierProvider.notifier).updateDuration(0);
            ref.read(timerNotifierProvider.notifier).updateColor();
            updateAnimationControllerDuration();
            controller?.reset();

            break;
        }
      }
    });
    // HiveServices.retrieveAnimationProgress().then((value) {
    //   controller!.value = value;
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    updateAnimationControllerDuration();
    ref.read(eventNotifierProvider.notifier).addListener((event) {
      if (event == "updateAnimationDuration") {
        updateAnimationControllerDuration();
        controller?.reset();
      }
    });
  }

  @override
  void dispose() {
    HiveServices.saveAnimationProgress(controller!.value);

    _tabController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, read, _) {
        ref
            .read(currentTimerTypeProvider.notifier)
            .addListener((currentTimerType) {
          switch (currentTimerType) {
            case 'Pomodoro':
              _tabController.animateTo(0);
              break;
            case 'Short Break':
              _tabController.animateTo(1);
              break;
            case 'Long Break':
              _tabController.animateTo(2);
              break;
          }
        });

        return Scaffold(
          backgroundColor:  const Color.fromARGB(255, 0, 0, 0),
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(77.0),
            child: AppBar(
              backgroundColor:  const Color.fromARGB(255, 0, 0, 0),
              automaticallyImplyLeading: false,
              elevation: 0.0,
              titleSpacing: 0.0,
              toolbarHeight: 77.0,
              bottom: AppTabBar(tabController: _tabController),
            ),
          ),
          body: Stack(children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: CustomTimePainter(
                  animation: controller!,
                  backgroundColor:
                    const Color.fromARGB(255, 0, 0, 0),
                  color: 
                ref.watch(currentColorProvider),
                   
                ),
              ),
            ),
            Transform.translate(
              offset: const Offset(0, -30),
              child: const TaskCard(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 23, right: 23, bottom: 23),
                child: PlayPauseButton(controller: controller!),
              ),
            )
          ]),
        );
      },
    );
  }
}