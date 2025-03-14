// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';

// import '../../../../infrastructure/data_sources/hive_services.dart';
// import '../../../notifiers/persistent_container_notifier.dart';
// import '../../../notifiers/project_state_notifier.dart';
// import '../../../notifiers/project_time_notifier.dart';
// import '../../../notifiers/providers.dart';
// import '../../../repository/auth_repository.dart';

// // ? THE CHART DOSENT FLICKER

// class GitHubChart extends ConsumerWidget {
//   const GitHubChart({super.key});

//   final List<Color> projectColors = const [
//     Color(0xffF04442),
//     Color(0xffF4A338),
//     Color(0xFFF8CD34),
//     Color(0xff4FCE5D),
//     Color(0xff4584DB),
//     Color(0xffAE73D1),
//     Color(0xffEA73AD),
//     Color(0xff9B9A9E),
//   ];


//   void _showPremiumDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: const Text('Premium Feature'),
//           content: const Text(
//               'This feature is only available for premium users. Would you like to upgrade?'),
//           actions: [
//             CupertinoDialogAction(
//               child: const Text('Cancel'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             CupertinoDialogAction(
//               child: const Text('Upgrade'),
//               onPressed: () {
//                 // Implementa la lógica de actualización aquí
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }



//   Color getColorShade(Color baseColor, double factor) {
//     int r = (baseColor.red * factor).round().clamp(0, 255);
//     int g = (baseColor.green * factor).round().clamp(0, 255);
//     int b = (baseColor.blue * factor).round().clamp(0, 255);
//     return Color.fromRGBO(r, g, b, 1);
//   }

//   Color getColorBasedOnMinutes(double minutes, Color baseColor) {
//     if (minutes >= 480) return getColorShade(baseColor, 1.6);
//     if (minutes >= 360) return getColorShade(baseColor, 1.2);
//     if (minutes >= 240) return getColorShade(baseColor, 0.8);
//     if (minutes >= 120 ||minutes >= 1) return getColorShade(baseColor, 0.4);
//     return const Color(0xff262626);
//   }

//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, "0");
//     String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
//     String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
//     return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
//   }

//   String formatDate(DateTime date, {bool useShortFormat = false}) {
//     String dayOfWeek = useShortFormat
//         ? DateFormat('E').format(date)
//         : DateFormat('EEEE').format(date);
//     String dayOfMonth = DateFormat('d').format(date);
//     String month = useShortFormat
//         ? DateFormat('MMM').format(date)
//         : DateFormat('MMMM').format(date);
//     return "$dayOfWeek, $month $dayOfMonth";
//   }

//   Widget _buildColorBox(BuildContext context, Color color, String tooltip) {
//     return Tooltip(
//       message: tooltip,
//       textStyle: const TextStyle(
//         color: Colors.white,
//         fontFamily: 'San Francisco',
//         fontWeight: FontWeight.w500,
//       ),
//       decoration: BoxDecoration(
//         color: const Color(0xff6E7681),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 2.0),
//         child: Container(
//           height: 12.5,
//           width: 12.5,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(2),
//             color: color,
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
    
//     final selectedContainerIndex =
//         ref.watch(persistentContainerIndexProvider) ?? 0;
    
//     final projectNames = ref.watch(projectStateNotifierProvider);
    
  
//   // N E W  C O D E    B E L O W
//     // Safe access to project names
//   final validIndex = projectNames.isEmpty ? 0 : selectedContainerIndex.clamp(0, projectNames.length - 1);
//   final currentProjectName = projectNames.isEmpty ? 'Add a project' : projectNames[validIndex];
  

//   // N E W  C O D E    A B O VE
  
//     final Color currentColor =
//         projectColors[selectedContainerIndex % projectColors.length];
    
    
//     // final currentProjectName = projectNames[selectedContainerIndex];
   
       
//    final isUserPremium = ref.watch(userProvider)?.isPremium ?? false;

//     final isPremiumContainer = selectedContainerIndex >= 4;

//     return Column(
//       children: [
//         Expanded(
//           child: FutureBuilder<Map<String, Duration>>(
//             future: HiveServices.retrieveGithubYearlyChartData(),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done &&
//                   snapshot.hasData) {

//       if (isPremiumContainer && !isUserPremium) {
//                   // Si el contenedor seleccionado es premium y el usuario no es premium,
//                   // mostramos un mensaje en lugar del gráfico
//                   return Center(
//                     child: Text(
//                       'This feature is only available for premium users.',
//                       // '',
//                       style: GoogleFonts.nunito(
//                         color: Colors.grey[200],
//                         fontSize: 16.0,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   );
//                 }

