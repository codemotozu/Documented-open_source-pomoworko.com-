import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/widgets/domain/entities/sound_entity.dart';


class SoundNotifier extends StateNotifier<Sound> {
  SoundNotifier({required Sound initialSound}) : super(initialSound);

  void updateSound(Sound newSound) {
    state = newSound;
  }
}