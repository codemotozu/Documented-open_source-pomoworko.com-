import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../common/widgets/domain/entities/todo_entity.dart';
import '../../infrastructure/data_sources/hive_services.dart';
import 'providers.dart';


class TaskList extends StateNotifier<List<Todo>> {
  TaskList(this.ref) : super(<Todo>[]) {
    _initializeList();
  }
  final Ref ref;
  final Map<Todo, double> _taskHeights = {};

  _initializeList() async {
    List<String>? uuidList = await HiveServices.retrieveTodoUUIDList();
    String? focusedUUID = await HiveServices.retrieveFocusedTodoUUID();

    if (uuidList != null && uuidList.isNotEmpty) {
      List<Future<Todo>> futures = uuidList.map((uuid) async {
        String? title = await HiveServices.retrieveTodoTitle(uuid);

        String? description = await HiveServices.retrieveTodoDescription(uuid);
        bool? checkboxState = await HiveServices.retrieveCheckboxState(uuid);

        return Todo(
          title: title ?? "",
          description: description ?? "",
          id: uuid,
          isActive: checkboxState ?? false,
          isFocused: uuid == focusedUUID,
        );
      }).toList();
      state = await Future.wait(futures);
      if (focusedUUID != null) {
        String? focusedTitle =
            await HiveServices.retrieveTodoTitle(focusedUUID);
        ref.read(focusedTaskTitleProvider.notifier).state = focusedTitle ?? '';
      }
    }
  }

   void clearTasks() {
    state = [];
    _taskHeights.clear();
    ref.read(minHeightProvider.notifier).resetHeight();
  }


  static final initialList = <Todo>[];

  void reorderList(List<Todo> reorderedList) {
    state = reorderedList;

    List<String> reorderedUUIDs = reorderedList.map((todo) => todo.id).toList();
    HiveServices.saveTodoUUIDList(reorderedUUIDs);
  }

  void addTask(Todo task) {
    if (state.length >= 1) {
      ref.read(showSnackbarProvider.notifier).show();
    } else {
      double taskHeight;
      if (state.isEmpty) {
        taskHeight = 300.0;
      } else if (state.length == 1) {
        taskHeight = 300.0;
      } else if (state.length == 2) {
        taskHeight = 300.0;
      } else {
        taskHeight = 0.0;
      }
      state = [...state, task];

      List<String> currentUUIDs = state.map((todo) => todo.id).toList();
      HiveServices.saveTodoUUIDList(currentUUIDs);

      HiveServices.saveTodoListLength(state.length);

      _taskHeights[task] = taskHeight;

      ref.read(minHeightProvider.notifier).increaseHeight(taskHeight);
    }
  }

  double calculateTaskHeight(String title, String description) {
    double baseTaskHeight = 0.0;

    return baseTaskHeight;
  }

  void updateTask(Todo originalTask, String newTitle, String newDescription) {
    int index = state.indexOf(originalTask);
    if (index != -1) {
      Todo updatedTask = Todo(
        id: originalTask.id,
        title: newTitle,
        description: newDescription,
      );
      state[index] = updatedTask;
    }
  }

  void removeTask(Todo task) {
    int indexOfRemovedTask = state.indexOf(task);

    if (indexOfRemovedTask == -1) return;

    double taskHeight = _taskHeights[task] ?? 0.0;

    if (indexOfRemovedTask == 0 && state.length == 3) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else if (indexOfRemovedTask == 0 && state.length == 1) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else if (indexOfRemovedTask == 0 && state.length == 2) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else if (indexOfRemovedTask == 1 && state.length == 2) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else if (indexOfRemovedTask == 1 && state.length == 3) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else if (indexOfRemovedTask == 2 && state.length == 3) {
      ref.read(minHeightProvider.notifier).decreaseHeight(300.0);
    } else {
      ref.read(minHeightProvider.notifier).decreaseHeight(taskHeight);
    }

    state = state.where((element) => element != task).toList();
    _taskHeights.remove(task);

    HiveServices.deleteTodoUUID(task.id);

    HiveServices.deleteTodoTitle(task.id);
    HiveServices.deleteTodoDescription(task.id);

    HiveServices.deleteCheckboxState(task.id);

    HiveServices.saveTodoListLength(state.length);

    if (task.isFocused) {
      ref.read(focusedTaskTitleProvider.notifier).state = '';
      HiveServices.saveFocusedTodoUUID(null);
    }
  }
}

final taskListProvider = StateNotifierProvider<TaskList, List<Todo>>((ref) {
  return TaskList(ref);
});


/*
final todoPageHeightProvider = Provider<double>((ref) {
  List<Todo> todos = ref.watch(taskListProvider);
  double minTodoPageHeight = ref.watch(minHeightProvider);
  double todoPageHeight = minTodoPageHeight;

  for (var todo in todos) {
    todoPageHeight += ref
        .read(taskListProvider.notifier)
        .calculateTaskHeight(todo.title, todo.description);
  }

  print("Current MinTodoPageHeight: $minTodoPageHeight");
  print("Current TodoPageHeight: $todoPageHeight");

  return max(todoPageHeight, 0.0);
});

*/

final todoPageHeightProvider = Provider<double>((ref) {
  List<Todo> todos = ref.watch(taskListProvider);
  double minTodoPageHeight = ref.watch(minHeightProvider);
  double todoPageHeight = minTodoPageHeight;

  for (var todo in todos) {
    todoPageHeight += ref
        .read(taskListProvider.notifier)
        .calculateTaskHeight(todo.title, todo.description);
  }

  print("Current MinTodoPageHeight: $minTodoPageHeight");
  print("Current TodoPageHeight: $todoPageHeight");

  return max(todoPageHeight, 0.0);
});

class MinHeight extends StateNotifier<double> {
  double _baseHeight;

  MinHeight()
      : _baseHeight = 0.0,
        super(0.0) {
    _initializeBaseHeight();
  }

  _initializeBaseHeight() async {
    _baseHeight = await HiveServices.retrieveBaseHeight();
    state = _baseHeight;
  }

  void resetHeight() {
    _baseHeight = 0.0;
    state = _baseHeight;
  }

  void increaseHeight(double baseTaskHeight) {
     _baseHeight = 300.0;  // Establecer directamente a 300
    // _baseHeight += baseTaskHeight;
    state = _baseHeight;
    HiveServices.saveBaseHeight(_baseHeight);
  }

  void decreaseHeight(double baseTaskHeight) {
     _baseHeight = 0.0;  // Establecer directamente a 0
    // _baseHeight -= baseTaskHeight;
    state = _baseHeight;
    HiveServices.saveBaseHeight(_baseHeight);
  }
}

final minHeightProvider = StateNotifierProvider<MinHeight, double>((ref) {
  return MinHeight();
});

final showSnackbarProvider = StateNotifierProvider<ShowSnackbar, bool>((ref) {
  return ShowSnackbar();
});

class ShowSnackbar extends StateNotifier<bool> {
  ShowSnackbar() : super(false);

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}