//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 32.0),
//                   child: GridView.builder(
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                       crossAxisCount: 53,
//                       childAspectRatio: 1,
//                     ),
//                     itemBuilder: (context, index) {
//                       final int weekOfYear = 51 - (index % 53);
//                       final int dayOfWeek = index ~/ 53;
//                       final DateTime date = DateTime.now().subtract(
//                         Duration(
//                             days: DateTime.now().weekday -
//                                 dayOfWeek +
//                                 7 * weekOfYear),
//                       );

//                       if (date.isAfter(DateTime.now())) {
//                         return Container();
//                       }

//                       final String key = DateFormat('dd/MM/yyyy').format(date);
//                       final Duration projectDuration = ref
//                           .read(projectTimesProvider.notifier)
//                           .getProjectTime(selectedContainerIndex, date);
//                       final double minutes = projectDuration.inSeconds / 60.0;
//                       final Color boxColor =
//                           getColorBasedOnMinutes(minutes, currentColor);

//                       final bool isCurrentDay =
//                           date.year == DateTime.now().year &&
//                               date.month == DateTime.now().month &&
//                               date.day == DateTime.now().day;

//                       return Container(
//                         margin: const EdgeInsets.all(1),
//                         padding: const EdgeInsets.all(2),
//                         decoration: BoxDecoration(
//                           color: boxColor,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                         child: Tooltip(
//                           message: isCurrentDay
//                               // ? '${formatDate(date, useShortFormat: true)}, ${date.year}, Project: $currentProjectName, Total Hours Worked: ${formatDuration(ref.read(projectTimesProvider.notifier).getTotalProjectTime(selectedContainerIndex))}'
//                               // : '${formatDate(date, useShortFormat: true)}, ${date.year}, Project: $currentProjectName, Hours Worked: ${formatDuration(projectDuration)}',
//                               // ? '${formatDate(date, useShortFormat: true)}, ${date.year}, Project: $currentProjectName, \nTotal Hours Worked: ${formatDuration(ref.read(projectTimesProvider.notifier).getTotalProjectTime(selectedContainerIndex))}'
//                               ? '${formatDate(date, useShortFormat: true)}, ${date.year}, \nProject: $currentProjectName, \nHours Worked: ${formatDuration(projectDuration)}'
//                               : '${formatDate(date, useShortFormat: true)}, ${date.year}, \nProject: $currentProjectName, \nHours Worked: ${formatDuration(projectDuration)}',
                         
                          
//                           textStyle: const TextStyle(
//                             color: Colors.white,
//                             fontFamily: 'San Francisco',
//                             fontWeight: FontWeight.w500,
//                           ),
//                           decoration: BoxDecoration(
//                             color: const Color(0xff6E7681),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           padding: const EdgeInsets.all(8),
//                           verticalOffset: 20,
//                           margin: const EdgeInsets.all(5),
//                         ),
//                       );
//                     },
//                     itemCount: 7 * 53,
//                   ),
//                 );
//               } else {
//                 return const CircularProgressIndicator();
//               }
//             },
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(right: 5.0),
//                 child: Text(
//                   'Less',
//                   style: GoogleFonts.nunito(
//                     color: const Color(0xffF2F2F2),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//               _buildColorBox(context, const Color(0xff262626), 'No activity'),
             
//               _buildColorBox(
//                   context, getColorShade(currentColor, 0.4), 'The first minute and two hours—or even more'),
//               _buildColorBox(
//                   context, getColorShade(currentColor, 0.8), 'Four hours—or even more'),
//               _buildColorBox(
//                   context, getColorShade(currentColor, 1.2), 'Six hours—or even more'),
//               _buildColorBox(
//                   context, getColorShade(currentColor, 1.6), 'Eight hours—or even more'),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0),
//                 child: Text(
//                   'More',
//                   style: GoogleFonts.nunito(
//                     color: const Color(0xffF2F2F2),
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

























import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../infrastructure/data_sources/hive_services.dart';
import '../../../notifiers/persistent_container_notifier.dart';
import '../../../notifiers/project_state_notifier.dart';
import '../../../notifiers/project_time_notifier.dart';
import '../../../repository/auth_repository.dart';


class GitHubChart extends ConsumerWidget {
  const GitHubChart({super.key});

  final List<Color> projectColors = const [
    Color(0xffF04442),
    Color(0xffF4A338),
    Color(0xFFF8CD34),
    Color(0xff4FCE5D),
    Color(0xff4584DB),
    Color(0xffAE73D1),
    Color(0xffEA73AD),
    Color(0xff9B9A9E),
  ];

