import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class TimeFramePopupPremiumMenuButton extends ConsumerStatefulWidget {
  final List<String> timeFrames;
  final String currentTimeFrame;
  final Function(String) onTimeFrameSelected;
  final bool isPremium;

  const TimeFramePopupPremiumMenuButton({
    required this.timeFrames,
    required this.currentTimeFrame,
    required this.onTimeFrameSelected,
    this.isPremium = false,
    super.key,
  });

  @override
  ConsumerState<TimeFramePopupPremiumMenuButton> createState() =>
      _TimeFramePopupPremiumMenuButtonState();
}

class _TimeFramePopupPremiumMenuButtonState
    extends ConsumerState<TimeFramePopupPremiumMenuButton> {
  bool isPremium = false;
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10.0),
      child: Theme(
        data: Theme.of(context).copyWith(
          splashFactory: NoSplash.splashFactory,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: PopupMenuButton<String>(
          color: const Color((0xffF5F7FA)),
          // color:  Colors.blueAccent,
          tooltip: "Select time frame",
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          onSelected: (frame) {
            widget.onTimeFrameSelected(frame);
          },
          itemBuilder: (BuildContext context) => widget.timeFrames
              .map(
                (frame) => PopupMenuItem<String>(
                  value: frame,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      //** icon  open or lock
                      Text(
                        frame,
                        style: GoogleFonts.nunito(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      if ((frame == "Monthly" || frame == "Yearly") &&
                          !widget.isPremium)
                        const Icon(
                          CupertinoIcons.lock_open,
                          size: 18,
                          color: Colors.black,
                        ),
                    ],
                  ),
                ),
              )
              .toList(),
          child: SizedBox(
            width: 165,
            child: Material(
              type: MaterialType.transparency,
              elevation: 2,
              borderRadius: BorderRadius.circular(14.0),
              child: Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  // color: const Color(0xff121212),
                  // color: Colors.blueAccent,
                  color: const Color((0xffF5F7FA)),
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.transparent),
                ),
                padding: const EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    widget.currentTimeFrame,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
