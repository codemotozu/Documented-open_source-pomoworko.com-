import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';



class AppTabBar extends ConsumerWidget implements PreferredSizeWidget {
  final TabController tabController;

  const AppTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return TabBar(
      controller: tabController,
      indicator: const UnderlineTabIndicator(
        borderSide: BorderSide(
            color: Color(0xffF2F2F2),
            width: 2.0),
      ),
      indicatorWeight: 5,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor:  const Color(0xffF2F2F2),
      labelStyle: GoogleFonts.nunito(
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      unselectedLabelColor: const Color.fromARGB(255, 134, 134, 134),
      tabs: const [
        Tab(
          text: "Pomodoro",
          icon: Icon(CupertinoIcons.device_laptop, size: 24),
        ),
        Tab(
          text: "Short break",
          icon: Icon(Icons.ramen_dining_outlined, size: 24),
        ),
        Tab(
          text: "Long break",
          icon: Icon(CupertinoIcons.battery_25_percent, size: 24),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}