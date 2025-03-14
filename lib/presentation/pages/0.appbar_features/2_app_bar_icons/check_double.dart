import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CheckDoubleIcon extends ConsumerStatefulWidget {
  const CheckDoubleIcon({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CheckDoubleIconState();
}

class _CheckDoubleIconState extends ConsumerState<CheckDoubleIcon> {

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Semantics(
          label: 'Pomodoro timer',
          enabled: true,
          readOnly: true,
          child:  const Icon(
            FontAwesomeIcons.checkDouble,
            size: 28,
            color: Color(0xffF2F2F2),
          ),
        ),
      ],
    );
  
  }
}