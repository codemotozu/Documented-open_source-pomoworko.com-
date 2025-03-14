import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

import 'privacy.dart';

class ChipsBlog extends ConsumerWidget {
  const ChipsBlog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ScrollController horizontal = ScrollController();

    return SingleChildScrollView(
      controller: horizontal,
      scrollDirection: Axis.horizontal,
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: const Color.fromARGB(255, 0, 0, 0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 23,
                  right: 18,
                  bottom: 0,
                  top: 10,
                ),
                child: Tooltip(
                  message: 'Privacy Policy',
                  child: ActionChip(
                    avatar: const Icon(
                      Icons.shield_outlined,
                      color: Color(0xffF2F2F2),
                      size: 15,
                    ),
                    backgroundColor: const Color(0xFF121212),
                    onPressed: () {
                      Routemaster.of(context)
                          .push('/privacy-policy');
                    },
                  

                    label: Text(
                      'Privacy Policy',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 18,
                  bottom: 0,
                  top: 10,
                ),
                child: Tooltip(
                  message: 'Terms and Conditions',
                  child: ActionChip(
                    avatar: const Icon(
                      CupertinoIcons.doc_text,
                      color: Color(0xffF2F2F2),
                      size: 15,
                    ),
                    backgroundColor: const Color(0xFF121212),
                    onPressed: () {
                      Routemaster.of(context)
                          .push('/terms-and-conditions');
                    },
                    label: Text(
                      'Terms and Conditions',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 18,
                  bottom: 0,
                  top: 10,
                ),
                child: Tooltip(
                  message: 'Pomodoro technique',
                  child: ActionChip(
                    avatar: const Icon(
                      CupertinoIcons.hourglass,
                      color: Color(0xffF2F2F2),
                      size: 15,
                    ),
                    backgroundColor: const Color(0xFF121212),
                    onPressed: () {
                      Routemaster.of(context)
                          .push('/learn/the-pomodoro-technique/method');
                    },
                    label: Text(
                      'Pomodoro technique',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 18,
                  bottom: 0,
                  top: 10,
                ),
                child: Tooltip(
                  message: 'Avoid distractions',
                  child: ActionChip(
                    avatar: const Icon(
                      CupertinoIcons.hand_raised,
                      color: Color(0xffF2F2F2),
                      size: 15,
                    ),
                    backgroundColor: const Color(0xFF121212),
                    onPressed: () {
                      Routemaster.of(context)
                          .push('/learn/productivity-hacks/avoid-distractions');
                    },
                    label: Text(
                      'Avoid distractions',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 0,
                  right: 18,
                  bottom: 0,
                  top: 10,
                ),
                child: Tooltip(
                  message: 'Productivity hacks',
                  child: ActionChip(
                    avatar: const Icon(
                      Icons.insights_outlined,
                      color: Color(0xffF2F2F2),
                      size: 15,
                    ),
                    backgroundColor: const Color(0xFF121212),
                    onPressed: () {
                      Routemaster.of(context)
                          .push('/learn/productivity-hacks/techniques');
                    },
                    label: Text(
                      'Productivity hacks',
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 15.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
