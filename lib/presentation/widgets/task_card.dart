import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../common/utils/responsive_show_dialogs.dart';
import '../notifiers/persistent_container_notifier.dart';
import '../notifiers/project_state_notifier.dart';
import '../notifiers/project_time_notifier.dart';
import '../notifiers/providers.dart';
import '../notifiers/timer_notifier_provider.dart';
import '../pages/0.appbar_features/2_app_bar_icons/profile/ready_soon_features.dart';
import '../repository/auth_repository.dart';
import 'add_projects.dart';

class TaskCard extends ConsumerStatefulWidget {
  const TaskCard({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TaskCardState();
}

class _TaskCardState extends ConsumerState<TaskCard> {
  // bool _isEditIconVisible = false; ````
  int _hoveredIndex = -1; // Add this
  @override
  Widget build(
    BuildContext context,
  ) {
    final timerValue = ref.watch(timerNotifierProvider);
    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider);
    
    final taskCardTitle = ref.watch(taskCardTitleProvider); // Añadimos esta línea
    final projectNames = ref.watch(projectStateNotifierProvider);
     final taskDeletionByTrashIcon = ref.watch(taskDeletionsProvider); 
    final user = ref.watch(userProvider);

    // final selectedContainerIndex = ref
    //     .watch(selectedProyectContainerProvider.select((value) => value ?? 0));

    // final selectedContainerIndex =
    //     ref.watch(selectedProyectContainerProvider) ?? 0;

           final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
    // final projectNames = ref.watch(projectStateNotifierProvider);
    

    int currentIndex = selectedContainerIndex;
    if (currentIndex >= projectNames.length) {
      currentIndex = projectNames.length - 1;
    }

    // final currentProjectName = projectNames.isNotEmpty
    //     ? projectNames[currentIndex]
    //     : 'Añadir Proyecto';

      // Get the current project name based on the selected index
    final currentProjectName = selectedContainerIndex < projectNames.length 
        ? projectNames[selectedContainerIndex]
        : 'Add a project';


    print('Added project: $currentProjectName'); // Debug print
    print('Current Project Names: $projectNames'); // Debug print
    print('Selected Project Index: $selectedContainerIndex'); // Debug print
    print('Current Project Name: $currentProjectName'); // Debug print

    final hoursStr =
        ((timerValue / 3600) % 60).floor().toString().padLeft(2, '0');
    final minutesStr =
        ((timerValue / 60) % 60).floor().toString().padLeft(2, '0');
    final secondsStr = (timerValue % 60).floor().toString().padLeft(2, '0');

    return LayoutBuilder(builder: (context, constraints) {
      final currentWidth = MediaQuery.of(context).size.width;
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 27.0, bottom: 27.0, right: 0.0, left: 23.0),
              // padding: const EdgeInsets.symmetric(vertical: 0, horizontal:0),
              child: Center(
                child: Container(
                  // color: Colors.red,
                  // width: MediaQuery.of(context).size.width /1.5,
                  // width: 350,
                  height: 180,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20), // Create a Radius object
                      bottomLeft: Radius.circular(20),
                    ),
                    color: Color(0xFF121212),
                    // color: Color.fromARGB(255, 157, 105, 105),
                  ),
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Tooltip(
                              message:
                                  "Please, click on the 'Pause' button to save the time spent",
                              child: Icon(
                                CupertinoIcons.lightbulb,
                                color: Color(0xffF2F2F2),
                                size: 24.0,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Text(


                                 // Mostrar taskCardTitle si:
                                // 1. La tarjeta no ha sido eliminada (!taskDeletionByTrashIcon)
                                // 2. Existe un taskCardTitle (taskCardTitle.isNotEmpty)
                                // !taskDeletionByTrashIcon && taskCardTitle.isNotEmpty
                                    // ?
                                     "Project: $currentProjectName  ",
                                    // : "Project: 'add project'",
                                  style: GoogleFonts.nunito(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xffF2F2F2)),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      // Text(currentWidth.toString()),
                      if (currentWidth <= 588)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 648)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds    ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 688)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr  ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds      ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 780)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr  ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds       ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 1400)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds             ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      else if (currentWidth <= 1800)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds            ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                     
                     
