// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import '../../../../common/utils/responsive_show_dialogs.dart';
// import '../../../../common/utils/responsive_web.dart';
// import '../../../../infrastructure/data_sources/hive_services.dart';
// import '../../../notifiers/persistent_container_notifier.dart';
// import '../../../notifiers/project_state_notifier.dart';
// import '../../../notifiers/project_time_notifier.dart';
// import '../../../notifiers/providers.dart';
// import '../../../repository/auth_repository.dart';
// import '../../../widgets/add_projects.dart';
// import '../../../widgets/bar_chart_project.dart';
// import '../../0.appbar_features/2_app_bar_icons/profile/go_premium.dart';
// import '../../0.appbar_features/2_app_bar_icons/profile/ready_soon_features.dart';
// import 'github_chart.dart';
// import 'time_frame_pop_up_menu_button.dart';
// class CartesianChart extends ConsumerStatefulWidget {
//   final String title;
//   const CartesianChart({super.key, required this.title});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() => _CartesianChartState();
// }

// class _CartesianChartState extends ConsumerState<CartesianChart> {
//   int _hoveredIndex = -1; // Add this

//   late TooltipBehavior _tooltipBehavior;
//   String selectedTimeFrame = 'Weekly';
//   List<String> timeFrames = [
//     'Weekly',
//     'Monthly',
//     'Yearly',
//   ];

//   // ProviderListenable get userProvider => null;

//   @override
//   void initState() {
//     super.initState();
//     _tooltipBehavior = TooltipBehavior(enable: true);
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
//     return "$dayOfWeek \n$month $dayOfMonth";
//   }

//   List<String> generateWeekDays() {
//     List<String> weekDays = [];
//     DateTime now = DateTime.now();
//     for (int i = -1; i <= 7; i++) {
//       // Generates 9 days.
//       String day = DateFormat('dd/MM/yyyy').format(
//         now.subtract(
//           Duration(days: i),
//         ),
//       );
//       weekDays.add(day);
//     }
//     return weekDays;
//   }

//   List<String> generateMonthDays() {
//     final now = DateTime.now();
//     DateTime startDate = DateTime(now.year, now.month - 1, now.day);
//     DateTime endDate = DateTime(now.year, now.month, now.day);
//     int daysDifference = endDate.difference(startDate).inDays;
//     return List.generate(
//       daysDifference,
//       (index) => DateFormat('dd/MM/yyyy').format(
//         startDate.add(
//           Duration(days: index),
//         ),
//       ),
//     );
//   }

//   List<String> generateYearMonths() {
//     final now = DateTime.now();
//     List<String> months = List.generate(
//       12,
//       (index) => DateFormat('MMM').format(
//         DateTime(now.year, index + 1),
//       ),
//     );
//     return [...months.sublist(now.month), ...months.sublist(0, now.month)];
//   }

//   Duration calculateTotalDuration(List<Duration> weekData) {
//     return weekData.fold(Duration.zero, (prev, curr) => prev + curr);
//   }

//   List<String> generateYearMonthsGithubStyle() {
//     final now = DateTime.now();

//     List<String> months = List.generate(13, (index) {
//       int year = now.year;
//       int month = (now.month - 1 + index) % 12 + 1;

//       if (month > now.month) year--;

//       return DateFormat('MMM').format(DateTime(year, month));
//     });

//     return months;
//   }

//   CategoryAxis getXAxis() {
//     if (selectedTimeFrame == 'Weekly') {
//       return const CategoryAxis(
//         minimum: -0.5,
//         maximum: 6.5,
//         interval: 1,
//         labelPlacement: LabelPlacement.onTicks,
//         labelIntersectAction: AxisLabelIntersectAction.multipleRows,
//         axisLine: AxisLine(width: 0),
//         majorTickLines: MajorTickLines(width: 0),
//         rangePadding: ChartRangePadding.round,
//       );
//     } else if (selectedTimeFrame == 'Monthly') {
//       List<String> monthDays = generateMonthDays();
//       return CategoryAxis(
//         interval: 5,
//         minimum: -0.5,
//         maximum: monthDays.length.toDouble() - 0.5,
//         isInversed: true,
//         labelPlacement: LabelPlacement.onTicks,
//         labelIntersectAction: AxisLabelIntersectAction.multipleRows,
//         axisLine: const AxisLine(width: 0),
//         majorTickLines: const MajorTickLines(width: 0),
//         rangePadding: ChartRangePadding.round,
//       );
//     } else if (selectedTimeFrame == 'Github yearly chart') {
//       return const CategoryAxis(
//         interval: 1,
//         minimum: -0.5,
//         maximum: 11.5,
//         labelPlacement: LabelPlacement.onTicks,
//         labelIntersectAction: AxisLabelIntersectAction.multipleRows,
//         axisLine: AxisLine(width: 0),
//         majorTickLines: MajorTickLines(width: 0),
//         rangePadding: ChartRangePadding.round,
//       );
//     } else {
//       return const CategoryAxis(
//         interval: 1,
//         minimum: -0.5,
//         maximum: 11.5,
//         labelPlacement: LabelPlacement.onTicks,
//         labelIntersectAction: AxisLabelIntersectAction.multipleRows,
//         axisLine: AxisLine(width: 0),
//         majorTickLines: MajorTickLines(width: 0),
//         rangePadding: ChartRangePadding.round,
//       );
//     }
//   }

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

//   // bool? isPremium;
//   bool isPremium = false;
//   DateTime now = DateTime.now();

//   bool isSelected =
//       false; // Add a boolean variable to track the selection state
// /*
//   void _showAddDialog(BuildContext context, String title, String placeholder, int index) {
//     String projectTitle = '';
//       final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
//  // Replace selectedProyectContainerProvider with persistentContainerIndexProvider
//   // final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
//   final projectNames = ref.watch(projectStateNotifierProvider);

