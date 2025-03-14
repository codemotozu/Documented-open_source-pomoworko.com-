import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routemaster/routemaster.dart';

import '../../../../common/utils/responsive_show_dialogs.dart';
import '../../../repository/auth_repository.dart';
import '../../../screens/login_google_screen.dart';
import 'check_double.dart';
import 'profile/contact_developer.dart';
import 'profile/delete_account_no_premium.dart';
import 'profile/delete_account_premium.dart';
import 'profile/ready_soon_features.dart';
import 'profile/subscription_details.dart';

class AppBarFeatures extends ConsumerStatefulWidget {
  const AppBarFeatures({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileAppBarState();
}

class _ProfileAppBarState extends ConsumerState<AppBarFeatures> {
  final tapOffsetProvider = StateProvider<Offset?>((watch) => null);

  @override
  Widget build(BuildContext context) {
    var tapOffset = ref.watch(tapOffsetProvider);

    final user = ref.watch(userProvider.notifier).state;

    return ProviderScope(
      child: SafeArea(
        child: Builder(
          builder: (
            BuildContext context,
          ) {
            return Scaffold(
              backgroundColor: const Color.fromARGB(255, 0, 0, 0),
              body: CustomScrollView(
                slivers: [
                  SliverAppBar.medium(
                    pinned: true,
                    floating: false,
                    expandedHeight: 95,
                    backgroundColor:
                        // ref.watch(currentColorProvider)
                        //  const Color(0xff28292B),
                        // * CHATGPT GREY COLOR
                        const Color.fromARGB(255, 0, 0, 0),
                    leading: const CheckDoubleIcon(),
                    flexibleSpace: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 13),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Transform.translate(
                              offset: const Offset(0, -8),
                              child: Text.rich(
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
                                        decorationColor:
                                            const Color(0xffF2F2F2),
                                        decorationThickness: 3,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'o.com ',
                                      style: GoogleFonts.nunito(
                                          fontSize: 22,
                                          color: const Color(0xffF2F2F2),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tooltip(
                          message: 'Chat with the developer',
                          child: Semantics(
                            label: 'Toggle Dark Mode',
                            enabled: true,
                            readOnly: true,
                            child: Consumer(
                              builder: (context, watch, child) {
                                final userModel = ref.watch(
                                  userProvider,
                                );
                                if (user != null) {
                                  if (userModel != null &&
                                      userModel.profilePic.isNotEmpty) {
                                    return Consumer(
                                      builder: (context, ref, child) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 18, 0),
                                          child: IconButton(
                                            icon: const Icon(
                                              CupertinoIcons.chat_bubble,
                                              color: Color(0xffF2F2F2),
                                              size: 28,
                                              semanticLabel: 'Toggle Dark Mode',
                                            ),
                                            onPressed: () {
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) =>
                                               /*
                                                    CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Email:',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'San Francisco'),
                                                  ),
                                                content: const Text(
                                                    "contact.pomoworko@gmail.com\n (for general inquiries, support, and bugs) ",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'San Francisco'),
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'San Francisco',
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                  ],
                                                ),
                                             */
                                            ResponsiveShowDialogs(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child:
                                                              const ContactDeveloper(),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    return const SizedBox(
                                      height: 0,
                                    );
                                  }
                                } else {
                                  return const SizedBox(
                                    height: 0,
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Tooltip(
                            message: 'Settings',
                            child: Semantics(
                              label: 'Pomodoro timer settings',
                              enabled: true,
                              readOnly: true,
                              child: IconButton(
                                icon: const Icon(
                                  CupertinoIcons.gear_alt,
                                  color: Color(0xffF2F2F2),
                                  size: 28,
                                  semanticLabel: 'Pomodoro timer Settings',
                                ),
                                onPressed: () {
                                  Routemaster.of(context)
                                      .push('/pomodoro-technique-settings');
                                },
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: (details) {
                              tapOffset = details.globalPosition;
                            },
                            child: IconButton(
                              onPressed: () {
                                Routemaster.of(context)
                                    .push('/time-management-analytics');
                              },
                              icon: Tooltip(
                                message: 'Analytics',
                                child: Semantics(
                                  label: 'Pomodoro timer 2023 Analytics',
                                  enabled: true,
                                  readOnly: true,
                                  child: const Icon(
                                    CupertinoIcons.chart_bar,
                                    color: Color(0xffF2F2F2),
                                    size: 28,
                                    semanticLabel: 'Pomodoro timer More',
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTapDown: (details) {
                              ref.read(tapOffsetProvider.notifier).state =
                                  details.globalPosition;
                            },
                            child: Semantics(
                              label: 'Pomodoro timer profile',
                              enabled: true,
                              readOnly: true,
                              child: IconButton(
                                onPressed: () {
                                  final tapOffset = ref.read(tapOffsetProvider);
                                  final userModel = ref.read(
                                    userProvider,
                                  );
                                  List<PopupMenuItem> menuItems;

                                  if (userModel != null) {
                                    menuItems = [
                                      PopupMenuItem(
                                        child: ListTile(
                                            title: Text(
                                              'Log out',
                                              style: GoogleFonts.nunito(
                                                color: const Color(0xffF2F2F2),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              Icons.logout_outlined,
                                              color: Color(0xffF2F2F2),
                                              size: 20,
                                              semanticLabel:
                                                  'Pomodoro timer Log out',
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              ref
                                                  .read(authRepositoryProvider)
                                                  .signOut(ref);
                                              ref
                                                  .read(userProvider.notifier)
                                                  .state = null;

                                              Navigator.of(context).pop();
                                            }),
                                      ),
                                      if (user != null &&
                                          user.isPremium == true)
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text(
                                              'Subscription details',
                                              style: GoogleFonts.nunito(
                                                color: const Color(0xffF2F2F2),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              CupertinoIcons.doc_text_search,
                                              color: Color(0xffF2F2F2),
                                              size: 20,
                                              semanticLabel:
                                                  'Pomodoro timer premium feature',
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResponsiveShowDialogs(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child:
                                                              const SubscriptionDetails(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == false)
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text(
                                              'Premium ',
                                              style: GoogleFonts.nunito(
                                                color: const Color(0xffF2F2F2),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              CupertinoIcons.checkmark_seal,
                                              color: Color(0xffF2F2F2),
                                              size: 20,
                                              semanticLabel:
                                                  'Pomodoro timer premium feature',
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResponsiveShowDialogs(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              0, 0, 0, 0),
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child:
                                                              const PremiumReadySoon(),
                                                          // child:
                                                          //     const GoPremium(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == true)
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text(
                                              'Delete account',
                                              style: GoogleFonts.nunito(
                                                color: const Color(0xffF2F2F2),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              CupertinoIcons.trash,
                                              color: Color(0xffF2F2F2),
                                              size: 20,
                                              semanticLabel:
                                                  'Pomodoro timer Delete account',
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResponsiveShowDialogs(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child:
                                                              const DeleteAccountPremium(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      if (user != null &&
                                          user.isPremium == false)
                                        PopupMenuItem(
                                          child: ListTile(
                                            title: Text(
                                              'Delete account',
                                              style: GoogleFonts.nunito(
                                                color: const Color(0xffF2F2F2),
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            trailing: const Icon(
                                              CupertinoIcons.trash,
                                              color: Color(0xffF2F2F2),
                                              size: 20,
                                              semanticLabel:
                                                  'Pomodoro timer Delete account',
                                            ),
                                            contentPadding: EdgeInsets.zero,
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return ResponsiveShowDialogs(
                                                    child: SimpleDialog(
                                                      backgroundColor:
                                                          const Color.fromARGB(
                                                              255, 0, 0, 0),
                                                      children: [
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.4,
                                                          child:
                                                              const DeleteAccountNoPremium(),
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        )
                                    ];
                                  } else {
                                    // User is not logged in, you can leave it empty or add some other options
                                    menuItems = [];
                                  }
                                  showMenu(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                    position: RelativeRect.fromLTRB(
                                      tapOffset!.dx - 150,
                                      64,
                                      tapOffset.dx,
                                      0,
                                    ),
                                    constraints: const BoxConstraints(
                                      maxWidth: 600,
                                    ),
                                    context: context,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    items: menuItems,
                                  );
                                },
                                icon: Consumer(
                                  builder: (context, read, child) {
                                    final userModel = ref.watch(
                                      userProvider,
                                    );

                                    if (userModel != null &&
                                        userModel.profilePic.isNotEmpty) {
                                      return CircleAvatar(
                                        radius: 16.5,
                                        backgroundImage:
                                            NetworkImage(userModel.profilePic),
                                      );
                                    } else {
                                      return Semantics(
                                        label: 'Pomodoro timer Log in',
                                        enabled: true,
                                        readOnly: true,
                                        child: Tooltip(
                                          message: 'Log in',
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.person_outline_outlined,
                                              size: 28,
                                              color: Color(0xffF2F2F2),
                                            ),
                                            onPressed: () {
                                              showCupertinoDialog(
                                                barrierDismissible: true,
                                                context: context,
                                                builder: (context) =>
                                                    CupertinoAlertDialog(
                                                  title: const Text(
                                                    'Log in',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18,
                                                        fontFamily:
                                                            'San Francisco'),
                                                  ),
                                                  content:
                                                      const LoginGoogleScreen(),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 18,
                                                          fontFamily:
                                                              'San Francisco',
                                                          color: Color.fromARGB(
                                                              255,
                                                              255,
                                                              255,
                                                              255),
                                                        ),
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 13),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
