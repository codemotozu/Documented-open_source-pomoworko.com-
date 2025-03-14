import 'dart:convert';
import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../../common/widgets/domain/entities/sound_entity.dart';
import '../../common/widgets/domain/entities/todo_entity.dart';
import '../../constants.dart';
import '../../models/error_model.dart';
import '../../models/timeframe_entry.dart';
import '../../models/user_model.dart';
import '../notifiers/persistent_container_notifier.dart';
import '../notifiers/pomodoro_notifier.dart';
import '../notifiers/project_state_notifier.dart';
import '../notifiers/project_time_notifier.dart';
import '../notifiers/providers.dart';
import '../notifiers/task_notifier.dart';
import 'local_storage_repository.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    googleSignIn: GoogleSignIn(),
    client: Client(),
    localStorageRepository: LocalStorageRepository(),
  ),
);

final userProvider = StateProvider<UserModel?>((ref) => null);

class AuthRepository {
  final GoogleSignIn _googleSignIn;
  final Client _client;
  final LocalStorageRepository _localStorageRepository;
  AuthRepository({
    required GoogleSignIn googleSignIn,
    required Client client,
    required LocalStorageRepository localStorageRepository,
  })  : _googleSignIn = googleSignIn,
        _client = client,
        _localStorageRepository = localStorageRepository;

  Future<ErrorModel> signInWithGoogle(WidgetRef ref) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
      
           final savedTaskCardTitle = await _localStorageRepository.getTaskCardTitle();
         final savedWeeklyTimeframes = await _localStorageRepository.getWeeklyTimeframes();
        final savedMonthlyTimeframes = await _localStorageRepository.getMonthlyTimeframes();
        final savedYearlyTimeframes = await _localStorageRepository.getYearlyTimeframes();
           
        final userAcc = UserModel(
          email: user.email,
          name: user.displayName ?? '',
          profilePic: user.photoUrl ?? '',
          uid: '',
          token: '',
          isPremium: user.email == '' ? false : true,
          subscriptionId: '',
          suscriptionStatusCancelled:
              await _localStorageRepository.getsuscriptionStatusCancelled(),
          subscriptionStatusConfirmed:
              await _localStorageRepository.getsubscriptionStatusConfirmed(),
          subscriptionStatusPending: user.email == '' ? false : true,
          nextBillingTime: null,
          startTimeSubscriptionPayPal: null,
          paypalSubscriptionCancelledAt: null,
          userLocalTimeZone: null,
          pomodoroTimer: 25,
          shortBreakTimer: 5,
          longBreakTimer: 15,
          longBreakInterval: 4,
          selectedSound: '',
          browserNotificationsEnabled: false,
          pomodoroColor: '',
          shortBreakColor: '',
          longBreakColor: '',
          pomodoroStates: [],
          toDoHappySadToggle: false,
          taskDeletionByTrashIcon: false,
           taskCardTitle: savedTaskCardTitle,
           projectName: [],
          selectedContainerIndex: 0,
            weeklyTimeframes: savedWeeklyTimeframes,
          monthlyTimeframes: savedMonthlyTimeframes,
          yearlyTimeframes: savedYearlyTimeframes,

        );
        print(
            "isPremium  from auth_repository.dart : ${user.email == '' ? false : true}");

