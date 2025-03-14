
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../common/widgets/domain/entities/sound_entity.dart';

class AlarmSoundPopupMenuButton extends ConsumerStatefulWidget {
  final List<Sound> sounds;
  final String currentSound;
  final Function(Sound) onSoundSelected;

  const AlarmSoundPopupMenuButton({
    required this.sounds,
    required this.currentSound,
    required this.onSoundSelected,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AlarmSoundPopupMenuButtonState();
}

class _AlarmSoundPopupMenuButtonState
    extends ConsumerState<AlarmSoundPopupMenuButton> {
  @override
  Widget build(BuildContext context) {
   
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      child: Theme(
        data: Theme.of(context).copyWith(
            splashFactory: NoSplash.splashFactory,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent),
        child: PopupMenuButton<Sound>(
          color: const Color(0xff1c1b1f),
          tooltip: null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onSelected: (sound) {
            widget.onSoundSelected(sound);
          },
          itemBuilder: (BuildContext context) => widget.sounds
              .map((sound) => PopupMenuItem<Sound>(
                    value: sound,
                    child: Text(sound.friendlyName),
                  ))
              .toList(),
          child: SizedBox(
            width: 165,
            child: Material(
              type: MaterialType.transparency,
              elevation: 2,
              borderRadius: BorderRadius.circular(14.0),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xff1c1b1f),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.transparent),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    widget.currentSound,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: const Color(0xffF2F2F2),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


