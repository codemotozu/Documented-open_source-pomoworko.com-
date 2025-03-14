import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/utils/responsive_web.dart';

class TermsAndConditions extends ConsumerStatefulWidget {
  const TermsAndConditions({super.key});

  @override
  _TermsAndConditionsState createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends ConsumerState<TermsAndConditions> {
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
                      'Terms and Conditions', 
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
                            'Pomoworko Terms and Conditions',
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
                                  text: 'Last Updated: ',
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
                            '1. Acceptance of Terms',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            "By accessing or using https://pomoworko.com, you agree to these Terms and Conditions. If you do not agree, do not use the Service.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                      
                     
                        ],
                      ),
                      const SizedBox(
                        height: 24,
                      ),

                      

                      SelectableText(
                        '2. Use of the Service',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
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
                                          'You may use Pomoworko for personal, non-commercial purposes.',
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
                                          'Do not reverse-engineer, decompile, or disassemble any part of the Service.',
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
                                          'Do not use the Service for illegal purposes.',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),  ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24), // Spacing below the title

                      SelectableText(
                        '3. Accounts',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

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
                                          'You may use Pomoworko for personal, non-commercial purposes.',
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
                                          'To use Pomoworko, you must log in via Google. Ensure the accuracy of your account information.',
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
                                          'You are responsible for safeguarding your account credentials.',
                                          style: GoogleFonts.nunito(
                                            color: const Color(0xffF2F2F2),
                                            fontSize: 22.0,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),  ],
                            ),
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24), // Spacing below the title

                          SelectableText(
                            '4. Limitation of Liability',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            """Pomoworko is provided "as-is." We are not liable for damages resulting from the use of the Service, including but not limited to data loss or interruptions.""",
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
                        '5. Changes to Terms',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "We may revise these Terms periodically. Changes will be effective upon posting on this page.",
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
                        '6. Contact Us',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "For questions about these Terms and Conditions, contact us at: contact.pomoworko@gmail.com",
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
     
      /*
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
                      'Terms And Conditions  ',
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
                            """

Pomoworko Terms and Conditions
Last Updated: [Insert Date]

1. Acceptance of Terms
By accessing or using https://pomoworko.com (the "Service"), you agree to these terms and conditions.

2. Use of Service
You may use Pomoworko for personal, non-commercial purposes only.
You agree not to:
Reverse-engineer or disassemble any part of the Service
Use the Service for illegal activities
3. User Responsibilities
Users are responsible for maintaining the confidentiality of their login credentials.
Pomoworko is not liable for any data loss or misuse due to unauthorized access to your account.
4. Subscription and Premium Features
Users with a premium subscription agree to the terms of payment and subscription renewal.
Subscription cancellation or modification must be done through your user account settings.
5. Limitation of Liability
Pomoworko is not liable for:

Loss of data due to system errors or technical issues
Indirect, incidental, or consequential damages from Service use
6. Contact Us
If you have any questions or concerns about these terms, contact us at: [Insert Contact Email]
""",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                      ],
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
    */
    );
  }
}
