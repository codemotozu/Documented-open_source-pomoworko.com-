import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../infrastructure/data_sources/hive_services.dart';
import '../repository/auth_repository.dart';


class PomodoroNotifier extends StateNotifier<PomodoroState> {
  PomodoroNotifier(this.ref) : super(PomodoroState([])) {
    _loadProgress();
  }

  final Ref ref;

    void updateStates(List<bool> newStates) {
    state = PomodoroState(newStates);
    HiveServices.saveUserProgress(newStates);
  }

  Future<void> _loadProgress() async {
    final user = ref.read(userProvider);
    if (user != null) {
      state = PomodoroState(user.pomodoroStates);
    } else {
      final progress = await HiveServices.retrieveUserProgress();
      state = PomodoroState(progress);
    }
  }

  Future<void> _syncWithBackend() async {
    final result = await ref.read(authRepositoryProvider).updatePomodoroStates(state.pomodoros);
    if (result.error == null) {
      state = PomodoroState(result.data);
    }
  }

  void startNewPomodoro() {
    state = state.copyWith(
      pomodoros: [...state.pomodoros, false],
    );
    HiveServices.saveUserProgress(state.pomodoros);
    _syncWithBackend();
  }

  void finishCurrentPomodoro() {
    if (state.pomodoros.isNotEmpty) {
      state = state.copyWith(
        pomodoros: List.from(state.pomodoros)
          ..[state.pomodoros.length - 1] = true,
      );
      HiveServices.saveUserProgress(state.pomodoros);
      _syncWithBackend();
    }
  }

  void resetPomodoros() {
    state = PomodoroState([]);
    HiveServices.saveUserProgress([]);
    _syncWithBackend();
  }
}


class PomodoroState {
  final List<bool> pomodoros;

  PomodoroState(this.pomodoros);

  PomodoroState copyWith({List<bool>? pomodoros}) {
    return PomodoroState(
      pomodoros ?? this.pomodoros,
    );
  }
}