                      else if (currentWidth <= 2200)
                        Center(
                          child: Container(
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 22),
                                    Text(
                                      'Seconds            ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                     
                     
                     
                      else
                        Center(
                          child: Container(
                            // color: Colors.black,
                            color: const Color(0xFF121212),
                            child: Column(
                              // mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,

                              children: [
                                Text(
                                  '$hoursStr:$minutesStr:$secondsStr   ',
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 8,
                                    fontSize: 50.0,
                                    color: const Color(0xffF2F2F2),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Hours',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Minutes',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                    const SizedBox(width: 24),
                                    Text(
                                      'Seconds             ',
                                      style: GoogleFonts.nunito(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20.0,
                                        color: const Color(0xffF2F2F2),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 27.0, bottom: 27.0, right: 23.0, left: 0.0),
              child: Container(
                height: 180,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  color: Color(0xFF121212),
                ),
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildProjectContainer(const Color(0xffF04442), 0),
                      _buildProjectContainer(const Color(0xffF4A338), 1),
                      _buildProjectContainer(const Color(0xFFF8CD34), 2),
                      _buildProjectContainer(const Color(0xff4FCE5D), 3),
                      _buildProjectContainer(const Color(0xff4584DB), 4),
                      _buildProjectContainer(const Color(0xffAE73D1), 5),
                      _buildProjectContainer(const Color(0xffEA73AD), 6),
                      _buildProjectContainer(const Color(0xff9B9A9E), 7),

                    
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildProjectContainer(Color color, int index) {
    final projectNames = ref.watch(projectStateNotifierProvider);
    // final selectedContainerIndex =
    //     ref.watch(selectedProyectContainerProvider) ?? 0;
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);

    final user = ref.watch(userProvider.notifier).state;

    bool isPremiumContainer = index >= 4;
    bool isUserPremium = user?.isPremium ?? false;
    bool isLocked = isPremiumContainer && !isUserPremium;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0.0, 0.0, 1.5, 0.0),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              if (!isLocked) {
                setState(() => _hoveredIndex = -1);
            ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);

                // ref
                //     .read(selectedProyectContainerProvider.notifier)
                //     .update((state) => index);

                if (isPremiumContainer && projectNames.length <= index) {
                  _showAddDialog(context, 'Add Premium Project',
                      'Please add a project name', index);
                }
              } else {
                _showPremiumDialog(context);
              }
            },
            child: AddProyectName(
              color,
              index: index,
              isEditable: !isLocked,
              isEditIconVisible: _hoveredIndex == index &&
                  projectNames.isNotEmpty &&
                  projectNames.length > index &&
                  projectNames[index] != 'Add a project' &&
                  !isLocked,
              onEnterContainerHover: (p0) {
                setState(() => _hoveredIndex = index);
              },
              onExitContainerHover: (p0) {
                setState(() => _hoveredIndex = -1);
              },
              icon: isLocked
                  ? const Icon(
                    // Icons.lock
                     CupertinoIcons.lock
                    , color: Colors.white, size: 16)
                  : null,
            ),
          ),
        ),
        if (selectedContainerIndex == index && !isLocked)
          // Icon(Icons.arrow_drop_up, color: color, size: 24),
        Icon(CupertinoIcons.arrow_up_circle_fill, color: color, size: 24),
      ],
    );
  }

void _showAddDialog(BuildContext context, String title, String placeholder, int index) {
    String projectTitle = '';
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(placeholder),
              const SizedBox(height: 16),
              CupertinoTextField(
                placeholder: 'Project name',
                style: const TextStyle(color: Colors.white),
                onChanged: (value) {
                  projectTitle = value;
                },
              ),
            ],
          ),
          actions: [
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                if (projectTitle.isNotEmpty) {
                  ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);
                  ref.read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref);
                  ref.read(projectTimesProvider.notifier).addTime(
                      index, DateTime.now(), Duration.zero);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }


  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return 
        

        ResponsiveShowDialogs(
          child: SimpleDialog(
            backgroundColor:
                const Color.fromARGB(0, 0, 0, 0),
            children: [
              SizedBox(
                width: MediaQuery.of(
                            context)
                        .size
                        .width *
                    0.4,
                child:
                    const PremiumReadySoon(),
              ),
            ],
          ),
        );
      },
    );
  }
}
