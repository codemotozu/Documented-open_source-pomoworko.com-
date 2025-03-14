import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/utils/responsive_web.dart';

class ProductivityHacks extends ConsumerStatefulWidget {
  const ProductivityHacks({super.key});

  @override
  _ProductivityHacksState createState() => _ProductivityHacksState();
}

class _ProductivityHacksState extends ConsumerState<ProductivityHacks> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ResponsiveWeb(
        child: Scaffold(
          backgroundColor:const Color.fromARGB(255, 0, 0, 0) ,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: const Color.fromARGB(255, 0, 0, 0),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    'Productivity hacks',
                    style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight:  FontWeight.w600,
                        color: const Color(0xffF2F2F2)),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(23, 24, 23, 24),
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SelectableText(
                        'The Power of Doing Only One Thing ',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight:  FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SelectableText(
                        '''In the modern era, the ability to manage a plethora of tasks simultaneously is often celebrated as a hallmark of efficiency. Society praises those who navigate the complexities of multiple responsibilities, equating such abilities with higher productivity, dedication, and value. Yet, emerging psychological research challenges the very foundation of this belief, revealing that true multitasking is a myth. Our brains are not wired to focus on several tasks at once; rather, they switch between activities swiftly, causing a momentary lapse in concentration with each transition. This constant shifting not only wastes time but prevents us from achieving a deep, immersive state of engagement known as "flow."

The allure of multitasking extends beyond daily tasks, affecting our long-term aspirations. Spreading ourselves too thin across various endeavors means each receives only a fraction of our attention and resources, slowing their progression. Imagine your ambitions as cups and your efforts as water from a single pitcher; distributing water among multiple cups dilutes the impact, leaving none fully satisfied.

Enter the philosophy of singularity in purpose, championed by Gary Keller in his book "The One Thing." Keller advocates for a focused approach to tasks and goals, suggesting that success is a byproduct of concentrated effort rather than scattered attention. This method not only accelerates progress but fosters a state of flow, where distractions fade and productivity soars.

By narrowing our focus to a single task or goal, we can dedicate our full suite of resources to it, achieving significant strides in less time. The metaphorical water pitcher now fills one cup quickly, allowing for sequential, rather than simultaneous, accomplishments.

Keller also introduces the concept of a "Success List," a strategic tool for prioritizing goals based on their potential for extraordinary outcomes. Unlike a traditional to-do list, which can be sprawling and unfocused, a Success List is concise and directed, aligning with our core values and guiding us toward our most impactful objectives.

Incorporating the Pomodoro technique into this framework magnifies its benefits. This method, which breaks work into focused intervals separated by short breaks, aligns perfectly with the principle of singularity in effort. It encourages deep focus on one task at a time, enhancing productivity and satisfaction.

By reshaping our approach to work and life through focused intervals and prioritized goals, we not only improve our efficiency but also our fulfillment. As we harness the power of concentrated effort, facilitated by tools like the Pomodoro technique, we move closer to realizing our ambitions and crafting the life we desire.
                        
                        ''',
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
                      const Divider(
                        thickness: 2,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            'References',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2),
                                fontSize: 24.0,
                                fontWeight: FontWeight
                                    .bold), // Emphasized with bold for the header
                          ),
                          const SizedBox(height: 16),
                          SelectableText(
                            "The Art of Improvement. (2022, April 3). 'The Power of Doing Only One Thing' [Video]. YouTube.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight:
                                  FontWeight.normal, // Maintained readability
                            ),
                          ),
                          InkWell(
                            onTap: () => launchUrl(
                                Uri.parse(
                                    "https://www.youtube.com/watch?v=mMIK5u4xdh8"),
                                mode: LaunchMode.externalApplication),
                            child: Text(
                              "Watch Video",
                              style: GoogleFonts.nunito(
                                color: Colors
                                    .blue, // Standard link color for clarity
                                fontSize: 22.0,
                                decoration: TextDecoration
                                    .underline, // Indicates clickability
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      )
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
