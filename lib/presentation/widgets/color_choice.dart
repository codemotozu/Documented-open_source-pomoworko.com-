import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorChoice extends ConsumerWidget {
  final String title;
  final StateProvider<Color> darkColorProvider;
  final List<Color> darkColorOptions;

  const ColorChoice({
    super.key,
    required this.title,
    required this.darkColorProvider,
    required this.darkColorOptions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentColor =  ref.watch(darkColorProvider);

    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.nunito(
          color: const Color(0xffF2F2F2),
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children:
            (darkColorOptions)
                .map((color) {
          return IconButton(
            onPressed: () {
               ref.read(darkColorProvider.notifier).state = color;
              
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: currentColor == color
                      ? const Color.fromARGB(255, 168, 166, 166)
                      : Colors.transparent,
                  width: 2.0,
                ),
              ),
              child: Icon(
                Icons.circle,
                color: color,
              ),
            ),
            splashRadius: 24.0,
          );
        }).toList(),
      ),
    );
  }
}