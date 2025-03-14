
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:routemaster/routemaster.dart';
import 'infrastructure/data_sources/hive_services.dart';
import 'models/error_model.dart';
import 'models/user_model.dart';
import 'presentation/notifiers/persistent_container_notifier.dart';
import 'presentation/notifiers/pomodoro_notifier.dart';
import 'presentation/notifiers/project_state_notifier.dart';
import 'presentation/notifiers/project_time_notifier.dart';
import 'presentation/notifiers/providers.dart';
import 'presentation/repository/auth_repository.dart';
import 'router.dart';

late Box box;

final container = ProviderContainer();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final notificationSelectedProvider = StateProvider<String?>((ref) => null);

Future main() async {
  debugPaintSizeEnabled = false;

  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await HiveServices.openBox();



  if (html.Notification.supported) {
    bool browserNotificationsEnabled =
        html.Notification.permission == "granted";
    await HiveServices.saveNotificationSwitchState(browserNotificationsEnabled);
  }

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  NotificationAppLaunchDetails? notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    debugPrint('notification payload: ');
  }

  runApp(
    const ProviderScope(
      overrides: [],
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState {
  ErrorModel? errorModel;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  void getUserData() async {
    errorModel = await ref.read(authRepositoryProvider).getUserData();

      // Primero recuperar el taskCardTitle del almacenamiento local
  final localStorageRepository = ref.read(localStorageRepositoryProvider);
  final savedTaskCardTitle = await localStorageRepository.getTaskCardTitle();
   final savedProjectNames = await localStorageRepository.getProjectNames();
  final savedContainerIndex = await localStorageRepository.getSelectedContainerIndex();

   // Get saved timeframe data
    final savedWeeklyTimeframes = await localStorageRepository.getWeeklyTimeframes();
    final savedMonthlyTimeframes = await localStorageRepository.getMonthlyTimeframes();
    final savedYearlyTimeframes = await localStorageRepository.getYearlyTimeframes();

    if (errorModel != null && errorModel!.data != null) {
      ref.read(userProvider.notifier).update((state) => errorModel!.data);
    
    
        // Set timer values from user data
    ref.read(pomodoroTimerProvider.notifier).state = errorModel!.data.pomodoroTimer;
    ref.read(shortBreakProvider.notifier).state = errorModel!.data.shortBreakTimer;
    ref.read(longBreakProvider.notifier).state = errorModel!.data.longBreakTimer;
    ref.read(longBreakIntervalProvider.notifier).state = errorModel!.data.longBreakInterval;
      ref.read(selectedSoundProvider.notifier).updateSoundFromPath(errorModel!.data.selectedSound);
   // Set browser notifications state
      ref.read(browserNotificationsProvider.notifier).set(errorModel!.data.browserNotificationsEnabled);
    
    ref.read(darkPomodoroColorProvider.notifier).state = Color(int.parse(errorModel!.data.pomodoroColor.substring(1), radix: 16));
    ref.read(darkShortBreakColorProvider.notifier).state = Color(int.parse(errorModel!.data.shortBreakColor.substring(1), radix: 16));
    ref.read(darkLongBreakColorProvider.notifier).state = Color(int.parse(errorModel!.data.longBreakColor.substring(1), radix: 16));
    ref.read(pomodoroNotifierProvider.notifier).state = PomodoroState(errorModel!.data.pomodoroStates);
      // ref.read(pomodoroNotifierProvider.notifier).updateStates(errorModel!.data.pomodoroStates);
   // Cargar el estado del toggle desde los datos del usuario
    ref.read(toDoHappySadToggleProvider.notifier).set(errorModel!.data.toDoHappySadToggle);
   ref.read(taskDeletionsProvider.notifier).set(errorModel!.data.taskDeletionByTrashIcon);

        
    
    ref.read(taskDeletionsProvider.notifier).set(errorModel!.data.taskDeletionByTrashIcon);
   //add taskCardTitle
    ref.read(taskCardTitleProvider.notifier).state = errorModel!.data.taskCardTitle;

  final taskCardTitle = errorModel!.data.taskCardTitle.isNotEmpty 
        ? errorModel!.data.taskCardTitle 
        : savedTaskCardTitle;


    ref.read(taskCardTitleProvider.notifier).updateTitle(taskCardTitle);
     localStorageRepository.setTaskCardTitle(taskCardTitle);


      // Handle project names
    final projectNames = errorModel!.data.projectName.isNotEmpty 
        ? errorModel!.data.projectName 
        : savedProjectNames;
    
    ref.read(projectStateNotifierProvider.notifier).state = projectNames;
    localStorageRepository.saveProjectNames(projectNames);


// ref.read(selectedProyectContainerProvider.notifier).state = errorModel!.data.selectedContainerIndex;


  // Set the container index
    final containerIndex = errorModel!.data.selectedContainerIndex;
    ref.read(persistentContainerIndexProvider.notifier).updateIndex(containerIndex);
  



      // Initialize timeframe data in the provider
      final projectTimesNotifier = ref.read(projectTimesProvider.notifier);
      
      // Process timeframes from server or use saved data as fallback
      final weeklyTimeframes = errorModel!.data.weeklyTimeframes.isNotEmpty
          ? errorModel!.data.weeklyTimeframes
          : savedWeeklyTimeframes;
      final monthlyTimeframes = errorModel!.data.monthlyTimeframes.isNotEmpty
          ? errorModel!.data.monthlyTimeframes
          : savedMonthlyTimeframes;
      final yearlyTimeframes = errorModel!.data.yearlyTimeframes.isNotEmpty
          ? errorModel!.data.yearlyTimeframes
          : savedYearlyTimeframes;

      // Update local storage with timeframe data
      localStorageRepository.setWeeklyTimeframes(weeklyTimeframes);
      localStorageRepository.setMonthlyTimeframes(monthlyTimeframes);
      localStorageRepository.setYearlyTimeframes(yearlyTimeframes);

      // Initialize provider state with timeframe data
      for (var timeframe in weeklyTimeframes) {
        projectTimesNotifier.addTimeToState(
          timeframe.projectIndex,
          timeframe.date,
          Duration(seconds: timeframe.duration),
          //? its divided by 2 to get the correct duration if i 
          //? delete the Clear timeframe data function the time is 
          //? updated 2 times when i restart the app
        //  Duration(seconds: (timeframe.duration / 2)
        //  .round()
        //  ), // Divide duration by 2 and round to nearest second

        );
      }



    }
   else {
    // Set default values if no user data is found
    ref.read(pomodoroTimerProvider.notifier).state = 25;
    ref.read(shortBreakProvider.notifier).state = 5;
    ref.read(longBreakProvider.notifier).state = 15;
    ref.read(longBreakIntervalProvider.notifier).state = 4;
  
    ref.read(selectedSoundProvider.notifier).updateSoundFromPath('assets/sounds/Flashpoint.wav');
    ref.read(browserNotificationsProvider.notifier).set(false);
    ref.read(darkPomodoroColorProvider.notifier).state = const Color(0xff74F143);
    ref.read(darkShortBreakColorProvider.notifier).state = const Color(0xffff9933);
    ref.read(darkLongBreakColorProvider.notifier).state = const Color(0xff0891FF);
        ref.read(pomodoroNotifierProvider.notifier).state = PomodoroState([]);
    // ref.read(pomodoroNotifierProvider.notifier).updateStates([]);
     ref.read(toDoHappySadToggleProvider.notifier).set(false);

      ref.read(taskDeletionsProvider.notifier).set(false);
      ref.read(taskCardTitleProvider.notifier).updateTitle(savedTaskCardTitle);

   
 const defaultProjects = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];
   ref.read(projectStateNotifierProvider.notifier).state = defaultProjects;
   localStorageRepository.saveProjectNames(defaultProjects);
    ref.read(persistentContainerIndexProvider.notifier).updateIndex(savedContainerIndex);
    }
    // ref.read(selectedProyectContainerProvider.notifier).state =0;
  
  //? i delete clear timeframe data function because 
  //? if i restart the app i cant see the timeframes from the previous week
  
    // Clear timeframe data
      // ref.read(projectTimesProvider.notifier).state = {};
      // localStorageRepository.setWeeklyTimeframes([]);
      // localStorageRepository.setMonthlyTimeframes([]);
      // localStorageRepository.setYearlyTimeframes([]);
  }




  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(timerInitProvider);
    ref.watch(soundInitProvider);
    ref.watch(colorInitProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer 2025.',

      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: ref.watch(themeModeProvider),
      routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
        final user = ref.watch(userProvider);

        if (user != null && user.token.isNotEmpty) {
          return loggedInRoute;
        }
        return loggedOutRoute;
      }),
      routeInformationParser: const RoutemasterParser(),
    );
  }
}
