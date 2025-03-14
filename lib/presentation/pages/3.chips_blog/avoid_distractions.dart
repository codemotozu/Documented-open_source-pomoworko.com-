import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../common/utils/responsive_web.dart';

class AvoidDistractions extends ConsumerStatefulWidget {
  const AvoidDistractions({super.key});

  @override
  _AvoidDistractionsState createState() => _AvoidDistractionsState();
}

class _AvoidDistractionsState extends ConsumerState<AvoidDistractions> {
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
                  Text(
                    'How to avoid distractions?',
                    style: GoogleFonts.nunito(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xffF2F2F2)),
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
                      SelectableText(
                        'The internal triggers ',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "In moments of solitude, we often find ourselves scrolling through Facebook, seeking connection. Uncertainty drives us to search the web for answers, while boredom pushes us to browse news, stock prices, and sports scores, all in an effort to avoid confronting these uncomfortable emotions head-on.",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 22.0,
                            fontWeight: FontWeight.w300),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Semantics(
                          label:
                              'Computer screen displaying multiple open tabs, symbolizing digital overload and our reliance on technology for emotional escape.', // Updated label for clarity and relevance.
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              "Illustrates the overwhelming nature of digital multitasking and our reliance on technology for emotional escape.", // More descriptive hint for context.
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2020/01/29/09/36/connection-4801974_960_720.jpg',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              // Implement a loading builder for better user experience.
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
                        'Distraction has many consequences. One of them is that we find that when someone is interrupted during a task, it can take up to 20 minutes for them to refocus on what they were doing.',
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
                      Center(
                        child: Semantics(
                          label:
                              'Facebook logo depicted as pills, symbolizing social media addiction.',
                          hint:
                              'Illustrates the addictive nature of social media platforms like Facebook.',
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2017/06/09/15/15/facebook-2387089_960_720.jpg',
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
                        '1. Surf the urge',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Researchers have discovered that 'surfing the urge'—a mindfulness technique—significantly aids in mastering our internal triggers. This method was notably effective in a study focused on smoking cessation, where participants who practiced mindfulness in response to cravings were more likely to quit. The technique involves observing the urge without judgment, allowing the sensation to peak and then naturally subside, much like a wave. This process helps individuals navigate and overcome uncomfortable internal triggers by letting them pass without action.",
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
                      Center(
                          child: Semantics(
                        label: 'a wave crashing on the shore',

                        enabled: true,
                        readOnly: true,
                        selected: true,
                        hint:
                            'An image depicting a wave, symbolizing the mindfulness technique of surfing the urge to let uncomfortable triggers pass.', // More descriptive hint to explain the context of the image.

                        child: Image.network(
                          'https://images.unsplash.com/photo-1616141893496-fbc65370493e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            // Implement a loading builder for better user experience.
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
                          semanticLabel:
                              'A wave crashing on the shore', // Explicitly set for better accessibility.
                        ),
                      )),
                      const SizedBox(
                        height: 24,
                      ),
                      SelectableText(
                        '2. Beware of "Liminal Moments"',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Be cautious of 'liminal moments'—transitional times between tasks, like checking emails while returning from a meeting. These moments, if not managed, can evolve into distractions, steering you away from priority tasks. Recognizing and minimizing such distractions enhances productivity and focus.",
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
                      Center(
                        child: Semantics(
                          label: 'Person engrossed in smartphone usage',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              "A depiction of social media's grip on daily life, showcasing a user absorbed in smartphone interaction, highlighting the pervasive nature of technology in connecting and networking.', // Expanded hint for better context and understanding.",
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2022/12/12/19/45/social-media-7651798_960_720.png',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              // Implement a loading builder for a better user experience during image load.
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
                        "3. Remember you're not powerless",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Research involving individuals recovering from alcoholism reveals a profound insight: the strongest predictor of sustained sobriety was not the extent of physical dependency but the belief in one’s own agency to overcome it. This parallels our relationship with technology. The narrative that technology irresistibly captivates our attention only diminishes our sense of control. Rejecting this misconception empowers us to manage technology use proactively, ensuring that we derive its benefits without becoming subservient to it.",
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
                      Center(
                        child: Semantics(
                          label: 'lion in the wild',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'Image of a majestic lion in its natural habitat, symbolizing strength and empowerment.', // Enhanced hint for context and relevance.
                          child: Image.network(
                            'https://images.unsplash.com/photo-1629812456605-4a044aa38fbc?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              // Loading builder for a smoother user experience.
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
                        '4. Have a Low-Tech Day',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Technology can be highly addictive, time-consuming, and stressful! Dedicate a day to minimize digital distractions by turning off notifications, logging out of social media accounts, and saving web surfing for designated breaks. This practice can significantly reduce stress and improve focus.",
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
                      Center(
                        child: Semantics(
                          label:
                              'A person enjoying freedom from digital addictions',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'Image depicts a person feeling liberated without the constant pull of technology, embodying the joy of a low-tech day.',
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2016/12/06/12/34/freedom-1886402_960_720.jpg',
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
                        "5. Put your phone down,",
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "We use our phones for everything these days... To enhance concentration, it's advisable to turn off your phone or keep it out of sight. This minimizes interruptions and helps maintain focus on the task at hand.",
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Semantics(
                              label: 'Avoid Distractions',
                              child: Container(
                                alignment: Alignment.center,
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                        0xfff98125)), // Consider using ThemeData for colors for consistency and easier maintenance.
                                child: const Icon(FontAwesomeIcons.ban,
                                    color: Color(0xff193a6f),
                                    size: 100,
                                    semanticLabel:
                                        'Prohibition Sign'), // Adding semanticLabel for better accessibility
                              ),
                            ),
                          ),
                          Center(
                            child: Semantics(
                              label: 'Minimize Smartphone Usage',
                              child: Container(
                                alignment: Alignment.center,
                                height: 150,
                                width: 150,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(
                                        0xfff98125)), // Same here regarding ThemeData.
                                child: const Icon(Icons.smartphone_outlined,
                                    color: Color(0xff193a6f),
                                    size: 100,
                                    semanticLabel:
                                        'Smartphone'), // Adding semanticLabel for better accessibility
                              ),
                            ),
                          ),
                        ],
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
                        '6. Organize your workload.',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                          color: const Color(0xffF2F2F2),
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Create a prioritized To-Do List, keep a tidy desk, and don't be afraid to ask for help if you feel overloaded. These steps help maintain focus and efficiency, leading to a more productive work environment.",
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
                      Center(
                        child: Semantics(
                          label: 'Clean and tidy desk with organized items',
                          // More descriptive label for better accessibility.
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'An organized workspace can significantly improve productivity and focus.',
                          // More informative hint to provide context.
                          child: Image.network(
                            'https://images.unsplash.com/photo-1471897488648-5eae4ac6686b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=387&q=80',
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
                        height: 48,
                      ),
                      SelectableText(
                        '8. Fly solo for the day.',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "To maximize focus, minimizing interruptions from others is crucial. When deep concentration is required, opting to work remotely or in a secluded space can significantly enhance productivity.",
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
                      Center(
                        child: Semantics(
                          label: 'A woman studying intently',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'Image depicts a focused study session, emphasizing the importance of a distraction-free environment for effective learning and productivity.',
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2015/07/17/22/43/student-849822_960_720.jpg',
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
                        '9. Take care of yourself.',
                        showCursor: true,
                        scrollPhysics: const ClampingScrollPhysics(),
                        style: GoogleFonts.nunito(
                            color: const Color(0xffF2F2F2),
                            fontSize: 24.0,
                            fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      SelectableText(
                        "Sometimes we are our own worst enemies when it comes to distractions. Getting a good night's sleep, keeping hydrated, and enjoying some fresh air can help you to stay focused and energized.",
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
                      Center(
                        child: Semantics(
                          label: 'A dog sleeping peacefully',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'This image represents the importance of rest and relaxation in maintaining focus and productivity.',
                          child: Image.network(
                            'https://cdn.pixabay.com/photo/2022/02/09/20/52/labrador-retriever-7004193_960_720.jpg',
                            loadingBuilder: (BuildContext context, Widget child,
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
                                              : null));
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      Center(
                        child: Semantics(
                          label: 'Focus on one task at a time',
                          enabled: true,
                          readOnly: true,
                          selected: true,
                          hint:
                              'This image symbolizes the importance of focusing on a single task to enhance work efficiency and achieve a balanced work-life.',
                          child: Image.network(
                            'https://images.unsplash.com/photo-1453728013993-6d66e9c9123a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80',
                            loadingBuilder: (BuildContext context, Widget child,
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
                                              : null));
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
                                    .bold), // Use FontWeight.bold for emphasis
                          ),
                          const SizedBox(height: 16),
                          SelectableText(
                            "MindToolsVideos. (2018). '7 Ways to Minimize Distractions' [Video]. YouTube.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight:
                                  FontWeight.normal, // Adjusted for readability
                            ),
                          ),
                          InkWell(
                            onTap: () => launchUrl(
                                Uri.parse(
                                    "https://www.youtube.com/watch?v=ticCbGGZqP8"),
                                mode: LaunchMode.externalApplication),
                            child: Text(
                              "Watch Video",
                              style: GoogleFonts.nunito(
                                color: Colors
                                    .blue, // Use a standard link color for clarity
                                fontSize: 22.0,
                                decoration: TextDecoration
                                    .underline, // Underline to indicate it's clickable
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SelectableText(
                            "BBC Ideas. (2020). 'Five ways to stop getting distracted | BBC Ideas' [Video]. YouTube.",
                            showCursor: true,
                            scrollPhysics: const ClampingScrollPhysics(),
                            style: GoogleFonts.nunito(
                              color: const Color(0xffF2F2F2),
                              fontSize: 22.0,
                              fontWeight:
                                  FontWeight.normal, // Consistency in styling
                            ),
                          ),
                          InkWell(
                            onTap: () => launchUrl(
                                Uri.parse(
                                    "https://www.youtube.com/watch?v=KZGVgz9b2fw"),
                                mode: LaunchMode.externalApplication),
                            child: Text(
                              "Watch Video",
                              style: GoogleFonts.nunito(
                                color: Colors.blue, // Consistent link color
                                fontSize: 22.0,
                                decoration: TextDecoration
                                    .underline, // Visual cue for links
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
