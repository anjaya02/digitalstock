import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DS {
  // ───────────  Colours  ───────────
  static const Color bgWhite = Colors.white;
  static const Color cardGrey = Color(
    0xFFF2F2F2,
  ); // summary cards / grey buttons
  static const Color outline = Color(0xFFE0E0E0); // thin borders
  static const Color primary = Colors.black; // main accent (buttons, icons)
  static const Radius radius = Radius.circular(16);

  // ───────────  Theme  ───────────
  static ThemeData theme() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: bgWhite,
      colorScheme: ColorScheme.light(
        primary: primary,
        onPrimary: Colors.white,
        secondary: primary,
      ),
    );

    return base.copyWith(
      // Typography
      textTheme: GoogleFonts.poppinsTextTheme(base.textTheme),

      // App Bar
      appBarTheme: AppBarTheme(
        backgroundColor: bgWhite,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      // Primary (black) button
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Secondary (light-grey) button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: cardGrey,
          foregroundColor: Colors.black,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
      ),

      // Navigation Bar (NO pink indicator)
      navigationBarTheme: navBarTheme(),
    );
  }

  // ───────────  Navigation Bar Theme  ───────────
  static NavigationBarThemeData navBarTheme() {
    return NavigationBarThemeData(
      backgroundColor: bgWhite,
      indicatorColor:
          Colors.transparent, // removes the default Material-3 coloured pill
      surfaceTintColor: Colors.transparent, // kills elevation tint
      elevation: 0,
      iconTheme: MaterialStateProperty.resolveWith((states) {
        return const IconThemeData(color: Colors.black);
      }),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        return GoogleFonts.poppins(
          color: Colors.black,
          fontSize: 12,
          fontWeight: states.contains(MaterialState.selected)
              ? FontWeight.w600
              : FontWeight.w500,
        );
      }),
    );
  }

  // ───────────  Re-usable widgets  ───────────
  /// Large grey summary card (e.g., "Today’s Sales")
  static Widget summaryCard(String label, String value) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      color: cardGrey,
      borderRadius: const BorderRadius.all(radius),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.black.withOpacity(.8),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );

  /// Thin-outline box (e.g., payment method totals)
  static Widget outlineBox(String label, String value) => Container(
    padding: const EdgeInsets.all(24),
    decoration: BoxDecoration(
      border: Border.all(color: outline),
      borderRadius: const BorderRadius.all(radius),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
        ),
        const SizedBox(height: 12),
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700),
        ),
      ],
    ),
  );

  // ── Back-compat aliases (for older screen code) ──
  static const Color cardBG = cardGrey; // old colour name
  static Widget paymentBox(String l, String v) => outlineBox(l, v);
}
