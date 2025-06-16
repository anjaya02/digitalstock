import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DS {
  // Colours
  static const Color bg      = Color(0xFFF9FAFC);
  static const Color cardBG  = Color(0xFFE9EEF6);
  static const Color outline = Color(0xFFCBD3E7);
  static const Color primary = Color(0xFF0676FF);
  static const Radius radius = Radius.circular(16);

  // ── THEME ────────────────────────────────────────────────────────────────
  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bg,
      colorScheme: ColorScheme.fromSeed(seedColor: primary),
    );

    return base.copyWith(
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          textStyle:
              GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardBG,
          foregroundColor: Colors.black87,
          textStyle: GoogleFonts.poppins(),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ── REUSABLE WIDGETS ─────────────────────────────────────────────────────
  static Widget summaryCard(String label, String value) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBG,
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: GoogleFonts.poppins(
                    fontSize: 14, color: Colors.black.withOpacity(.7))),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 28, fontWeight: FontWeight.w600)),
          ],
        ),
      );

  static Widget paymentBox(String label, String value) => Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: outline),
          borderRadius: const BorderRadius.all(radius),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    GoogleFonts.poppins(fontSize: 14, color: Colors.black87)),
            const SizedBox(height: 8),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 22, fontWeight: FontWeight.w600)),
          ],
        ),
      );
}
