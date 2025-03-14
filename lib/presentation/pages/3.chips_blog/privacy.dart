import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/responsive_web.dart';



class Privacy extends ConsumerStatefulWidget {
  const Privacy({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PrivacyState();
}

class _PrivacyState extends ConsumerState<Privacy> {

  @override
  Widget build(BuildContext context) {
      return SafeArea(
      child: ResponsiveWeb(
        child: Scaffold(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Privacy Policy', 
                      textAlign: TextAlign.center,
                      style: GoogleFonts.nunito(
                        color: const Color(0xffF2F2F2),
                        fontSize: 24.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(23, 20, 23, 20),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            'Pomoworko Privacy Policy',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Effective Date: ',
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffF2F2F2),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600, // Bold style
                                  ),
                                ),
                                TextSpan(
                                  text: 'January 4, 2025',
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffF2F2F2),
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w300, // Normal style
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 24),
                          SelectableText(
                            """
Pomoworko ("us", "we", or "our") operates the https://pomoworko.com website (hereinafter referred to as the "Service").

This Privacy Policy explains how we collect, use, disclose, and protect your information when you use our Service. By using the Service, you agree to the collection and use of information in accordance with this policy.
""",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          SelectableText(
                            '1. Information We Collect',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            "We collect the following types of information:",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
//                           fontWeight:  FontWeight.w300,
//                         ),
//                       ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title: "Personal Information:"
                          SelectableText(
                            'Personal Information:',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600, // Bold
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "     When you log in with Google, we collect:\n",
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffF2F2F2),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300, // Light
                                  ),
                                ),
                                // Bullet point: Name
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Name',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Email address',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Profile picture URL',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title: "Personal Information:"
                          SelectableText(
                            'User Preferences and Settings:',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600, // Bold
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                // Bullet point: Name
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Pomodoro timer durations (e.g., work, short break, and long break durations)',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Selected colors for timers (e.g., Pomodoro color, break colors)',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Notification preferences',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Selected sound files for timers',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Task and project details',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title: "Personal Information:"
                          SelectableText(
                            'Usage Data:',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600, // Bold
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "     We collect data on how you use the Service, including:\n",
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffF2F2F2),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300, // Light
                                  ),
                                ),
                                // Bullet point: Name
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Time zone and local time settings',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Weekly, monthly, and yearly task timeframes',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('          • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'User subscription status and activity logs',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 24,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title: "Personal Information:"
                          SelectableText(
                            'Cookies and Tracking Data:',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600, // Bold
                            ),
                          ),
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      "Cookies and similar tracking technologies are used to store session information and improve user experience.\n",
                                  style: GoogleFonts.nunito(
                                    color: const Color(0xffF2F2F2),
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.w300, // Light
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      SelectableText(
                        '2. How We Use Your Data',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "We use the collected data for:",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Operating and maintaining the Service',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Customizing and improving user experience',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Tracking progress on tasks and time management',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Sending notifications or updates if notifications are enabled',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Analyzing usage trends for service optimization',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24), // Spacing below the title

                      SelectableText(
                        '3. Data Sharing and Disclosure',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "We do not sell or rent your data to third parties. However, we may share your data with:",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • Service Providers: ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Third-party services like Google for authentication purposes.',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • Legal Obligations: ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'If required by law, to comply with legal processes.',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24), // Spacing below the title

                      SelectableText(
                        '4. Data Security',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "We prioritize securing your data with industry-standard practices. However, no method of electronic transmission is 100% secure. While we strive to protect your data, we cannot guarantee absolute security.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(height: 24), // Spacing below the title

                      SelectableText(
                        '5. Your Rights',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "You may:",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8), // Spacing below the title

                          // Description and bullet points
                          SelectableText.rich(
                            TextSpan(
                              children: [
                                // Bullet point: Email address
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Request access to your data',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Request deletion or modification of your data',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Bullet point: Profile picture URL
                                WidgetSpan(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('  • ',
                                          style: TextStyle(
                                              fontSize: 22.0,
                                              color: Color(0xffF2F2F2))),
                                      Expanded(
                                        child: SelectableText(
                                          'Opt out of certain tracking methods',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24), // Spacing below the title

                      SelectableText(
                        "For any inquiries, contact us at: contact.pomoworko@gmail.com",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 22.0,
                          fontWeight: FontWeight.w300,
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}