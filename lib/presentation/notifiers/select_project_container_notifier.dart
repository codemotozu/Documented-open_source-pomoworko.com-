import 'package:flutter_riverpod/flutter_riverpod.dart';
//* ESTE PROVIDER CAMBIA EL COLOR DEL CONTAINER DEL PROYECTO
class SelectedProjecContainerColortNotifier extends StateNotifier<int> {
  SelectedProjecContainerColortNotifier() : super(0);

  void updateSelectedContainerColorProject(int index) {
    state = index;
  }
}

final selectedProyectContainerProvider = StateNotifierProvider<SelectedProjecContainerColortNotifier, int>((ref) {
  return SelectedProjecContainerColortNotifier();
});
