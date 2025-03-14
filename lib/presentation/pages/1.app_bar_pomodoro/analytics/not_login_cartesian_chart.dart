import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../../common/utils/responsive_web.dart';
import '../../../../infrastructure/data_sources/hive_services.dart';
import 'time_frame_pop_up_menu_button.dart';

class NotLoginCartesianChart extends ConsumerStatefulWidget {
  final String title;
  const NotLoginCartesianChart({super.key, required this.title});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartesianChartState();
}

class _CartesianChartState extends ConsumerState<NotLoginCartesianChart> {
  late TooltipBehavior _tooltipBehavior;
  String selectedTimeFrame = 'Weekly';
  List<String> timeFrames = ['Weekly', 'Monthly', 'Yearly'];
  @override
  void initState() {
    super.initState();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  List<String> generateWeekDays() {
    List<String> weekDays = [];
    DateTime now = DateTime.now();
    for (int i = -1; i <= 7; i++) {
      String day = DateFormat('dd/MM/yyyy').format(
        now.subtract(
          Duration(days: i),
        ),
      );
      weekDays.add(day);
    }
    return weekDays;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
            color:  Color(0xffF2F2F2),
          ),
          title: Text(
            'Analytics',
            style: textTheme.titleLarge?.copyWith(
              fontFamily: GoogleFonts.nunito(
                color:  const Color(0xffF2F2F2),
              ).fontFamily,
              color:  const Color(0xffF2F2F2),
            ),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<Map<String, Duration>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                final data = snapshot.data!;
                List<Duration> durationsData = [];
                if (selectedTimeFrame == 'Weekly') {
                  durationsData = weekDays
                      .skip(1)
                      .take(7)
                      .map((day) => data[day] ?? Duration.zero)
                      .toList();
                } else if (selectedTimeFrame == 'Monthly') {
                  durationsData = data.values.toList().reversed.toList();
                } else if (selectedTimeFrame == 'Yearly') {
                  durationsData = data.values.toList();
                }
                return Column(children: [
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: TimeFramePopupMenuButton(
                  //     timeFrames: timeFrames,
                  //     currentTimeFrame: selectedTimeFrame,
                  //     onTimeFrameSelected: (newValue) {
                  //       if (newValue != selectedTimeFrame) {
                  //         setState(() {
                  //           selectedTimeFrame = newValue;
                  //         });
                  //       }
                  //     },
                  //   ),
                  // ),
                  // const Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Total Hours Worked: Does not apply',
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      """The weekly data will be available if you log in with Google.
                      Example chart when logged in:""",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                   const Divider(
                        thickness: 2,
                      ),
                  //
                  //   const Padding(
                  //   padding: EdgeInsets.all(8.0),
                  //   child: Text(
                  //     'Example chart when logged in:',
                  //     style: TextStyle(
                  //       fontSize: 16.0,
                  //       fontWeight: FontWeight.w500,
                  //       color: Colors.grey,
                  //     ),
                  //   ),
                  // ),
                   Flexible(
                    
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: 
                      //add an image
                      Center(child: Image.asset('assets/images/sample.png')),
                      // SfCartesianChart(),

                    
                    ),
                  ),
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
        ),
      ),
    );
  }
}
