import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../notifiers/providers.dart';

class TimerSettingState extends ConsumerStatefulWidget {
  final String title;
  final StateProvider<int> stateProvider;

  const TimerSettingState({
    super.key,
    required this.title,
    required this.stateProvider,
  });

  @override
  TimerSettingStateState createState() => TimerSettingStateState();
}

class TimerSettingStateState extends ConsumerState<TimerSettingState> {
  late TextEditingController stateController;

  @override
  void initState() {
    super.initState();
    stateController = TextEditingController(
      text: ref.read(widget.stateProvider).toString(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // stateController.text =
    //     ref.watch(widget.stateProvider.notifier).state.toString();
    // stateController.selection = TextSelection.fromPosition(
    //   TextPosition(
    //     offset: stateController.text.length,
    //   ),
    // );
    final pomodoroTimer = ref.watch(widget.stateProvider);
    if (stateController.text != pomodoroTimer.toString()) {
      stateController.text = pomodoroTimer.toString();
      stateController.selection = TextSelection.fromPosition(
        TextPosition(offset: stateController.text.length),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        ListTile(
          title: Text(
            widget.title,
            style: GoogleFonts.nunito(),
          ),
          trailing: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            width: 60,
            child: Material(
              color: const Color(0xff1c1b1f),
              borderRadius: BorderRadius.circular(10.0),
              child: TextField(
                controller: stateController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4)
                ],
                decoration: InputDecoration(
                  fillColor: const Color(0xff1c1b1f),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  isDense: true,
                  filled: true,
                ),
                style: GoogleFonts.nunito(),
                onChanged: (value) {
                  final enteredMinutes = int.tryParse(value);
                  if (enteredMinutes != null) {
                 
                              //  ref.read(pomodoroTimerProvider.notifier).state = enteredMinutes;
                     if (widget.title == 'Pomodoro') {
                    ref.read(pomodoroTimerProvider.notifier).state = enteredMinutes;
                  } else if (widget.title == 'Short Break') {
                    ref.read(shortBreakProvider.notifier).state = enteredMinutes;
                  } 

                  //now add for longbreaktimer
                  else if (widget.title == 'Long Break') {
                    ref.read(longBreakProvider.notifier).state = enteredMinutes;
                  }


                  
                    if (widget.title == 'Long Break Interval' &&
                        enteredMinutes > 4) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Max of 4 long breaks per day allowed for a healthy work-life balance. Consider adjusting work sessions or short breaks if needed',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: const Color(0xffF2F2F2),
                            ),
                          ),
                          backgroundColor: const Color(0xff3B3B3B),
                          duration: const Duration(seconds: 8),
                        ),
                      );
                      stateController.text = '4';
                      stateController.selection = TextSelection.fromPosition(
                          TextPosition(offset: stateController.text.length));
                      ref.read(widget.stateProvider.notifier).state = 4;
                    } else if (enteredMinutes <= 1440) {
                      ref.read(widget.stateProvider.notifier).state =
                          enteredMinutes;
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'The maximum allowed value is 1440 minutes, equivalent to one day.',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              color: const Color(0xffF2F2F2),
                            ),
                          ),
                          backgroundColor: const Color(0xff3B3B3B),
                        ),
                      );
                      stateController.text = '1440';
                      stateController.selection = TextSelection.fromPosition(
                        TextPosition(
                          offset: stateController.text.length,
                        ),
                      );
                      ref.read(widget.stateProvider.notifier).state = 1440;
                    }
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