        var res = await _client.post(Uri.parse('$host/auth/api/signup'),
            body: userAcc.toJson(),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
// 'x-auth-token': userAcc.token,
            });

        switch (res.statusCode) {
          case 200:
            final newUser = userAcc.copyWith(
              uid: jsonDecode(res.body)['user']['_id'],
              token: jsonDecode(res.body)['token'],
              isPremium: jsonDecode(res.body)['user']['isPremium'],
              suscriptionStatusCancelled: jsonDecode(res.body)['user']
                  ['suscriptionStatusCancelled'],
              subscriptionStatusConfirmed: jsonDecode(res.body)['user']
                  ['subscriptionStatusConfirmed'],
              pomodoroTimer: jsonDecode(res.body)['user']['pomodoroTimer'],
              shortBreakTimer: jsonDecode(res.body)['user']['shortBreakTimer'],
              longBreakTimer: jsonDecode(res.body)['user']['longBreakTimer'],
              longBreakInterval: jsonDecode(res.body)['user']
                  ['longBreakInterval'],
              selectedSound: jsonDecode(res.body)['user']['selectedSound'],
              browserNotificationsEnabled: jsonDecode(res.body)['user']
                  ['browserNotificationsEnabled'],
              pomodoroColor: jsonDecode(res.body)['user']['pomodoroColor'],
              shortBreakColor: jsonDecode(res.body)['user']['shortBreakColor'],
              longBreakColor: jsonDecode(res.body)['user']['longBreakColor'],
              pomodoroStates: List<bool>.from(
                  jsonDecode(res.body)['user']['pomodoroStates']),
              toDoHappySadToggle: jsonDecode(res.body)['user']
                  ['toDoHappySadToggle'],
              
              taskDeletionByTrashIcon: jsonDecode(res.body)['user']['taskDeletionByTrashIcon'],

          //  taskCardTitle: jsonDecode(res.body)['user']['taskCardTitle'],
             taskCardTitle: jsonDecode(res.body)['user']['taskCardTitle'] ?? savedTaskCardTitle,
             projectName: List<String>.from(jsonDecode(res.body)['user']['projectName']),
              selectedContainerIndex: jsonDecode(res.body)['user']['selectedContainerIndex'],
              weeklyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['weeklyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedWeeklyTimeframes),
              monthlyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['monthlyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedMonthlyTimeframes),
              yearlyTimeframes: List<TimeframeEntry>.from(
                  jsonDecode(res.body)['user']['yearlyTimeframes']?.map(
                          (x) => TimeframeEntry.fromMap(x)) ??
                      savedYearlyTimeframes),
           
            );
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            _localStorageRepository.setIsPremium(newUser.isPremium);
            _localStorageRepository.setIssuscriptionStatusCancelled(
                newUser.suscriptionStatusCancelled);
            _localStorageRepository.setIsubscriptionStatusConfirmed(
                newUser.subscriptionStatusConfirmed);
            _localStorageRepository.setPomodoroTimer(newUser.pomodoroTimer);
            _localStorageRepository.setShortBreakTimer(newUser.shortBreakTimer);
            _localStorageRepository.setLongBreakTimer(newUser.longBreakTimer);
            _localStorageRepository
                .setLongBreakInterval(newUser.longBreakInterval);
            _localStorageRepository.setSelectedSound(newUser.selectedSound);
            _localStorageRepository.setBrowserNotificationsEnabled(
                newUser.browserNotificationsEnabled);

            _localStorageRepository.setPomodoroColor(newUser.pomodoroColor);
            _localStorageRepository.setShortBreakColor(newUser.shortBreakColor);
            _localStorageRepository.setLongBreakColor(newUser.longBreakColor);
            _localStorageRepository.setPomodoroStates(newUser.pomodoroStates);

            _localStorageRepository.setToDoHappySadToggle(newUser.toDoHappySadToggle);
//todo update with local_storge
//add task
            _localStorageRepository.setTaskDeletionByTrashIcon(newUser.taskDeletionByTrashIcon);   
         
          _localStorageRepository.setTaskCardTitle(newUser.taskCardTitle);
            _localStorageRepository.saveProjectNames(newUser.projectName);
            _localStorageRepository.setSelectedContainerIndex(newUser.selectedContainerIndex);

 _localStorageRepository.setWeeklyTimeframes(newUser.weeklyTimeframes);
            _localStorageRepository.setMonthlyTimeframes(newUser.monthlyTimeframes);
            _localStorageRepository.setYearlyTimeframes(newUser.yearlyTimeframes);
         
            ref.read(pomodoroTimerProvider.notifier).state =
                newUser.pomodoroTimer;
            ref.read(shortBreakProvider.notifier).state =
                newUser.shortBreakTimer;
            ref.read(longBreakProvider.notifier).state = newUser.longBreakTimer;
            ref.read(longBreakIntervalProvider.notifier).state =
                newUser.longBreakInterval;
            ref.read(selectedSoundProvider.notifier).updateSound(ref
                .read(soundListProvider)
                .firstWhere((sound) => sound.path == newUser.selectedSound));
            ref
                .read(browserNotificationsProvider.notifier)
                .set(newUser.browserNotificationsEnabled);

            ref.read(darkPomodoroColorProvider.notifier).state =
                Color(int.parse(newUser.pomodoroColor.substring(1), radix: 16));
            ref.read(darkShortBreakColorProvider.notifier).state = Color(
                int.parse(newUser.shortBreakColor.substring(1), radix: 16));
            ref.read(darkLongBreakColorProvider.notifier).state = Color(
                int.parse(newUser.longBreakColor.substring(1), radix: 16));
            ref.read(pomodoroNotifierProvider.notifier).state =
                PomodoroState(newUser.pomodoroStates);

            ref.read(toDoHappySadToggleProvider.notifier).set(newUser.toDoHappySadToggle);
        //add the provider
            ref.read(taskDeletionsProvider.notifier).set(newUser.taskDeletionByTrashIcon);
            ref.read(taskCardTitleProvider.notifier).updateTitle(newUser.taskCardTitle);
         
           ref.read(projectStateNotifierProvider.notifier).state = newUser.projectName;
            ref.read(persistentContainerIndexProvider.notifier).state = newUser.selectedContainerIndex;

   // Initialize the project times provider with timeframe data
            final projectTimesNotifier = ref.read(projectTimesProvider.notifier);
            
            // Process weekly timeframes
            for (var timeframe in newUser.weeklyTimeframes) {
              projectTimesNotifier.addTimeToState(
                timeframe.projectIndex,
                timeframe.date,
                Duration(seconds: timeframe.duration),
              );
            }

            // Process monthly timeframes (if you want to track these in the provider)
            for (var timeframe in newUser.monthlyTimeframes) {
              projectTimesNotifier.addTimeToState(
                timeframe.projectIndex,
                timeframe.date,
                Duration(seconds: timeframe.duration),
              );
            }

            // Process yearly timeframes (if you want to track these in the provider)
            for (var timeframe in newUser.yearlyTimeframes) {
              projectTimesNotifier.addTimeToState(
                timeframe.projectIndex,
                timeframe.date,
                Duration(seconds: timeframe.duration),
              );
            }

            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            // ... (resto del código de guardado)

            // Crear una tarea vacía si es la primera vez que el usuario inicia sesión
           await updateCardTodoTask(
            newUser.toDoHappySadToggle,
            newUser.taskDeletionByTrashIcon,
            newUser.taskCardTitle,
          );


      // Check if the user has previously deleted the task card
      if (!newUser.taskDeletionByTrashIcon) {
        // Only create a new task if the user hasn't deleted it before
        var todo = Todo(
          title: newUser.taskCardTitle ?? '', // Usar el título guardado
          description: "",
          isEditable: false,
        );
        ref.read(taskListProvider.notifier).addTask(todo);
        
        // Update the server state
        await updateCardTodoTask(
          newUser.toDoHappySadToggle,
          false,
          newUser.taskCardTitle,
        );
      }

      if (newUser.taskCardTitle?.isNotEmpty == true) {
    ref.read(taskCardTitleProvider.notifier).updateTitle(newUser.taskCardTitle!);
     _localStorageRepository.setTaskCardTitle(newUser.taskCardTitle!);
  }


    // Update task and project state
    if (newUser.projectName.isEmpty) {
      const defaultProjects = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];
      ref.read(projectStateNotifierProvider.notifier).state = defaultProjects;
      _localStorageRepository.saveProjectNames(defaultProjects);
      _localStorageRepository.setSelectedContainerIndex(0);
    }

            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }





  Future<ErrorModel> getUserData() async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(Uri.parse('$host/auth'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });
        switch (res.statusCode) {
          case 200:
            var newUser = UserModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)['user'],
              ),
            ).copyWith(token: token);


     error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
          
            final confirmStatusResult =
                await fetchSubscriptionStatusConfirmed();
            if (confirmStatusResult.error == null) {
              newUser = newUser.copyWith(
                subscriptionStatusConfirmed: confirmStatusResult.data as bool,
              );
            }
            final cancelledStatusResult =
                await fetchSubscriptionStatusCancelled();
            if (cancelledStatusResult.error == null) {
              newUser = newUser.copyWith(
                suscriptionStatusCancelled: cancelledStatusResult.data as bool,
              );
            }
