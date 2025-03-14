import 'dart:html' as html;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../common/utils/responsive_web.dart';
import '../../../../infrastructure/data_sources/hive_services.dart';
import '../../../notifiers/providers.dart';
import '../../../notifiers/timer_notifier_provider.dart';
import '../../../repository/auth_repository.dart';
import '../../../widgets/alarm_sound_popup_menu_button.dart';
import '../../../widgets/color_choice.dart';
import '../../../widgets/timer_setting_state.dart';


final List<Color> darkModeColorOptions = [
  const Color(0xFF74F143),
  const Color(0xffff9933),
  const Color(0xFF0891FF),
  const Color(0xFFAB67FF),
  const Color(0xFFEF4444),
  const Color(0xFFFFDE00),
  const Color.fromARGB(255, 30, 30, 30),
  const Color(0xff6E7681),
];

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    ref.watch(timerInitProvider);
    ref.watch(soundInitProvider);

    return SafeArea(
      child: ResponsiveWeb(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            iconTheme: const IconThemeData(
              color: Color(0xffF2F2F2),
            ),
            title: Text(
              'Settings',
              style: TextStyle(
                fontFamily: GoogleFonts.nunito(
                  color: const Color(0xffF2F2F2),
                ).fontFamily,
                color: const Color(0xffF2F2F2),
              ),
            ),
            centerTitle: true,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                _buildCard(
                  'Adjust Timer Minutes',
                  Column(
                    children: <Widget>[
                      TimerSettingState(
                        title: 'Pomodoro',
                        stateProvider: pomodoroTimerProvider,
                      ),
                      TimerSettingState(
                        title: 'Short Break',
                        stateProvider: shortBreakProvider,
                      ),
                      TimerSettingState(
                        title: 'Long Break',
                        stateProvider: longBreakProvider,
                      ),
                      TimerSettingState(
                        title: 'Long Break Interval',
                        stateProvider: longBreakIntervalProvider,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  'Sound Settings',
                  ListTile(
                    title: Text('Alarm Sound',
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                        )),
                    trailing: AlarmSoundPopupMenuButton(
                      sounds: ref.watch(soundListProvider),
                      currentSound:
                          ref.watch(selectedSoundProvider).friendlyName,
                      // onSoundSelected: (sound) async {
                      //   ref
                      //       .read(selectedSoundProvider.notifier)
                      //       .updateSound(sound);
                      //   await HiveServices.saveAlarmSoundValue(sound.path);
                      //   await ref
                      //       .read(timerNotifierProvider.notifier)
                      //       .playSound(userTriggered: false);
                      // },
                      onSoundSelected: (sound) async {
                        print("New sound selected: ${sound.path}");
                        
                        // Save new sound and update
                        ref.read(selectedSoundProvider.notifier).updateSound(sound);
                        await HiveServices.saveAlarmSoundValue(sound.path);

                        // Ensure the new sound is loaded and ready for playback
                        await ref.read(timerNotifierProvider.notifier).loadSounds();

                        // Add a small delay to ensure player readiness
                        await Future.delayed(Duration(milliseconds: 200));

                        // Play the selected sound for immediate feedback
                        await ref.read(timerNotifierProvider.notifier).playSound(userTriggered: true);
                      },

                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildCard(
                  'Browser Alerts',
                  ListTile(
                    title: Text(
                      'Notify on timer end',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                      ),
                    ),
                    subtitle: Text(
                      'Please, save to commit changes',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 12,
                      ),
                    ),
                    trailing: Consumer(builder: (context, watch, child) {
                      // final toggleState = ref.watch(notificationToggleProvider);
                      final toggleState =
                          ref.watch(browserNotificationsProvider);

                      return CupertinoSwitch(
                        value: toggleState,
                        onChanged: (value) async {
                          // ref
                          //     .read(notificationToggleProvider.notifier)
                          //     .toggle();
                          ref
                              .read(browserNotificationsProvider.notifier)
                              .toggle();

                          if (value) {
                            // Solicitar permiso para notificaciones del navegador
                            if (html.Notification.supported) {
                              html.Notification.requestPermission()
                                  .then((permission) {
                                if (permission == "granted") {
                                  // El usuario ha concedido permiso
                                  // Puedes mostrar un mensaje de éxito si lo deseas
                                } else {
                                  // El usuario ha denegado el permiso
                                  // Puedes mostrar un mensaje informativo
                                  // El usuario ha denegado el permiso
                                  // ref.read(browserNotificationsProvider.notifier).set(false);
                                }
                              });
                            }
                          }
                          if (!toggleState) {
                            showCupertinoModalPopup(
                              context: context,
                              builder: (context) {
                                return SimpleDialog(
                                    backgroundColor:
                                        const Color.fromARGB(255, 0, 0, 0),
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 7.5,
                                                right: 7.5,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Flexible(
                                                    flex: 1,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                          Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Padding(
                                              padding: EdgeInsets.only(
                                                left: 15.0,
                                                right: 15.0,
                                              ),
                                              child: Divider(
                                                color: Color.fromARGB(
                                                    255, 180, 180, 180),
                                                thickness: 1.0,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 17.5,
                                                right: 17.5,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Center(
                                                    child: Center(
                                                      child: Text(
                                                        'Turn on notifications in your browser and operating system',
                                                        style:
                                                            GoogleFonts.nunito(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 18,
                                                          color: const Color(
                                                              0xffF2F2F2),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.asset(
                                                            'assets/images/pomodoro_timer_notification.jpg',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Flexible(
                                                        flex: 4,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.asset(
                                                            'assets/images/operating_system.jpg',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: Center(
                                                          child: Text(
                                                            'Be sure to untick the "Do Not Disturb" button or any similar option in your operating system.',
                                                            style: GoogleFonts
                                                                .nunito(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                              color: const Color(
                                                                  0xffF2F2F2),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Flexible(
                                                        flex: 4,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15.0),
                                                          child: Image.asset(
                                                            'assets/images/system_notification_do_not_disturb_warning.png',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ]);
                              },
                            );
                          }
                        },
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildCard(
                  'Color Settings',
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Please, click on the circle to select the color',
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ColorChoice(
                        title: 'Pomodoro Color',
                        darkColorProvider: darkPomodoroColorProvider,
                        darkColorOptions: darkModeColorOptions,
                      ),
                      ColorChoice(
                        title: 'Short Break Color',
                        darkColorProvider: darkShortBreakColorProvider,
                        darkColorOptions: darkModeColorOptions,
                      ),
                      ColorChoice(
                        title: 'Long Break Color',
                        darkColorProvider: darkLongBreakColorProvider,
                        darkColorOptions: darkModeColorOptions,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 4.0),
                          child: FloatingActionButton.extended(
                            heroTag: 'btn8',
                            elevation: 4,
                            backgroundColor:
                                const Color.fromARGB(255, 0, 0, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onPressed: () async {
                              final providers = [
                                pomodoroTimerProvider,
                                shortBreakProvider,
                                longBreakProvider,
                                longBreakIntervalProvider,
                              ];
                              for (final provider in providers) {
                                final enteredMinutes = int.tryParse(ref
                                    .read(provider.notifier)
                                    .state
                                    .toString());
                                if (enteredMinutes != null) {
                                  ref.read(provider.notifier).state =
                                      enteredMinutes;
                                }
                              }
                              ref
                                  .read(timerNotifierProvider.notifier)
                                  .updateDuration(0);
                              ref
                                  .read(timerNotifierProvider.notifier)
                                  .updateColor();
                              ref
                                  .read(eventNotifierProvider.notifier)
                                  .notify("updateAnimationDuration");

                              HiveServices.saveAllTimerValues(
                                ref.read(pomodoroTimerProvider.notifier).state,
                                ref.read(shortBreakProvider.notifier).state,
                                ref.read(longBreakProvider.notifier).state,
                                ref
                                    .read(longBreakIntervalProvider.notifier)
                                    .state,
                              );
                              HiveServices.saveAllColorValues(
                                  ref
                                      .read(darkPomodoroColorProvider.notifier)
                                      .state,
                                  ref
                                      .read(
                                          darkShortBreakColorProvider.notifier)
                                      .state,
                                  ref
                                      .read(darkLongBreakColorProvider.notifier)
                                      .state);

                              final pomodoroTimer = ref
                                  .read(pomodoroTimerProvider.notifier)
                                  .state;
                              final shortBreakTimer =
                                  ref.read(shortBreakProvider.notifier).state;

                              final longBreakTimer =
                                  ref.read(longBreakProvider.notifier).state;

                              final longBreakInterval = ref
                                  .read(longBreakIntervalProvider.notifier)
                                  .state;

                              final selectedSound =
                                  ref.read(selectedSoundProvider);

                              final browserNotificationsEnabled =
                                  ref.read(browserNotificationsProvider);

                              final pomodoroColor =
                                  ref.read(darkPomodoroColorProvider);
                              final shortBreakColor =
                                  ref.read(darkShortBreakColorProvider);
                              final longBreakColor =
                                  ref.read(darkLongBreakColorProvider);

                              final errorModel = await ref
                                  .read(authRepositoryProvider)
                                  .updateUserSettings(
                                      pomodoroTimer,
                                      shortBreakTimer,
                                      longBreakTimer,
                                      longBreakInterval,
                                      selectedSound,
                                      browserNotificationsEnabled,
                                      pomodoroColor,
                                      shortBreakColor,
                                      longBreakColor);

                              if (errorModel.error != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(errorModel.error!)),
                                );
                              }
                              Navigator.of(context).pop();
                            },
                            label: Text(
                              'Save',
                              style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimerRow(String label, int value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 5,
            childAspectRatio: 2.0,
            children: List.generate(
              5,
              (index) => Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[800],
                ),
                padding: const EdgeInsets.all(10),
                child: Center(
                  child: Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(String title, Widget child) {
    return Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.nunito(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }
}