//    // final selectedContainerIndex =
//     //     ref.watch(selectedProyectContainerProvider) ?? 0;

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(placeholder),
//               const SizedBox(height: 16),
//               CupertinoTextField(
//                 placeholder: 'Project name',
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (value) {
//                   projectTitle = value;
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             CupertinoDialogAction(
//               child: const Text('OK'),
//               onPressed: () {
//                 if (projectTitle.isNotEmpty) {
//              ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);

//                   ref
//                       .read(projectStateNotifierProvider.notifier)
//                       .addProject(projectTitle, selectedContainerIndex, ref);
//                   ref.read(projectTimesProvider.notifier).addTime(
//                       selectedContainerIndex, DateTime.now(), Duration.zero);
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// */

//   void _showAddDialog(
//       BuildContext context, String title, String placeholder, int index) {
//     String projectTitle = '';
//     final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);

//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return CupertinoAlertDialog(
//           title: Text(title),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Text(placeholder),
//               const SizedBox(height: 16),
//               CupertinoTextField(
//                 placeholder: 'Project name',
//                 style: const TextStyle(color: Colors.white),
//                 onChanged: (value) {
//                   projectTitle = value;
//                 },
//               ),
//             ],
//           ),
//           actions: [
//             CupertinoDialogAction(
//               child: const Text('OK'),
//               onPressed: () async {
//                 if (projectTitle.isNotEmpty) {
//                   // First update the container index
//                   ref
//                       .read(persistentContainerIndexProvider.notifier)
//                       .updateIndex(index);
//                   // Save to local storage
//                   ref
//                       .read(localStorageRepositoryProvider)
//                       .setSelectedContainerIndex(index);
//                   // Then add the project
//                   ref
//                       .read(projectStateNotifierProvider.notifier)
//                       .addProject(projectTitle, index, ref);
//                   ref
//                       .read(projectTimesProvider.notifier)
//                       .addTime(index, DateTime.now(), Duration.zero);
//                 }
//                 Navigator.pop(context);
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     bool isEditIconVisible = false;
//     final currentProjectProvider = StateProvider<String?>((ref) => null);
//     final textTheme = Theme.of(context).textTheme;
//     final focusedTaskTitle = ref.watch(focusedTaskTitleProvider);
//     final projectNames = ref.watch(projectStateNotifierProvider);
//     // final selectedContainerIndex =
//     //     ref.watch(selectedProyectContainerProvider) ?? 0;

//     final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
//     // final projectNames = ref.watch(projectStateNotifierProvider);

//     // Initialize with saved index when building
//     // ref.watch(localStorageRepositoryProvider).getSelectedContainerIndex().then((savedIndex) {
//     //   if (savedIndex != selectedContainerIndex) {
//     //     ref.read(selectedProyectContainerProvider.notifier).state = savedIndex;
//     //   }
//     // });

//     int currentIndex = selectedContainerIndex;
//     if (currentIndex >= projectNames.length) {
//       currentIndex = projectNames.length - 1;
//     }

//     // Definir los colores para cada proyecto
//     final List<Color> projectColors = [
//       const Color(0xffF04442),
//       const Color(0xffF4A338),
//       const Color(0xFFF8CD34),
//       const Color(0xff4FCE5D),
//       const Color(0xff4584DB),
//       const Color(0xffAE73D1),
//       const Color(0xffEA73AD),
//       const Color(0xff9B9A9E),
//     ];

//     final projectTimes = ref.watch(projectTimesProvider);
//     final currentProjectName =
//         projectNames.isNotEmpty ? projectNames[currentIndex] : 'No project';
//     final currentProjectTimesMap = projectTimes[currentProjectName] ?? {};

//     Duration getTotalDuration(Map<DateTime, Duration> timesMap) {
//       return timesMap.values.fold(Duration.zero, (prev, curr) => prev + curr);
//     }

//     final totalProjectTime = getTotalDuration(currentProjectTimesMap);
//     // Obtener el color actual basado en el índice seleccionado
//     Color currentColor = projectColors[currentIndex % projectColors.length];

//     List<String> weekDays = generateWeekDays().reversed.toList();

//     Future<Map<String, Duration>> futureData;

//     if (selectedTimeFrame == 'Weekly') {
//       futureData = HiveServices.retrievePomodoroDurationsForWeek();
//     } else if (selectedTimeFrame == 'Monthly') {
//       futureData = HiveServices.retrievePomodoroDurationsForMonth();
//     } else {
//       futureData = HiveServices.retrievePomodoroDurationsForYear();
//     }

//     return ResponsiveWeb(
//       child: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//         appBar: AppBar(
//           backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//           iconTheme: const IconThemeData(
//             color: Color(0xffF2F2F2),
//           ),
//           title: Text(
//             'Analytics',
//             style: textTheme.titleLarge?.copyWith(
//               fontFamily: GoogleFonts.nunito(
//                 color: const Color(0xffF2F2F2),
//               ).fontFamily,
//               color: const Color(0xffF2F2F2),
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Consumer(builder: (context, ref, child) {
//           final user = ref.watch(userProvider.notifier).state;
//           final projectNames = ref.watch(projectStateNotifierProvider);
//           final selectedContainerIndex =
//               ref.watch(persistentContainerIndexProvider);

//           return FutureBuilder<Map<String, Duration>>(
//             future: futureData,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.done) {
//                 if (snapshot.hasData) {
//                   final data = snapshot.data!;
//                   final projectTimesNotifier =
//                       ref.read(projectTimesProvider.notifier);

//                   // final currentProjectName = projectNames[currentIndex];

//                   //             // Check if projectNames is empty
//                   // if (projectNames.isEmpty) {
//                   //   projectNames = ['Añadir Proyecto'];
//                   //   currentIndex = 0;
//                   // }

//                   // // Ensure currentIndex is valid
//                   // currentIndex = currentIndex.clamp(0, projectNames.length - 1);
//                   // final currentProjectName = projectNames[currentIndex];
//                   // Create a mutable copy of projectNames
//                   var mutableProjectNames = List<String>.from(projectNames);
//                   var mutableCurrentIndex = currentIndex;

//                   // Check if projectNames is empty
//                   if (mutableProjectNames.isEmpty) {
//                     mutableProjectNames = ['
//
//
// a project'];
//                     mutableCurrentIndex = 0;
//                   }

//                   // Ensure currentIndex is valid
//                   mutableCurrentIndex = mutableCurrentIndex.clamp(
//                       0, mutableProjectNames.length - 1);
//                   final currentProjectName =
//                       mutableProjectNames[mutableCurrentIndex];

//                   final selectedContainerIndex =
//                       ref.watch(persistentContainerIndexProvider);

//                   final currentColor = projectColors[
//                       selectedContainerIndex % projectColors.length];

//                   List<Duration> durationsData = [];
//                   if (selectedTimeFrame == 'Weekly') {
//                     durationsData = weekDays.skip(1).take(7).map((day) {
//                       final date = DateFormat('dd/MM/yyyy').parse(day);
//                       return ref
//                           .read(projectTimesProvider.notifier)
//                           .getProjectTime(selectedContainerIndex, date);
//                     }).toList();
//                   } else if (selectedTimeFrame == 'Monthly') {
//                     durationsData = data.values.toList().reversed.toList();
//                   } else if (selectedTimeFrame == 'Yearly') {
//                     durationsData = data.values.toList();

//                     Duration totalDuration =
//                         calculateTotalDuration(durationsData);

//                     String formattedTotalDuration =
//                         formatDuration(totalDuration);

//                     return const Column(
//                       children: [],
//                     );
//                   }

//                   Duration totalDuration =
//                       calculateTotalDuration(durationsData);
//                   String formattedTotalDuration = formatDuration(totalDuration);
//                   return Column(children: [
//                     Row(
//                       //center
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Flexible(
//                           flex: 4,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: TimeFramePopupMenuButton(
//                               timeFrames: timeFrames,
//                               currentTimeFrame: selectedTimeFrame,
//                               isPremium: isPremium,

//                               // * WEEKLY, MONTHLY , YEARLY AND GITHUB CHART

//                               //* unlocks premium features
//                               onTimeFrameSelected: (newValue) {
//                                 if (newValue != selectedTimeFrame &&
//                                     isPremium == true) {
//                                   setState(() {
//                                     selectedTimeFrame = newValue;
//                                   });
//                                 }
//                                 // * locks premium features

//                                 if (newValue != selectedTimeFrame &&
//                                     isPremium == false) {
//                                   if ((newValue == 'Monthly' ||
//                                           newValue == 'Yearly') &&
//                                       !isPremium) {
//                                     // Navigate to an empty Scaffold or a screen that informs the user
//                                     // that this feature is premium only
//                                     showCupertinoDialog(
//                                       barrierDismissible: true,
//                                       context: context,
//                                       builder: (BuildContext context) {
//                                         return SimpleDialog(
//                                           backgroundColor:
//                                               const Color.fromARGB(0, 255, 251, 254),
//                                           children: [
//                                             SizedBox(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.4,
//                                               // child: const GoPremium(),
//                                               child: const PremiumReadySoon(),
//                                             ),
//                                           ],
//                                         );
//                                       },
//                                     );
//                                   } else {
//                                     setState(() {
//                                       selectedTimeFrame = newValue;
//                                     });
//                                   }
//                                 }
//                               },
//                             ),
//                           ),
//                         ),
//                         /*
//                         ElevatedButton(
//                           //make the borders less circular

//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder:
//                                   // (context) => CupertinoAlertDialog(
//                                   (context) => CupertinoAlertDialog(
//                                 title: const Text('Alert'),
//                                 content: const Text(
//                                     'Are you sure you want to delete this project?'),
//                                 actions: [
//                                   TextButton(
//                                       onPressed: () {
//                                         // ref.read(projectStateNotifierProvider.notifier).deleteProject(selectedContainerIndex);
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: const Text('Yes')),
//                                   TextButton(
//                                       onPressed: () {
//                                         Navigator.of(context).pop();
//                                       },
//                                       child: const Text('No'))
//                                 ],
//                               ),
//                             );
//                           },
//                           style: ButtonStyle(
//                             padding: WidgetStateProperty.all(
//                                 const EdgeInsets.symmetric(
//                                     horizontal: 30, vertical: 20)),
//                             backgroundColor: WidgetStateProperty.all<Color>(
//                                 // const Color(0xffF43F5E)),
//                                 const Color(0xffF23030)),
//                             foregroundColor:
//                                 WidgetStateProperty.all<Color>(Colors.white),
//                             shape:
//                                 WidgetStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(
//                                   10,
//                                 ),
//                               ),
//                             ),
//                           ),
//                           child: Text(
//                             'Delete Project',
//                             style: GoogleFonts.nunito(
//                                 fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       */
//                         // Reemplaza el ElevatedButton actual con este:
//                         ElevatedButton(
//                           onPressed: () {
//                             showDialog(
//                               context: context,
//                               builder: (context) => CupertinoAlertDialog(
//                                 title: const Text('Delete Project'),
//                                 content: const Text(
//                                     'Are you sure you want to delete this project? This action cannot be undone.'),
//                                 actions: [
//                                   CupertinoDialogAction(
//                                     child: const Text('Cancel'),
//                                     onPressed: () {
//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                   CupertinoDialogAction(
//                                     isDestructiveAction: true,
//                                     child: const Text('Delete'),
//                                     onPressed: () async {
//                                       try {
//                                         // Eliminar proyecto y datos asociados
//                                         final result = await ref
//                                             .read(authRepositoryProvider)
//                                             .deleteProject(
//                                                 selectedContainerIndex);

//                                         if (result.error == null) {
//                                           // Limpiar datos locales
//                                           ref
//                                               .read(projectStateNotifierProvider
//                                                   .notifier)
//                                               .deleteProject(
//                                                   selectedContainerIndex);
//                                           ref
//                                               .read(
//                                                   projectTimesProvider.notifier)
//                                               .clearProjectData(
//                                                   selectedContainerIndex);
//                                         } else {
//                                           print(
//                                               'Error deleting project: ${result.error}');
//                                         }
//                                       } catch (e) {
//                                         print(
//                                             'Error during project deletion: $e');
//                                       }

//                                       Navigator.of(context).pop();
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           style: ButtonStyle(
//                             padding: WidgetStateProperty.all(
//                                 const EdgeInsets.symmetric(
//                                     horizontal: 30, vertical: 20)),
//                             backgroundColor: WidgetStateProperty.all<Color>(
//                                 const Color(0xffF23030)),
//                             foregroundColor:
//                                 WidgetStateProperty.all<Color>(Colors.white),
//                             shape:
//                                 WidgetStateProperty.all<RoundedRectangleBorder>(
//                               RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                             ),
//                           ),
//                           child: Text(
//                             'Delete Project',
//                             style: GoogleFonts.nunito(
//                                 fontSize: 18, fontWeight: FontWeight.w600),
//                           ),
//                         ),
//                       ],
//                     ),

//                     Flexible(
//                       flex: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Consumer(
//                           builder: (context, ref, child) {
//                             final selectedContainerIndex =
//                                 ref.watch(persistentContainerIndexProvider);

//                             final projectNames =
//                                 ref.watch(projectStateNotifierProvider);

//                             // Safe access to project name
//                             final currentProjectName = projectNames.isEmpty
//                                 ? 'Add a project'
//                                 : projectNames[selectedContainerIndex.clamp(
//                                     0, projectNames.length - 1)];

//                             final totalProjectTime = ref
//                                 .read(projectTimesProvider.notifier)
//                                 .getTotalProjectTime(selectedContainerIndex);

//                             return Text(
//                               'Project: $currentProjectName, Total Hours Worked: ${formatDuration(totalProjectTime)}',
//                               style: GoogleFonts.nunito(
//                                 color: Colors.grey[200],
//                                 fontSize: 16.0,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                     ),
//                     Flexible(
//                       flex: 3 * 8,
//                       child: Row(
//                         children: [
//                           Flexible(
//                             flex: 6,
//                             child: Padding(
//                               padding: const EdgeInsets.only(left: 30.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: List.generate(
//                                   projectColors.length,
//                                   (index) {
//                                     bool isPremiumContainer = index >= 4;

//                                     bool isUserPremium =
//                                         user?.isPremium ?? false;
//                                     bool isLocked =
//                                         isPremiumContainer && !isUserPremium;

//                                     return Padding(
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 4.0, vertical: 2.0),
//                                       child: GestureDetector(
//                                         // onTap: () {
//                                         //   if (isLocked) {
//                                         //     _showPremiumDialog(context);
//                                         //     // showCupertinoDialog(
//                                         //     //     context: context,
//                                         //     //     builder: (context) =>
//                                         //     //         const GoPremium());
//                                         //   } else {
//                                         //     // Lógica existente para seleccionar el contenedor
//                                         //     // ref
//                                         //     //     .read(
//                                         //     //         selectedProyectContainerProvider
//                                         //     //             .notifier)
//                                         //     //     .update((state) => index);

//                                         //       ref.read(selectedProyectContainerProvider.notifier).update((state) {
//                                         //       final newIndex = index;
//                                         //       // Save the selected index
//                                         //       ref.read(localStorageRepositoryProvider).setSelectedContainerIndex(newIndex);
//                                         //       return newIndex;
//                                         //     });

//                                         //       // If premium container and project needs to be added
//                                         //       if (isPremiumContainer && projectNames.length <= index) {
//                                         //         _showAddDialog(context, 'Add Premium Project', 'Please add a project name');
//                                         //       }

//                                         //   }
//                                         // },
//                                         onTap: () {
//                                           if (!isLocked) {
//                                             setState(() => _hoveredIndex = -1);
//                                             // Update the persistent container index
//                                             ref
//                                                 .read(
//                                                     persistentContainerIndexProvider
//                                                         .notifier)
//                                                 .updateIndex(index);

//                                             // Save to local storage
//                                             ref
//                                                 .read(
//                                                     localStorageRepositoryProvider)
//                                                 .setSelectedContainerIndex(
//                                                     index);

//                                             if (isPremiumContainer &&
//                                                 projectNames.length <= index) {
//                                               _showAddDialog(
//                                                   context,
//                                                   'Add Premium Project',
//                                                   'Please add a project name',
//                                                   index);
//                                             }
//                                           } else {
//                                             _showPremiumDialog(context);
//                                           }
//                                         },
//                                         child: BarChartProject(
//                                           projectColors[index],
//                                           index: index,
//                                           isEditIconVisible:
//                                               _hoveredIndex == index &&
//                                                   !isLocked,
//                                           icon: isLocked
//                                               ? const Icon(CupertinoIcons.lock,
//                                                   color: Colors.white, size: 16)
//                                               : null,
//                                           isPremiumLocked: isLocked,
//                                         ),
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                             ),
//                           ),
//                           Flexible(
//                             flex: 46,
//                             child: Padding(
//                               padding: const EdgeInsets.all(4.0),
//                               child: Consumer(builder: (context, ref, child) {
//                                 final selectedContainerIndex =
//                                     ref.watch(persistentContainerIndexProvider);

//                                 final currentColor = projectColors[
//                                     selectedContainerIndex %
//                                         projectColors.length];

//                                 //  final selectedContainerIndex = ref.watch(selectedProyectContainerProvider) ?? 0;
//                                 final isUserPremium =
//                                     ref.watch(userProvider)?.isPremium ?? false;
//                                 final isPremiumContainer =
//                                     selectedContainerIndex >= 4;

//                                 if (isPremiumContainer && !isUserPremium) {
//                                   // Si el contenedor seleccionado es premium y el usuario no es premium,
//                                   // mostramos un mensaje en lugar de la gráfica
//                                   return Column(
//                                     children: [
//                                       Center(
//                                         child: Text(
//                                           'This feature is only available for premium users. would you like to upgrade?',
//                                           style: TextStyle(
//                                             color: Colors.grey[200],
//                                             fontSize: 16.0,
//                                             fontWeight: FontWeight.w500,
//                                           ),
//                                         ),
//                                       ),
//                                       //add a button
//                                       ElevatedButton(
//                                         onPressed: () {
//                                           Navigator.push(
//                                             context,
//                                             MaterialPageRoute(
//                                                 builder: (context) =>
//                                                     const GoPremium()),
//                                           );
//                                         },
//                                         child: const Text('Upgrade'),
//                                       ),
//                                     ],
//                                   );
//                                 }

//                                 return SfCartesianChart(
//                                   backgroundColor: Colors.transparent,
//                                   plotAreaBorderColor: Colors.transparent,
//                                   primaryXAxis: getXAxis(),
//                                   primaryYAxis: const NumericAxis(
//                                     isVisible: true,
//                                     axisLine: AxisLine(width: 0),
//                                     majorTickLines: MajorTickLines(width: 0),
//                                     minorTickLines: MinorTickLines(width: 0),
//                                     labelStyle: TextStyle(
//                                         color: Colors.grey,
//                                         fontFamily: 'San Francisco'),
//                                   ),
//                                   tooltipBehavior: TooltipBehavior(
//                                     enable: true,
//                                     color: Colors.white70,
//                                     textStyle: const TextStyle(
//                                         color: Colors.black,
//                                         fontFamily: 'San Francisco'),
//                                     builder: (dynamic dataPoint,
//                                         dynamic point,
//                                         dynamic series,
//                                         int pointIndex,
//                                         int seriesIndex) {
//                                       Duration duration =
//                                           durationsData[pointIndex];
//                                       String formattedDuration =
//                                           formatDuration(duration);
//                                       if (selectedTimeFrame == 'Monthly') {
//                                         DateTime date = DateFormat('dd/MM/yyyy')
//                                             .parse(data.keys
//                                                 .toList()
//                                                 .reversed
//                                                 .toList()[pointIndex]);
//                                         String formattedDate = formatDate(date);
//                                         return Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: Colors.grey[200],
//                                           ),
//                                           child: Text(
//                                             '$formattedDate\nTime Worked: $formattedDuration',
//                                             style: TextStyle(
//                                               color: Colors.grey[800],
//                                               fontFamily: 'San Francisco',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         );
//                                       } else {
//                                         return Container(
//                                           padding: const EdgeInsets.all(8),
//                                           decoration: BoxDecoration(
//                                             borderRadius:
//                                                 BorderRadius.circular(10),
//                                             color: Colors.grey[200],
//                                           ),
//                                           child: Text(
//                                             'Time Worked: $formattedDuration',
//                                             style: TextStyle(
//                                               color: Colors.grey[800],
//                                               fontFamily: 'San Francisco',
//                                               fontWeight: FontWeight.w500,
//                                             ),
//                                           ),
//                                         );
//                                       }
//                                     },
//                                   ),
//                                   series: <CartesianSeries>[
//                                     ColumnSeries<Duration, String>(
//                                       dataSource: durationsData,
//                                       // color: currentColor.withOpacity(0.8),
//                                       color: currentColor,
//                                       borderRadius: BorderRadius.circular(5),
//                                       xValueMapper:
//                                           (Duration duration, int index) {
//                                         if (selectedTimeFrame == 'Yearly') {
//                                           return data.keys.toList()[index];
//                                         } else if (selectedTimeFrame ==
//                                             'Monthly') {
//                                           DateTime date =
//                                               DateFormat('dd/MM/yyyy').parse(
//                                                   data.keys
//                                                       .toList()
//                                                       .reversed
//                                                       .toList()[index]);
//                                           return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";
//                                         } else {
//                                           DateTime date =
//                                               DateFormat('dd/MM/yyyy')
//                                                   .parse(weekDays[index + 1]);
//                                           return formatDate(date,
//                                               useShortFormat: true);
//                                         }
//                                       },
//                                       yValueMapper: (Duration duration, _) =>
//                                           duration.inSeconds / 3600.0,
//                                     ),
//                                   ],
//                                 );
//                               }),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Expanded(flex: 9, child: GitHubChart()),

//                     // const Expanded(
//                     //     flex: 2, child: LessAndMoreContainerGithubChart())
//                   ]);
//                 } else {
//                   return Text(
//                     "Error loading data",
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                     ),
//                   );
//                 }
//               } else {
//                 return const Center(child: CircularProgressIndicator());
//               }
//             },
//           );
//         }),
//       ),
//     );
//   }
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/utils/responsive_show_dialogs.dart';
import '../../../../common/utils/responsive_web.dart';
import '../../../../infrastructure/data_sources/hive_services.dart';
import '../../../notifiers/persistent_container_notifier.dart';
import '../../../notifiers/project_state_notifier.dart';
import '../../../notifiers/project_time_notifier.dart';
import '../../../notifiers/providers.dart';
import '../../../repository/auth_repository.dart';
import '../../../widgets/bar_chart_project.dart';
import '../../0.appbar_features/2_app_bar_icons/profile/go_premium.dart';
import '../../0.appbar_features/2_app_bar_icons/profile/ready_soon_features.dart';
import 'github_chart.dart';
import 'time_frame_pop_up_menu_button.dart';

class CartesianChart extends ConsumerStatefulWidget {
  final String title;
  const CartesianChart({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartesianChartState();
}

class _CartesianChartState extends ConsumerState<CartesianChart> {
  int _hoveredIndex = -1; // Add this

  late TooltipBehavior _tooltipBehavior;
  String selectedTimeFrame = 'Weekly';
  List<String> timeFrames = [
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  // ProviderListenable get userProvider => null;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
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
    return "$dayOfWeek \n$month $dayOfMonth";
  }

  List<String> generateWeekDays() {
    List<String> weekDays = [];
    DateTime now = DateTime.now();
    for (int i = -1; i <= 7; i++) {
      // Generates 9 days.
      String day = DateFormat('dd/MM/yyyy').format(
        now.subtract(
          Duration(days: i),
        ),
      );
      weekDays.add(day);
    }
    return weekDays;
  }

  List<String> generateMonthDays() {
    final now = DateTime.now();
    DateTime startDate = DateTime(now.year, now.month - 1, now.day);
    DateTime endDate = DateTime(now.year, now.month, now.day);
    int daysDifference = endDate.difference(startDate).inDays;
    return List.generate(
      daysDifference,
      (index) => DateFormat('dd/MM/yyyy').format(
        startDate.add(
          Duration(days: index),
        ),
      ),
    );
  }

  List<String> generateYearMonths() {
    final now = DateTime.now();
    List<String> months = List.generate(
      12,
      (index) => DateFormat('MMM').format(
        DateTime(now.year, index + 1),
      ),
    );
    return [...months.sublist(now.month), ...months.sublist(0, now.month)];
  }

  Duration calculateTotalDuration(List<Duration> weekData) {
    return weekData.fold(Duration.zero, (prev, curr) => prev + curr);
  }

  List<String> generateYearMonthsGithubStyle() {
    final now = DateTime.now();

    List<String> months = List.generate(13, (index) {
      int year = now.year;
      int month = (now.month - 1 + index) % 12 + 1;

      if (month > now.month) year--;

      return DateFormat('MMM').format(DateTime(year, month));
    });

    return months;
  }

  CategoryAxis getXAxis() {
    if (selectedTimeFrame == 'Weekly') {
      return const CategoryAxis(
        minimum: -0.5,
        maximum: 6.5,
        interval: 1,
        labelPlacement: LabelPlacement.onTicks,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        rangePadding: ChartRangePadding.round,
      );
    } else if (selectedTimeFrame == 'Monthly') {
      List<String> monthDays = generateMonthDays();
      return CategoryAxis(
        interval: 5,
        minimum: -0.5,
        maximum: monthDays.length.toDouble() - 0.5,
        isInversed: true,
        labelPlacement: LabelPlacement.onTicks,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(width: 0),
        rangePadding: ChartRangePadding.round,
      );
    } else if (selectedTimeFrame == 'Github yearly chart') {
      return const CategoryAxis(
        interval: 1,
        minimum: -0.5,
        maximum: 11.5,
        labelPlacement: LabelPlacement.onTicks,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        rangePadding: ChartRangePadding.round,
      );
    } else {
      return const CategoryAxis(
        interval: 1,
        minimum: -0.5,
        maximum: 11.5,
        labelPlacement: LabelPlacement.onTicks,
        labelIntersectAction: AxisLabelIntersectAction.multipleRows,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(width: 0),
        rangePadding: ChartRangePadding.round,
      );
    }
  }

  void _showPremiumDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Premium Feature'),
          content: const Text(
              'This feature is only available for premium users. Would you like to upgrade?'),
          actions: [
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Upgrade'),
              onPressed: () {
                // Implementa la lógica de actualización aquí
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // bool? isPremium;
  bool isPremium = false;
  DateTime now = DateTime.now();

  bool isSelected =
      false; // Add a boolean variable to track the selection state
/*
  void _showAddDialog(BuildContext context, String title, String placeholder, int index) {
    String projectTitle = '';
      final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
 // Replace selectedProyectContainerProvider with persistentContainerIndexProvider
  // final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
  final projectNames = ref.watch(projectStateNotifierProvider);

   // final selectedContainerIndex =
    //     ref.watch(selectedProyectContainerProvider) ?? 0;

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

                  ref
                      .read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, selectedContainerIndex, ref);
                  ref.read(projectTimesProvider.notifier).addTime(
                      selectedContainerIndex, DateTime.now(), Duration.zero);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
*/

  void _showAddDialog(
      BuildContext context, String title, String placeholder, int index) {
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
              onPressed: () async {
                if (projectTitle.isNotEmpty) {
                  // First update the container index
                  ref
                      .read(persistentContainerIndexProvider.notifier)
                      .updateIndex(index);
                  // Save to local storage
                  ref
                      .read(localStorageRepositoryProvider)
                      .setSelectedContainerIndex(index);
                  // Then add the project
                  ref
                      .read(projectStateNotifierProvider.notifier)
                      .addProject(projectTitle, index, ref);
                  ref
                      .read(projectTimesProvider.notifier)
                      .addTime(index, DateTime.now(), Duration.zero);
                }
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isEditIconVisible = false;
    final currentProjectProvider = StateProvider<String?>((ref) => null);
    final textTheme = Theme.of(context).textTheme;
    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider);
    final projectNames = ref.watch(projectStateNotifierProvider);
    // final selectedContainerIndex =
    //     ref.watch(selectedProyectContainerProvider) ?? 0;

    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);
    // final projectNames = ref.watch(projectStateNotifierProvider);

    // Initialize with saved index when building
    // ref.watch(localStorageRepositoryProvider).getSelectedContainerIndex().then((savedIndex) {
    //   if (savedIndex != selectedContainerIndex) {
    //     ref.read(selectedProyectContainerProvider.notifier).state = savedIndex;
    //   }
    // });

    int currentIndex = selectedContainerIndex;
    if (currentIndex >= projectNames.length) {
      currentIndex = projectNames.length - 1;
    }

    // Definir los colores para cada proyecto
    final List<Color> projectColors = [
      const Color(0xffF04442),
      const Color(0xffF4A338),
      const Color(0xFFF8CD34),
      const Color(0xff4FCE5D),
      const Color(0xff4584DB),
      const Color(0xffAE73D1),
      const Color(0xffEA73AD),
      const Color(0xff9B9A9E),
    ];

    final projectTimes = ref.watch(projectTimesProvider);
    final currentProjectName =
        projectNames.isNotEmpty ? projectNames[currentIndex] : 'Add a project';
    final currentProjectTimesMap = projectTimes[currentProjectName] ?? {};

    Duration getTotalDuration(Map<DateTime, Duration> timesMap) {
      return timesMap.values.fold(Duration.zero, (prev, curr) => prev + curr);
    }

    final totalProjectTime = getTotalDuration(currentProjectTimesMap);
    // Obtener el color actual basado en el índice seleccionado
    Color currentColor = projectColors[currentIndex % projectColors.length];

    List<String> weekDays = generateWeekDays().reversed.toList();

    Future<Map<String, Duration>> futureData;

    if (selectedTimeFrame == 'Weekly') {
      futureData = HiveServices.retrievePomodoroDurationsForWeek();
    } else if (selectedTimeFrame == 'Monthly') {
      futureData = HiveServices.retrievePomodoroDurationsForMonth();
    } else {
      futureData = HiveServices.retrievePomodoroDurationsForYear();
    }

    return ResponsiveWeb(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          iconTheme: const IconThemeData(
            color: Color(0xffF2F2F2),
          ),
          title: Text(
            'Analytics',
            style: textTheme.titleLarge?.copyWith(
              fontFamily: GoogleFonts.nunito(
                color: const Color(0xffF2F2F2),
              ).fontFamily,
              color: const Color(0xffF2F2F2),
            ),
          ),
          centerTitle: true,
        ),
        body: Consumer(builder: (context, ref, child) {
          final user = ref.watch(userProvider.notifier).state;
          final projectNames = ref.watch(projectStateNotifierProvider);
          final selectedContainerIndex =
              ref.watch(persistentContainerIndexProvider);

          return FutureBuilder<Map<String, Duration>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final projectTimesNotifier =
                      ref.read(projectTimesProvider.notifier);

                  // currentIndex = currentIndex.clamp(0, projectNames.length - 1);
                  // final currentProjectName = projectNames[currentIndex];
                  // Create a mutable copy of projectNames
                  var mutableProjectNames = List<String>.from(projectNames);
                  var mutableCurrentIndex = currentIndex;

                  // Check if projectNames is empty
                  if (mutableProjectNames.isEmpty) {
                    mutableProjectNames = ['Add a project'];
                    mutableCurrentIndex = 0;
                  }

                  // Ensure currentIndex is valid
                  mutableCurrentIndex = mutableCurrentIndex.clamp(
                      0, mutableProjectNames.length - 1);
                  final currentProjectName =
                      mutableProjectNames[mutableCurrentIndex];

                  final selectedContainerIndex =
                      ref.watch(persistentContainerIndexProvider);

                  final currentColor = projectColors[
                      selectedContainerIndex % projectColors.length];

                  List<Duration> durationsData = [];
                  if (selectedTimeFrame == 'Weekly') {
                    durationsData = weekDays.skip(1).take(7).map((day) {
                      final date = DateFormat('dd/MM/yyyy').parse(day);
                      return ref
                          .read(projectTimesProvider.notifier)
                          .getProjectTime(selectedContainerIndex, date);
                    }).toList();
                  } else if (selectedTimeFrame == 'Monthly') {
                    durationsData = data.values.toList().reversed.toList();
                  } else if (selectedTimeFrame == 'Yearly') {
                    durationsData = data.values.toList();

                    Duration totalDuration =
                        calculateTotalDuration(durationsData);

                    String formattedTotalDuration =
                        formatDuration(totalDuration);

                    return const Column(
                      children: [],
                    );
                  }

                  Duration totalDuration =
                      calculateTotalDuration(durationsData);
                  String formattedTotalDuration = formatDuration(totalDuration);
                  return Column(children: [
                    Row(
                      //center
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TimeFramePopupMenuButton(
                              timeFrames: timeFrames,
                              currentTimeFrame: selectedTimeFrame,
                              isPremium: isPremium,

                              // * WEEKLY, MONTHLY , YEARLY AND GITHUB CHART

                              //* unlocks premium features
                              onTimeFrameSelected: (newValue) {
                                if (newValue != selectedTimeFrame &&
                                    isPremium == true) {
                                  setState(() {
                                    selectedTimeFrame = newValue;
                                  });
                                }
                                // * locks premium features

                                if (newValue != selectedTimeFrame &&
                                    isPremium == false) {
                                  if ((newValue == 'Monthly' ||
                                          newValue == 'Yearly') &&
                                      !isPremium) {
                                    // Navigate to an empty Scaffold or a screen that informs the user
                                    // that this feature is premium only
                                    showCupertinoDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SimpleDialog(
                                          backgroundColor:
                                              const Color.fromARGB(0, 255, 251, 254),
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              // child: const GoPremium(),
                                              child: const PremiumReadySoon(),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    setState(() {
                                      selectedTimeFrame = newValue;
                                    });
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                        /*
                        ElevatedButton(
                          //make the borders less circular

                          onPressed: () {
                            showDialog(
                              context: context,
                              builder:
                                  // (context) => CupertinoAlertDialog(
                                  (context) => CupertinoAlertDialog(
                                title: const Text('Alert'),
                                content: const Text(
                                    'Are you sure you want to delete this project?'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        // ref.read(projectStateNotifierProvider.notifier).deleteProject(selectedContainerIndex);
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Yes')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('No'))
                                ],
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                // const Color(0xffF43F5E)),
                                const Color(0xffF23030)),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete Project',
                            style: GoogleFonts.nunito(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      */
                        // Reemplaza el ElevatedButton actual con este:
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: const Text('Delete Project'),
                                content: const Text(
                                    'Are you sure you want to delete this project? This action cannot be undone.'),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text('Delete'),
                                    onPressed: () async {
                                      try {
                                        // Eliminar proyecto y datos asociados
                                        final result = await ref
                                            .read(authRepositoryProvider)
                                            .deleteProject(
                                                selectedContainerIndex);

                                        if (result.error == null) {
                                          // Limpiar datos locales
                                          ref
                                              .read(projectStateNotifierProvider
                                                  .notifier)
                                              .deleteProject(
                                                  selectedContainerIndex);
                                          ref
                                              .read(
                                                  projectTimesProvider.notifier)
                                              .clearProjectData(
                                                  selectedContainerIndex);
                                        } else {
                                          print(
                                              'Error deleting project: ${result.error}');
                                        }
                                      } catch (e) {
                                        print(
                                            'Error during project deletion: $e');
                                      }

                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 30, vertical: 20)),
                            backgroundColor: WidgetStateProperty.all<Color>(
                                const Color(0xffF23030)),
                            foregroundColor:
                                WidgetStateProperty.all<Color>(Colors.white),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'Delete Project',
                            style: GoogleFonts.nunito(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),

                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final selectedContainerIndex =
                                ref.watch(persistentContainerIndexProvider);

                            final projectNames =
                                ref.watch(projectStateNotifierProvider);

                            // Safe access to project name
                            final currentProjectName = projectNames.isEmpty
                                ? 'Add a project'
                                : projectNames[selectedContainerIndex.clamp(
                                    0, projectNames.length - 1)];

                            final totalProjectTime = ref
                                .read(projectTimesProvider.notifier)
                                .getTotalProjectTime(selectedContainerIndex);

                            return Text(
                              'Project: $currentProjectName, Total Hours Worked: ${formatDuration(totalProjectTime)}',
                              style: GoogleFonts.nunito(
                                color: Colors.grey[200],
                                fontSize: 16.0,
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3 * 8,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: List.generate(
                                  projectColors.length,
                                  (index) {
                                    bool isPremiumContainer = index >= 4;

                                    bool isUserPremium =
                                        user?.isPremium ?? false;
                                    bool isLocked =
                                        isPremiumContainer && !isUserPremium;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0),
                                    
                                    
                                    
                                    
                                    
                                    
                                    
                                        child: GestureDetector(
                                        onTap: () {
                                          // Verificar si es un contenedor premium y el usuario no es premium
                                          bool isPremiumContainer = index >= 4;
                                          bool isUserPremium =
                                              user?.isPremium ?? false;

                                          if (isPremiumContainer &&
                                              !isUserPremium) {
                                            // Solo mostrar el diálogo premium sin cambiar la selección
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return ResponsiveShowDialogs(
                                                  child: SimpleDialog(
                                                    backgroundColor:
                                                        const Color.fromARGB(
                                                            0, 0, 0, 0),
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
                                            // No permitir ninguna actualización de estado - mantener el contenedor no premium seleccionado
                                            return;
                                          }

                                          // Solo ejecutar el código de selección si NO es un contenedor premium
                                          if (!isPremiumContainer ||
                                              isUserPremium) {
                                            setState(() => _hoveredIndex = -1);
                                            // Actualizar el índice solo si es un contenedor no premium
                                            ref
                                                .read(
                                                    persistentContainerIndexProvider
                                                        .notifier)
                                                .updateIndex(index);
                                            ref
                                                .read(
                                                    localStorageRepositoryProvider)
                                                .setSelectedContainerIndex(
                                                    index);

                                            if (projectNames.length <= index) {
                                              _showAddDialog(
                                                  context,
                                                  'Add a Project',
                                                  'Please, add a name for the project',
                                                  index);
                                            }
                                          }
                                        },
                                        child: BarChartProject(
                                          projectColors[index],
                                          index: index,
                                          isEditIconVisible:
                                              _hoveredIndex == index &&
                                                  !isLocked,
                                          icon: isLocked
                                              ? const Icon(CupertinoIcons.lock,
                                                  color: Colors.white, size: 16)
                                              : null,
                                          isPremiumLocked: isLocked,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 46,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Consumer(builder: (context, ref, child) {
                                final selectedContainerIndex =
                                    ref.watch(persistentContainerIndexProvider);
                                final isUserPremium =
                                    ref.watch(userProvider)?.isPremium ?? false;
                                final isPremiumContainer =
                                    selectedContainerIndex >= 4;

                                // Si se intenta seleccionar un contenedor premium, mostrar el diálogo
                                if (isPremiumContainer && !isUserPremium) {
                                  // Aquí necesitamos resetear la selección a un contenedor no premium
                                  WidgetsBinding.instance
                                      .addPostFrameCallback((_) {
                                    // Resetear al último contenedor no premium (índice 3)
                                    ref
                                        .read(persistentContainerIndexProvider
                                            .notifier)
                                        .updateIndex(3);
                                    ref
                                        .read(localStorageRepositoryProvider)
                                        .setSelectedContainerIndex(3);
                                  });

                                  return ResponsiveShowDialogs(
                                    child: SimpleDialog(
                                      backgroundColor:
                                          const Color.fromARGB(0, 0, 0, 0),
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: const PremiumReadySoon(),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                return SfCartesianChart(
                                  backgroundColor: Colors.transparent,
                                  plotAreaBorderColor: Colors.transparent,
                                  primaryXAxis: getXAxis(),
                                  primaryYAxis: const NumericAxis(
                                    isVisible: true,
                                    axisLine: AxisLine(width: 0),
                                    majorTickLines: MajorTickLines(width: 0),
                                    minorTickLines: MinorTickLines(width: 0),
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontFamily: 'San Francisco'),
                                  ),
                                  tooltipBehavior: TooltipBehavior(
                                    enable: true,
                                    color: Colors.white70,
                                    textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: 'San Francisco'),
                                    builder: (dynamic dataPoint,
                                        dynamic point,
                                        dynamic series,
                                        int pointIndex,
                                        int seriesIndex) {
                                      Duration duration =
                                          durationsData[pointIndex];
                                      String formattedDuration =
                                          formatDuration(duration);
                                      if (selectedTimeFrame == 'Monthly') {
                                        DateTime date = DateFormat('dd/MM/yyyy')
                                            .parse(data.keys
                                                .toList()
                                                .reversed
                                                .toList()[pointIndex]);
                                        String formattedDate = formatDate(date);
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[200],
                                          ),
                                          child: Text(
                                            '$formattedDate\nTime Worked: $formattedDuration',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontFamily: 'San Francisco',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      } else {
                                        return Container(
                                          padding: const EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.grey[200],
                                          ),
                                          child: Text(
                                            'Time Worked: $formattedDuration',
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontFamily: 'San Francisco',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  series: <CartesianSeries>[
                                    ColumnSeries<Duration, String>(
                                      dataSource: durationsData,
                                      // color: currentColor.withOpacity(0.8),
                                      color: currentColor,
                                      borderRadius: BorderRadius.circular(5),
                                      xValueMapper:
                                          (Duration duration, int index) {
                                        if (selectedTimeFrame == 'Yearly') {
                                          return data.keys.toList()[index];
                                        } else if (selectedTimeFrame ==
                                            'Monthly') {
                                          DateTime date =
                                              DateFormat('dd/MM/yyyy').parse(
                                                  data.keys
                                                      .toList()
                                                      .reversed
                                                      .toList()[index]);
                                          return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";
                                        } else {
                                          DateTime date =
                                              DateFormat('dd/MM/yyyy')
                                                  .parse(weekDays[index + 1]);
                                          return formatDate(date,
                                              useShortFormat: true);
                                        }
                                      },
                                      yValueMapper: (Duration duration, _) =>
                                          duration.inSeconds / 3600.0,
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(flex: 9, child: GitHubChart()),

                    // const Expanded(
                    //     flex: 2, child: LessAndMoreContainerGithubChart())
                  ]);
                } else {
                  return Text(
                    "Error loading data",
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  );
                }
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          );
        }),
      ),
    );
  }
}

