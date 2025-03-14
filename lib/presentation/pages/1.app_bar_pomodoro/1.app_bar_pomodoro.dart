import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../notifiers/providers.dart';

class PomodoroLogo extends ConsumerStatefulWidget {
  const PomodoroLogo({super.key});

  @override
  _PomodoroLogoState createState() => _PomodoroLogoState();
}

class _PomodoroLogoState extends ConsumerState<PomodoroLogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      appBar: AppBar(
        backgroundColor: ref.watch(currentColorProvider),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text.rich(
              TextSpan(
                text: ' pomo',
                style: GoogleFonts.nunito(
                  fontSize: 22,
                  color: const Color(0xffF2F2F2),
                  fontWeight: FontWeight.w600,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: 'work',
                    style: GoogleFonts.nunito(
                      fontSize: 22,
                      color: const Color(0xffF2F2F2),
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xffF2F2F2),
                      decorationThickness: 3,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'o.com',
                    style: GoogleFonts.nunito(
                        fontSize: 22,
                        color: const Color(0xffF2F2F2),
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
