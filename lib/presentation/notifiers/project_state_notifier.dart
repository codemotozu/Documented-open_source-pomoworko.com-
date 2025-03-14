

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pomoworko/presentation/notifiers/providers.dart';

import '../repository/auth_repository.dart';
import '../repository/local_storage_repository.dart';
import 'persistent_container_notifier.dart';
import 'project_time_notifier.dart';

class ProjectStateNotifier extends StateNotifier<List<String>> {
  final LocalStorageRepository _localStorageRepository;
   final Ref _ref; 
  ProjectStateNotifier(this._localStorageRepository, this._ref) : super(['Add a project ', 'Add a project ', 'Add a project ', 'Add a project ']);

  void selectProject(int index) async {
    if (index >= state.length) {
      state = [...state, ...List.filled(index - state.length + 1, 'Add a project ')];
    }
       // Save selected index
     _localStorageRepository.setSelectedContainerIndex(index);
    print('Current Project Names: $state');
    print('Selected Project Index: $index');
    print('Current Project Name: ${state[index]}');
  }



void addProject(String projectName, int index, WidgetRef ref) async {
  final auth = ref.read(authRepositoryProvider);
  final result = await auth.updateProjectName(projectName, index);
  
  if (result.error == null) {
    List<String> newState;
    if (index >= state.length) {
      newState = [...state, ...List.filled(index - state.length, 'Add a project '), projectName];
    } else {
      newState = [...state];
      newState[index] = projectName;
    }
    state = newState;

     // Save to local storage
       _localStorageRepository.saveProjectNames(newState);
      
      // Update the selected container index
      ref.read(persistentContainerIndexProvider.notifier).updateIndex(index);
  }
}


  void updateProject(int index, String newProjectName) {
    if (index < state.length) {
      final newState = [...state];
      newState[index] = newProjectName;
      state = newState;

       // Save to local storage
       _localStorageRepository.saveProjectNames(newState);
    }
    print('Updated project at index $index: $newProjectName');
    print('Current Project Names: $state');
  }

  // En project_state_notifier.dart
void deleteProject(int index,) async {
  state = List.from(state);
  if (index < state.length) {
    state[index] = 'Add a project ';
    
    // Limpiar los datos del proyecto en el provider de tiempos
    _ref.read(projectTimesProvider.notifier).clearProjectData(index);
   // Guardar en almacenamiento local
     _localStorageRepository.saveProjectNames(state);
  }
}

  String getProject(int index) {
    return index < state.length ? state[index] : 'Add a project ';
  }
}

final projectStateNotifierProvider = StateNotifierProvider<ProjectStateNotifier, List<String>>((ref) {
    final localStorageRepository = ref.read(localStorageRepositoryProvider);
  return ProjectStateNotifier(localStorageRepository, ref);
});

final selectedProjectIndexProvider = StateProvider<int>((ref) => 0);
final currentProjectProvider = StateProvider<String?>((ref) => null);