  Color getColorShade(Color baseColor, double factor) {
    int r = (baseColor.red * factor).round().clamp(0, 255);
    int g = (baseColor.green * factor).round().clamp(0, 255);
    int b = (baseColor.blue * factor).round().clamp(0, 255);
    return Color.fromRGBO(r, g, b, 1);
  }

  Color getColorBasedOnMinutes(double minutes, Color baseColor) {
    if (minutes >= 480) return getColorShade(baseColor, 1.6);
    if (minutes >= 360) return getColorShade(baseColor, 1.2);
    if (minutes >= 240) return getColorShade(baseColor, 0.8);
    if (minutes >= 120 || minutes >= 1) return getColorShade(baseColor, 0.4);
    return const Color(0xff262626);
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String formatDate(DateTime date, {bool useShortFormat = false}) {
    String dayOfWeek = useShortFormat
        ? DateFormat('E').format(date)
        : DateFormat('EEEE').format(date);
    String dayOfMonth = DateFormat('d').format(date);
    String month = useShortFormat
        ? DateFormat('MMM').format(date)
        : DateFormat('MMMM').format(date);
    return "$dayOfWeek, $month $dayOfMonth";
  }

  Widget _buildColorBox(BuildContext context, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      textStyle: const TextStyle(
        color: Colors.white,
        fontFamily: 'San Francisco',
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: const Color(0xff6E7681),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: Container(
          height: 12.5,
          width: 12.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider) ?? 0;
    final projectNames = ref.watch(projectStateNotifierProvider);
    final isUserPremium = ref.watch(userProvider)?.isPremium ?? false;
    final isPremiumContainer = selectedContainerIndex >= 4;

    // Asegurarse de que tenemos un nombre de proyecto válido para el contenedor actual
    final String currentProjectName;
    if (projectNames.isEmpty || selectedContainerIndex >= projectNames.length) {
      currentProjectName = 'Add a project';
    } else {
      currentProjectName = projectNames[selectedContainerIndex];
    }

    final Color currentColor = projectColors[selectedContainerIndex % projectColors.length];

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<Map<String, Duration>>(
            future: HiveServices.retrieveGithubYearlyChartData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                if (isPremiumContainer && !isUserPremium) {
                  return Center(
                    child: Text(
                      'This feature is only available for premium users.',
                      style: GoogleFonts.nunito(
                        color: Colors.grey[200],
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 53,
                      childAspectRatio: 1,
                    ),
                    itemBuilder: (context, index) {
                      final int weekOfYear = 51 - (index % 53);
                      final int dayOfWeek = index ~/ 53;
                      final DateTime date = DateTime.now().subtract(
                        Duration(days: DateTime.now().weekday - dayOfWeek + 7 * weekOfYear),
                      );

                      if (date.isAfter(DateTime.now())) {
                        return Container();
                      }

                      // Obtener la duración específica para este proyecto y fecha
                      final Duration projectDuration = ref
                          .read(projectTimesProvider.notifier)
                          .getProjectTime(selectedContainerIndex, date);
                      
                      final double minutes = projectDuration.inSeconds / 60.0;
                      final Color boxColor = getColorBasedOnMinutes(minutes, currentColor);

                      final bool isCurrentDay = date.year == DateTime.now().year &&
                          date.month == DateTime.now().month &&
                          date.day == DateTime.now().day;

                      return Container(
                        margin: const EdgeInsets.all(1),
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: boxColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Tooltip(
                          message: '${formatDate(date, useShortFormat: true)}, ${date.year}\n'
                              'Project: $currentProjectName\n'
                              'Hours Worked: ${formatDuration(projectDuration)}',
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'San Francisco',
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff6E7681),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(8),
                          verticalOffset: 20,
                          margin: const EdgeInsets.all(5),
                        ),
                      );
                    },
                    itemCount: 7 * 53,
                  ),
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(50, 5, 50, 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Text(
                  'Less',
                  style: GoogleFonts.nunito(
                    color: const Color(0xffF2F2F2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _buildColorBox(context, const Color(0xff262626), 'No activity'),
              _buildColorBox(context, getColorShade(currentColor, 0.4), 'The first minute and two hours—or even more'),
              _buildColorBox(context, getColorShade(currentColor, 0.8), 'Four hours—or even more'),
              _buildColorBox(context, getColorShade(currentColor, 1.2), 'Six hours—or even more'),
              _buildColorBox(context, getColorShade(currentColor, 1.6), 'Eight hours—or even more'),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(
                  'More',
                  style: GoogleFonts.nunito(
                    color: const Color(0xffF2F2F2),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
