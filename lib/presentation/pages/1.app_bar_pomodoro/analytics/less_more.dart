import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../notifiers/persistent_container_notifier.dart';
import '../../../notifiers/providers.dart';

class LessAndMoreContainerGithubChart extends ConsumerWidget {
  const LessAndMoreContainerGithubChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedContainerIndex =
        ref.watch(persistentContainerIndexProvider) ?? 0;

    // Definir los colores para cada proyecto
    final List<Color> projectColors = [
      const Color(0xffDE6868),
      const Color(0xffECBB42),
      const Color(0xff4439B9),
      const Color(0xff34BB54),
    ];

    // Obtener el color actual basado en el índice seleccionado
    Color currentColor =
        projectColors[selectedContainerIndex % projectColors.length];

    // Función para generar tonos de color
    Color getColorShade(Color baseColor, double factor) {
      int r = (baseColor.red * factor).round().clamp(0, 255);
      int g = (baseColor.green * factor).round().clamp(0, 255);
      int b = (baseColor.blue * factor).round().clamp(0, 255);
      return Color.fromRGBO(r, g, b, 1);
    }

    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 50.0, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
            child: Text(
              'Less',
              style: GoogleFonts.nunito(
                color: const Color(0xffF2F2F2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          _buildColorBox(
              context, getColorShade(currentColor, 0.2), 'At least 1 min'),
          _buildColorBox(
              context, getColorShade(currentColor, 0.4), 'At least 15 min'),
          _buildColorBox(
              context, getColorShade(currentColor, 0.6), 'At least 30 min'),
          _buildColorBox(
              context, getColorShade(currentColor, 0.8), 'At least 45 min'),
          _buildColorBox(context, currentColor, 'At least 60 min'),
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text(
              'More',
              style: GoogleFonts.nunito(
                color: const Color(0xffF2F2F2),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorBox(BuildContext context, Color color, String tooltip) {
    return Tooltip(
      message: tooltip,
      textStyle: TextStyle(
        color: Colors.grey[800],
        fontFamily: 'San Francisco',
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0, right: 2.0),
        child: Container(
          height: 12.5,
          width: 12.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: color,
          ),
        ),
      ),
    );
  }
}
