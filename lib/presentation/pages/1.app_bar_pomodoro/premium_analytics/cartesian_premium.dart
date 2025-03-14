

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/utils/responsive_web.dart';
import '../../../../infrastructure/data_sources/hive_services.dart';
import '../../../notifiers/persistent_container_notifier.dart';
import '../../../notifiers/project_state_notifier.dart';
import '../../../notifiers/project_time_notifier.dart';
import '../../../notifiers/providers.dart';
import '../../../repository/auth_repository.dart';
import '../../../widgets/bar_chart_project.dart';
import '../analytics/github_chart.dart';
import 'time_frame_pop_up_premium_menu_button.dart';


class CartesianPremiumChart extends ConsumerStatefulWidget {
  final String title;
  const CartesianPremiumChart({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CartesianPremiumChartState();
}

class _CartesianPremiumChartState extends ConsumerState<CartesianPremiumChart> {
  final int _hoveredIndex = -1; // Add this

  late TooltipBehavior _tooltipBehavior;
  String selectedTimeFrame = 'Weekly';
  List<String> timeFrames = [
    'Weekly',
    'Monthly',
    'Yearly',
  ];
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
    } else if (selectedTimeFrame == 'Yearly') {
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

  // bool? isPremium;
  bool isPremium = false;
  DateTime now = DateTime.now();

  bool isSelected =
      false; // Add a boolean variable to track the selection state

  @override
  Widget build(BuildContext context) {
    bool isEditIconVisible = false;
    final currentProjectProvider = StateProvider<String?>((ref) => null);

    final textTheme = Theme.of(context).textTheme;

    final focusedTaskTitle = ref.watch(focusedTaskTitleProvider);

    final projectNames = ref.watch(projectStateNotifierProvider);

    final selectedContainerIndex = ref.watch(persistentContainerIndexProvider);

    int currentIndex = selectedContainerIndex;
    if (currentIndex >= projectNames.length) {
      currentIndex = projectNames.length - 1;
    }

    // final currentProjectName =
    //     projectNames.isNotEmpty ? projectNames[currentIndex] : 'No project';

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
        projectNames.isNotEmpty ? projectNames[currentIndex] : 'No project';
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
          return FutureBuilder<Map<String, Duration>>(
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final projectTimesNotifier =
                      ref.read(projectTimesProvider.notifier);

                  final currentProjectName = projectNames[currentIndex];

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

                    final now = DateTime.now();
                    final monthData = List.generate(
                      generateMonthDays().length,
                      (index) {
                        final date = DateTime(
                          now.year,
                          now.month,
                          now.day - index,
                        );
                        return ref
                            .read(projectTimesProvider.notifier)
                            .getProjectTimeForMonth(
                                selectedContainerIndex, date);
                      },
                    );
                    durationsData = monthData;

                  } else if (selectedTimeFrame == 'Yearly') {

                    final now = DateTime.now();
                    final yearData = List.generate(
                      12,
                      (index) {
                        // Calculate month by going backwards from current month
                        int month = now.month - index;
                        int year = now.year;

                        // Handle wrapping around to previous year
                        if (month <= 0) {
                          month += 12;
                          year -= 1;
                        }

                        final date = DateTime(year, month, 1);
                        return ref
                            .read(projectTimesProvider.notifier)
                            .getProjectTimeForYear(
                                selectedContainerIndex, date);
                      },
                    ).reversed.toList(); // Reverse to show oldest to newest
                    durationsData = yearData;
                  }

                  Duration totalDuration =
                      calculateTotalDuration(durationsData);
                  String formattedTotalDuration = formatDuration(totalDuration);
                  return Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TimeFramePopupPremiumMenuButton(
                              timeFrames: timeFrames,
                              currentTimeFrame: selectedTimeFrame,
                              isPremium: isPremium, // Add this line

                              // * WEEKLY, MONTHLY , YEARLY AND GITHUB CHART

                              //* unlocks premium features
                              onTimeFrameSelected: (newValue) {
                                if (newValue != selectedTimeFrame &&
                                    isPremium == false) {
                                  setState(() {
                                    selectedTimeFrame = newValue;
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                 
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

                    // * weekly and monthly chart

                    Flexible(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Consumer(
                          builder: (context, ref, child) {
                            final selectedContainerIndex =
                                ref.watch(persistentContainerIndexProvider) ??
                                    0;
                            final projectNames =
                                ref.watch(projectStateNotifierProvider);

                            // Add bounds checking
                            final currentProjectName = projectNames
                                        .isNotEmpty &&
                                    selectedContainerIndex < projectNames.length
                                ? projectNames[selectedContainerIndex]
                                : 'No project';

                            final totalProjectTime = ref
                                .read(projectTimesProvider.notifier)
                                .getTotalProjectTime(selectedContainerIndex);

                            return Text(
                              //center the text
                              textAlign: TextAlign.center,
                              // 'Total Hours Worked: $formattedTotalDuration',
                              'Project: $currentProjectName, Total Hours Worked: $formattedTotalDuration',
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
                                        ref.watch(userProvider)?.isPremium ??
                                            false;
                                    bool isLocked =
                                        isPremiumContainer && !isUserPremium;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 2.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          if (isLocked) {
                                            // // _showPremiumDialog(context);
                                            // showAboutDialog(context: context);
                                            // // showCupertinoDialog(context: context, builder: builder)
                                            // // add a showCupertinoDialog diciend que se suscriba a premium
                                            // //un nuevo showCupertinoDialog
                                            // showCupertinoDialog(context: context, builder: (context) => GoPremium());
                                          } else {
                                            // Lógica existente para seleccionar el contenedor
                                            ref
                                                .read(
                                                    persistentContainerIndexProvider
                                                        .notifier)
                                                .updateIndex(index);
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
                                          isPremiumLocked:
                                              isLocked, // Añadimos este parámetro
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
                                final selectedContainerIndex = ref.watch(
                                        persistentContainerIndexProvider) ??
                                    0;
                                final currentColor = projectColors[
                                    selectedContainerIndex %
                                        projectColors.length];

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
                                            // '$formattedDate\nTime Worked: $formattedDuration',
                                            // 'Time Worked: $formattedDuration',
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
                                          // return data.keys.toList()[index];

                                          //  final now = DateTime.now();
                                          // final date = DateTime(now.year, index + 1, 1);
                                          // return DateFormat('MMM').format(date);

                                          final now = DateTime.now();
                                          // Calculate month by going forward from oldest month
                                          int month = (now.month - 11 + index);
                                          int year = now.year;

                                          // Handle wrapping around from previous year
                                          if (month <= 0) {
                                            month += 12;
                                            year -= 1;
                                          }

                                          final date = DateTime(year, month, 1);
                                          return DateFormat('MMM').format(date);
                                        } else if (selectedTimeFrame ==
                                            'Monthly') {
                                          // DateTime date =
                                          //     DateFormat('dd/MM/yyyy').parse(
                                          //         data.keys
                                          //             .toList()
                                          //             .reversed
                                          //             .toList()[index]);
                                          // return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";

                                          final now = DateTime.now();
                                          final date = DateTime(now.year,
                                              now.month, now.day - index);
                                          return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";

                                          // final date = DateFormat('dd/MM/yyyy').parse(generateMonthDays()[index]);
                                          // return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";

                                          // final date = DateFormat('dd/MM/yyyy').parse(generateMonthDays()[index]);
                                          // return "${DateFormat('MMM').format(date)} ${DateFormat('d').format(date)}";
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

















