import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/utils/responsive_web.dart';

class PomodoroTechnique extends ConsumerStatefulWidget {
  const PomodoroTechnique({super.key});

  @override
  _PomodoroTechniqueState createState() => _PomodoroTechniqueState();
}

class _PomodoroTechniqueState extends ConsumerState<PomodoroTechnique> {
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
                
                  Semantics(
                    header:
                        true, 
                    child: Text(
                      'Mastering the Pomodoro Technique: A Guide', 
                      textAlign: TextAlign
                          .center, 
                      style: GoogleFonts.nunito(
                        color:
                            const Color(0xffF2F2F2),
                        fontSize: 24.0, 
                        fontWeight:
                            FontWeight.w600, 
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
                            'Definition:',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2)
,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            "The Pomodoro Technique is a renowned time management method that involves working for 25 minutes, followed by a 3-5 minute break. This cycle is repeated four times before taking a longer break, optimizing focus and productivity.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2)
,
                              fontSize: 22.0,
                              fontWeight:  FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Center(
                            child: Semantics(
                              label: 'Space rocket launching',
                              hint:
                                  'Illustration of a space rocket launching, symbolizing the start of a focused work session using the Pomodoro Technique.',
                              child: Image.network(
                                'https://images.unsplash.com/photo-1628126235206-5260b9ea6441?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SelectableText(
                            'Step 1: Choose the Task You Need to Work On',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2)
,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          SelectableText(
                            "Begin by selecting a specific task to focus on. Choosing a single task minimizes distractions and discourages multitasking, allowing for deeper concentration and more effective work sessions. Whether it's a long-term goal or an urgent task, prioritizing one activity at a time is key.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2)
,
                              fontSize: 22.0,
                              fontWeight:  FontWeight.w300,
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      SelectableText(
                        'Step 2: Set a timer for 25 minutes',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "You need a timer to tell you when the slot is over. You can use an online stopwatch, your phone alarm, or a physical timer to notify you.\nDon’t worry if the task you’re targeting needs more time. You do not have to complete the entire job in a single slot.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Semantics(
                          label:
                              'Space rocket launching', 
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'Depicts the concept of starting a focused work session with the Pomodoro technique, symbolized by a rocket launch.', // Improved hint for clarity and relevance.
                          child: Image.network(
                            'https://images.unsplash.com/photo-1515272751348-25380c6c1f9c?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      SelectableText(
                        'Step 3: Work on the task until the timer beeps',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Focus intensely on your task for 25 minutes, ensuring complete immersion without succumbing to distractions such as phone calls, texts, or conversations. This dedicated effort is crucial for the Pomodoro technique's success.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SelectableText(
                        'Step 4: Take a short break to refresh',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Celebrate completing a Pomodoro by taking a 3-5 minute break. Engage in relaxing activities like walking or hydrating. Avoid work-related tasks to allow your mind to recover and prepare for the next focused session.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                          child: Semantics(
                        label:
                            'A cat peacefully sleeping on a bed, symbolizing relaxation and rest',
                        enabled: true,
                        readOnly: true,
                        selected: true,
                        hint:
                            'This image represents the importance of taking breaks and relaxing between work sessions, akin to the rest period in the Pomodoro technique.',
                        child: Image.network(
                          'https://images.unsplash.com/photo-1522856339183-9a8b06b05937?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )),
                      const SizedBox(
                        height: 24,
                      ),
                      SelectableText(
                        'Step 5: Complete four Pomodoro cycles',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Maintain the rhythm: 25 minutes of focused work, followed by a brief pause. Each Pomodoro cycle offers a chance to tackle a new challenge or continue with the current task, enhancing productivity and focus.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "After completing four cycles, reward yourself with a 15-30 minute break to refresh and rejuvenate. This longer pause is crucial for sustaining focus and energy over longer periods.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Celebrate your accomplishments! A simple gesture like a fist pump can significantly boost your morale and readiness for the next set of tasks.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Semantics(
                          label: 'Pomodoro Technique Timer Icon',
                          hint:
                              'Represents the concept of repeated intervals or cycles, a core part of the Pomodoro Technique.',
                          child: Container(
                            alignment: Alignment.center,
                            height: 150,
                            width: 150,
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xfff98125)),
                            child: const Icon(
                              FontAwesomeIcons.repeat,
                              color: Color(0xff193a6f),
                              size: 100,
                              semanticLabel:
                                  'Repeat', 
                            ),
                          ),
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

                      SelectableText(
                        'Key Strategie for Mastering the Pomodoro Technique',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "Embarking on the Pomodoro journey? It's tempting to tweak the method initially. However, mastery comes with patience and practice.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SelectableText(
                        '1. Embrace Regular Breaks',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "Each Pomodoro session is followed by a short break. Though it's tempting to power through, taking breaks is crucial for sustained focus and productivity.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 8),

                      SelectableText(
                        "Breaks serve as mental reset points, allowing for information assimilation and preparation for upcoming tasks.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(height: 24),

                      Center(
                        child: Semantics(
                          label: 'Stressed individual at work desk',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'Depicts the consequences of overworking without breaks, highlighting stress, burnout, and the need for structured work sessions like the Pomodoro technique offers.',
                          child: Image.network(
                            'https://images.unsplash.com/photo-1621252179027-94459d278660?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 24,
                      ),
                      const Divider(
                        thickness: 2,
                      ),

                      SelectableText(
                        'Advantages of the Pomodoro Technique',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        '1. Enhances Focus',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "The Pomodoro Technique significantly boosts concentration. Surrounded by potential distractions, it's easy to lose sight of priorities. Focusing on one task at a time streamlines progress towards your most important goals. This method is particularly effective for studying or mastering new skills.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Its effectiveness extends to academic preparation and the acquisition of new knowledge, where sustained attention is crucial.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                          child: Semantics(
                        label:
                            'Visual metaphor for focused goal achievement using the Pomodoro Technique',
                        enabled: true,
                        readOnly: true,
                        selected: true,
                        hint:
                            'Image showcasing a dartboard with a dart in the center, symbolizing precision and focus achieved through the Pomodoro Technique.',
                        child: Image.network(
                          'https://images.unsplash.com/photo-1596008194705-2091cd6764d4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1039&q=80',
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )),
                      const SizedBox(
                        height: 24,
                      ),

                      SelectableText(
                        '2. Reduces multitasking and distractions',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 24,
                      ),

                      Center(
                          child: Semantics(
                        label:
                            'Chess pieces on a board, symbolizing strategic focus and minimizing distractions.',
                        enabled: true,
                        readOnly: true,
                        selected: true,
                        hint:
                            'An image illustrating the concept of focus and strategic planning, akin to playing a game of chess. It represents how the Pomodoro technique helps in maintaining concentration and avoiding distractions.',
                        child: Image.network(
                          'https://images.unsplash.com/photo-1538221566857-f20f826391c6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1171&q=80',
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                        ),
                      )),
                      const SizedBox(
                        height: 24,
                      ),

                      SelectableText(
                        'Understanding the Primacy and Recency Effects with the Pomodoro Technique',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Psychological research suggests our brains are better at recalling the first and last items in a series. This phenomenon, known as the primacy and recency effects, can be strategically applied to enhance learning efficiency.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "The Pomodoro technique, by structuring study sessions into shorter intervals with breaks, optimally utilizes these cognitive biases. This method not only facilitates better information absorption but also promotes sustained focus and retention over prolonged study periods.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Semantics(
                          label: 'Illustration of spaced learning intervals',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'This image depicts how spacing out learning sessions can aid in better retention and understanding, aligning with the primacy and recency effects in cognitive psychology.',
                          child: Image.network(
                            'https://3.bp.blogspot.com/-PSUGQNip64U/WMXvlFe36GI/AAAAAAAAAMc/tMw_A0MteMoe3qpeOKKHwr_4iUfSV_TjACLcB/s640/whatisthespacingeffect.png',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                          ),
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
                      SelectableText(
                        'Frequently asked questions about the Pomodoro technique',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        '1. Why is the length of each slot 25 minutes?',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2)
,
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Longer sessions can lead to fatigue and lack of concentration, especially for individuals with shorter attention spans.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2)
,
                          fontSize: 22.0,
                          fontWeight:  FontWeight.w300,
                        ),
                      ),

                      const SizedBox(
                        height: 8,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SelectableText(
                            '2. Handling Distractions During Pomodoro Sessions',
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                                color: const Color(0xffF2F2F2)
,
                                fontSize: 24.0,
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          SelectableText(
                            "It's natural to encounter distractions. If you find your attention wandering, gently remind yourself to refocus. Avoid using this moment as an excuse for activities like watching videos online, which can derail your productivity.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2)
,
                              fontSize: 22.0,
                              fontWeight:  FontWeight.w300,
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          Center(
                            child: Semantics(
                              label: 'Pomodoro Technique Timer Visualization',
                              enabled: true,
                              readOnly: true,
                              selected: true,
                              hint:
                                  'A visual representation of a Pomodoro timer in action, showcasing the focus and discipline the technique promotes.',
                              child: Image.network(
                                "https://images.unsplash.com/photo-1436891620584-47fd0e565afb?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80",
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                    ),
                                  );
                                },
                              ),
                            ),
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
    );
  }
}