//? UTC FEATURES
            var nextBillingResult = await fetchNextBillingDate();
            if (nextBillingResult.error == null) {
              newUser = newUser.copyWith(
                  nextBillingTime:
                      DateTime.parse(nextBillingResult.data).toUtc());
            }

//? UTC FEATURES
            var startTimeSubscriptionPaypalResult =
                await fetchstartTimeSubscriptionPayPal();
            if (startTimeSubscriptionPaypalResult.error == null) {
              newUser = newUser.copyWith(
                  startTimeSubscriptionPayPal:
                      DateTime.parse(startTimeSubscriptionPaypalResult.data)
                          .toUtc());
            }
            var paypalSubscriptionCancelledAtResult =
                await fetchpaypalSubscriptionCancelledAt();
            if (paypalSubscriptionCancelledAtResult.error == null) {
              newUser = newUser.copyWith(
                  paypalSubscriptionCancelledAt:
                      DateTime.parse(paypalSubscriptionCancelledAtResult.data)
                          .toUtc());
            }
            error = ErrorModel(error: null, data: newUser);
            _localStorageRepository.setToken(newUser.token);
            _localStorageRepository.setIssuscriptionStatusCancelled(
                newUser.suscriptionStatusCancelled);
            _localStorageRepository.setIsubscriptionStatusConfirmed(
                newUser.subscriptionStatusConfirmed);

      
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> updateUserSettings(
    int pomodoroTimer,
    int shortBreakTimer,
    int longBreakTimer,
    int longBreakInterval,
    Sound selectedSound,
    bool browserNotificationsEnabled,
    Color pomodoroColor,
    Color shortBreakColor,
    Color longBreakColor,
  ) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.post(
          Uri.parse('$host/auth/update-settings'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'pomodoroTimer': pomodoroTimer,
            'shortBreakTimer': shortBreakTimer,
            'longBreakTimer': longBreakTimer,
            'longBreakInterval': longBreakInterval,
            'selectedSound': selectedSound.path,
            'browserNotificationsEnabled': browserNotificationsEnabled,
            'pomodoroColor':
                '#${pomodoroColor.value.toRadixString(16).padLeft(8, '0')}',
            'shortBreakColor':
                '#${shortBreakColor.value.toRadixString(16).padLeft(8, '0')}',
            'longBreakColor':
                '#${longBreakColor.value.toRadixString(16).padLeft(8, '0')}',
          }),
        );
        switch (res.statusCode) {
          case 200:
            error = ErrorModel(error: null, data: res.body);

            break;
          default:
            error = ErrorModel(error: res.body, data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }



  Future<ErrorModel> updatePomodoroStates(List<bool> pomodoroStates) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.post(
          Uri.parse('$host/auth/update-pomodoro-states'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'pomodoroStates': pomodoroStates,
          }),
        );
        switch (res.statusCode) {
          case 200:
            error = ErrorModel(
                error: null, data: jsonDecode(res.body)['pomodoroStates']);
            break;
          default:
            error = ErrorModel(error: res.body, data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> updateCardTodoTask(
    bool toDoHappySadToggle,
    bool taskDeletionByTrashIcon,
     String taskCardTitle,
  ) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.post(
          Uri.parse('$host/auth/card-add-todo-task'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'toDoHappySadToggle': toDoHappySadToggle,
            'taskDeletionByTrashIcon': taskDeletionByTrashIcon,
            'taskCardTitle': taskCardTitle,
          }),
        );
        switch (res.statusCode) {
          case 200:
            error = ErrorModel(
                error: null, 
                   data: {
                'toDoHappySadToggle': jsonDecode(res.body)['toDoHappySadToggle'],
                'taskDeletionByTrashIcon': jsonDecode(res.body)['taskDeletionByTrashIcon'],
                'taskCardTitle': jsonDecode(res.body)['taskCardTitle'],
              });
          default:
            error = ErrorModel(error: res.body, data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

Future<ErrorModel> updateProjectName(String projectName, int index) async {
  ErrorModel error = ErrorModel(
    error: 'Some unexpected error occurred.',
    data: null,
  );
  try {
    String? token = await _localStorageRepository.getToken();
    if (token != null) {
      var res = await _client.post(
        Uri.parse('$host/auth/update-project'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'projectName': projectName,
          'index': index,
        }),
      );
      
      if (res.statusCode == 200) {
        error = ErrorModel(error: null, data: jsonDecode(res.body)['projectName']);
      }
    
    }
  } catch (e) {
    error = ErrorModel(error: e.toString(), data: null);
  }
  return error;
}



  Future<ErrorModel> updateUserContainerIndex(
    int selectedContainerIndex,
  ) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.post(
          Uri.parse('$host/auth/update-container-index'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'selectedContainerIndex':
                selectedContainerIndex,
            
          }),
        );
        switch (res.statusCode) {
          case 200:
            error = ErrorModel(error: null, data: res.body);

            break;
          default:
            error = ErrorModel(error: res.body, data: null);
            break;
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

// En auth_repository.dart

Future<ErrorModel> deleteProject(int projectIndex) async {
  ErrorModel error = ErrorModel(
    error: 'Some unexpected error occurred.',
    data: null,
  );
  
  try {
    String? token = await _localStorageRepository.getToken();
    
    if (token != null) {
      var res = await _client.post(
        Uri.parse('$host/auth/delete-project'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({
          'projectIndex': projectIndex,
        }),
      );
      
      if (res.statusCode == 200) {
        // Limpiar datos locales
        await _localStorageRepository.clearProjectTimeframes(projectIndex);
        error = ErrorModel(error: null, data: jsonDecode(res.body));
      } else {
        error = ErrorModel(error: res.body, data: null);
      }
    }
  } catch (e) {
    error = ErrorModel(error: e.toString(), data: null);
  }
  return error;
}
  void signOut(WidgetRef ref) async {
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res =
            await _client.post(Uri.parse('$host/auth/api/logout'), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        });

        if (res.statusCode == 200) {
          await _googleSignIn.signOut();
          _localStorageRepository.setToken('');

          ref.read(pomodoroTimerProvider.notifier).state = 25;
          ref.read(shortBreakProvider.notifier).state = 5;
          ref.read(longBreakProvider.notifier).state = 15;
          ref.read(longBreakIntervalProvider.notifier).state = 4;
          ref.read(selectedSoundProvider.notifier).updateSound(ref
              .read(soundListProvider)
              .firstWhere(
                  (sound) => sound.path == 'assets/sounds/Flashpoint.wav'));

          ref.read(browserNotificationsProvider.notifier).set(false);

          ref.read(darkPomodoroColorProvider.notifier).state =
              const Color(0xFF74F143);
          ref.read(darkShortBreakColorProvider.notifier).state =
              const Color(0xFFFF9933);
          ref.read(darkLongBreakColorProvider.notifier).state =
              const Color(0xFF0891FF);
          // Reiniciar los estados de pomodoro
          _localStorageRepository.setPomodoroStates([]);
          ref.read(pomodoroNotifierProvider.notifier).resetPomodoros();

          ref.read(toDoHappySadToggleProvider.notifier).set(false);


          ref.read(taskDeletionsProvider.notifier).set(false);
      
             // Limpiar taskCardTitle
          ref.read(taskCardTitleProvider.notifier).reset(); // Cambiamos updateTitle('') por reset()
           _localStorageRepository.setTaskCardTitle(''); // Limpiar en localStorage también
          

        ref.read(taskListProvider.notifier).clearTasks();

                // Reset project names to default
        ref.read(projectStateNotifierProvider.notifier).state = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];
        //  _localStorageRepository.saveProjectNames(['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']);
 ref.read(persistentContainerIndexProvider.notifier);
       
       // Reset local storage
      //   _localStorageRepository.saveProjectNames(
      //    ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']
      //  );
      //  await _localStorageRepository.setSelectedContainerIndex(0);
            
            
               //! OPEN NEW CODE 3/12/24 
          List<String> defaultProjectList = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];

          ref.read(projectStateNotifierProvider.notifier).state = defaultProjectList;
          ref.read(persistentContainerIndexProvider.notifier).state = 0;
            _localStorageRepository.saveProjectNames(defaultProjectList);


          // Clear all timeframe data from local storage
           _localStorageRepository.setWeeklyTimeframes([]);
           _localStorageRepository.setMonthlyTimeframes([]);
           _localStorageRepository.setYearlyTimeframes([]);

          // Reset the project times provider state
          ref.read(projectTimesProvider.notifier).resetState();

             //! CLOSE NEW CODE 3/12/24 

             
        }
      }
    } catch (error) {
      print("the error  from signOut is $error");
    }
  }



  Future<ErrorModel> addTimeframeData({
    required int projectIndex,
    required DateTime date,
    required int duration,
    required String timeframeType,
  }) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.post(
          Uri.parse('$host/auth/api/timeframe/add'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
          body: jsonEncode({
            'projectIndex': projectIndex,
            'date': date.toIso8601String(),
            'duration': duration,
            'timeframeType': timeframeType,
          }),
        );
        
        if (res.statusCode == 200) {
          error = ErrorModel(error: null, data: jsonDecode(res.body));
        } else {
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }

  Future<ErrorModel> getTimeframeData(String timeframeType) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();

      if (token != null) {
        var res = await _client.get(
          Uri.parse('$host/auth/api/timeframe/$timeframeType'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );
        
        if (res.statusCode == 200) {
          error = ErrorModel(error: null, data: jsonDecode(res.body));
        } else {
          error = ErrorModel(error: jsonDecode(res.body)['error'], data: null);
        }
      }
    } catch (e) {
      error = ErrorModel(error: e.toString(), data: null);
    }
    return error;
  }



  Future<ErrorModel> deletePremiumOrNotPremiumUser(WidgetRef ref) async {
    ErrorModel error = ErrorModel(
      error: 'Some unexpected error occurred.deletePremiumOrNotPremiumUser',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token != null) {
        var res = await _client.delete(
            Uri.parse('$host/auth/api/delete-premium-or-not-premium-user'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token,
            });
        if (res.statusCode == 200) {
          error = ErrorModel(error: null, data: "Account deleted successfully");
          ref.read(pomodoroTimerProvider.notifier).state = 25;
          ref.read(shortBreakProvider.notifier).state = 5;
          ref.read(longBreakProvider.notifier).state = 15;
          ref.read(longBreakIntervalProvider.notifier).state = 4;
          ref.read(selectedSoundProvider.notifier).updateSound(ref
              .read(soundListProvider)
              .firstWhere(
                  (sound) => sound.path == 'assets/sounds/Flashpoint.wav'));

          ref.read(browserNotificationsProvider.notifier).set(false);

          ref.read(darkPomodoroColorProvider.notifier).state =
              const Color(0xFF74F143);
          ref.read(darkShortBreakColorProvider.notifier).state =
              const Color(0xFFFF9933);
          ref.read(darkLongBreakColorProvider.notifier).state =
              const Color(0xFF0891FF);
          // Reiniciar los estados de pomodoro
          _localStorageRepository.setPomodoroStates([]);
          ref.read(pomodoroNotifierProvider.notifier).resetPomodoros();
          ref.read(toDoHappySadToggleProvider.notifier).set(false);

          ref.read(taskDeletionsProvider.notifier).set(false);
                ref.read(taskCardTitleProvider.notifier).updateTitle('');


    // Limpiar taskCardTitle
          ref.read(taskCardTitleProvider.notifier).reset(); // Cambiamos updateTitle('') por reset()
           _localStorageRepository.setTaskCardTitle(''); // Limpiar en localStorage también
          
        ref.read(projectStateNotifierProvider.notifier).state = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];

          ref.read(persistentContainerIndexProvider.notifier);
          
          ref.read(taskListProvider.notifier).clearTasks();



      //! OPEN NEW CODE 3/12/24 

          List<String> defaultProjectList = ['Add a project ', 'Add a project ', 'Add a project ', 'Add a project '];

               ref.read(projectStateNotifierProvider.notifier).state = defaultProjectList;
          ref.read(persistentContainerIndexProvider.notifier).state = 0;
           _localStorageRepository.saveProjectNames(defaultProjectList);


          // Clear all timeframe data from local storage
           _localStorageRepository.setWeeklyTimeframes([]);
           _localStorageRepository.setMonthlyTimeframes([]);
           _localStorageRepository.setYearlyTimeframes([]);

          // Reset the project times provider state
          ref.read(projectTimesProvider.notifier).resetState();
       //! CLOSE NEW CODE 3/12/24   

       
          signOut(ref); // Sign out after account deletion
        } else {
          error = ErrorModel(
              error:
                  "deletePremiumOrNotPremiumUser Failed to delete account $error deletePremiumOrNotPremiumUser",
              data: null);
        }
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
      print("the error is $error");
    }
    return error;
  }










  Future<ErrorModel> fetchNextBillingDate() async {
    ErrorModel error = ErrorModel(
      error: 'An unexpected error occurred. deletePremiumOrNotPremiumUser',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token == null) {
        throw Exception(
            "Authentication token not found (deletePremiumOrNotPremiumUser)");
      }

      final response = await _client.post(
        Uri.parse('$host/paypal/next-billing'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
//? no timezones
// final data = jsonDecode(response.body);
// return data['nextBillingTime'];

//?timezones
        final data = jsonDecode(response.body);
        final nextBillingTime = DateTime.parse(data['nextBillingTime']).toUtc();
        return ErrorModel(error: null, data: nextBillingTime);
//? ich haben testieren dast
      } else {
        error = ErrorModel(
          error: "Failed to load next billing date",
          data: null,
        );
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> fetchstartTimeSubscriptionPayPal() async {
    ErrorModel error = ErrorModel(
      error: 'An unexpected error occurred. fetchNextBillingDate',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token == null) {
        throw Exception(
            "Authentication token not found (fetchNextBillingDate)");
      }

      final response = await _client.post(
        Uri.parse('$host/paypal/start-time-subscription'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
//? no timezones

// final data = jsonDecode(response.body);
// return data['startTimeSubscriptionPayPal'];

//?timezones
        final data = jsonDecode(response.body);
        final startTimeSubscriptionPayPal =
            DateTime.parse(data['startTimeSubscriptionPayPal']).toUtc();
        return ErrorModel(error: null, data: startTimeSubscriptionPayPal);

//? i have to tested
      } else {
        error = ErrorModel(
          error: "Failed to load next billing date",
          data: null,
        );
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> cancelSubscription() async {
    final token = await _localStorageRepository.getToken();
    if (token == null) {
      return ErrorModel(
          error: 'Token not found, user not authenticated.', data: null);
    }

    final response = await _client.delete(
      Uri.parse('$host/paypal/cancel-subscription'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      return ErrorModel(error: null, data: data);
    } else {
      return ErrorModel(error: 'Failed to cancel subscription.', data: null);
    }
  }

  Future<ErrorModel> fetchSubscriptionStatusConfirmed() async {
    ErrorModel error = ErrorModel(
      error: 'An unexpected error occurred. fetchSubscriptionStatusConfirmed',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token == null) {
        throw Exception(
            "Authentication token not found (fetchSubscriptionStatusConfirmed)");
      }

      final response = await _client.post(
        Uri.parse('$host/paypal/update-subscription-status-confirmed'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
//  final data = jsonDecode(response.body);
// final confirmedValue = data['subscriptionStatusConfirmed'] ?? false;
// return ErrorModel(error: null, data: confirmedValue);

        const subscriptionStatusConfirmed = true;
        return ErrorModel(error: null, data: subscriptionStatusConfirmed);
// //? ich haben testieren dast
      } else {
        error = ErrorModel(
          error: "Failed to load next billing date",
          data: null,
        );
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> fetchSubscriptionStatusCancelled() async {
    ErrorModel error = ErrorModel(
      error: 'An unexpected error occurred. fetchSubscriptionStatusCancelled',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token == null) {
        throw Exception(
            "Authentication token not found (fetchSubscriptionStatusCancelled)");
      }

      final response = await _client.post(
        Uri.parse('$host/paypal/update-subscription-status-cancelled'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
        const suscriptionStatusCancelled = true;
        return ErrorModel(error: null, data: suscriptionStatusCancelled);

// //? ich haben testieren dast
      } else {
        error = ErrorModel(
          error: "Failed to load next billing date",
          data: null,
        );
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }

  Future<ErrorModel> fetchpaypalSubscriptionCancelledAt() async {
    ErrorModel error = ErrorModel(
      error: 'An unexpected error occurred. fetchpaypalSubscriptionCancelledAt',
      data: null,
    );
    try {
      String? token = await _localStorageRepository.getToken();
      if (token == null) {
        throw Exception(
            "Authentication token not found (fetchpaypalSubscriptionCancelledAt)");
      }

      final response = await _client.post(
        Uri.parse('$host/paypal/paypal-subscription-cancelled-at'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
        body: jsonEncode({'token': token}),
      );

      if (response.statusCode == 200) {
//? no timezones

// final data = jsonDecode(response.body);
// return data['startTimeSubscriptionPayPal'];

//?timezones
        final data = jsonDecode(response.body);
        final paypalSubscriptionCancelledAt =
            DateTime.parse(data['paypalSubscriptionCancelledAt']).toUtc();
        return ErrorModel(error: null, data: paypalSubscriptionCancelledAt);

//? i have to tested
      } else {
        error = ErrorModel(
          error: "Failed to load next billing date",
          data: null,
        );
      }
    } catch (e) {
      error = ErrorModel(
        error: e.toString(),
        data: null,
      );
    }
    return error;
  }
}
