import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_constants.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    // NOTE: brightness is passed *into* the ColorScheme constructor rather
    // than patched on afterwards with copyWith. Flipping the flag after the
    // fact leaves `onSurface` black, which renders every default Material
    // text black-on-black under Material 3.
    const scheme = ColorScheme.dark(
      primary: AppColors.accent,
      onPrimary: Color(0xFF0B0716),
      secondary: AppColors.accentAlt,
      onSecondary: Color(0xFF04181C),
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      surfaceContainerHighest: AppColors.surfaceHigh,
      outline: AppColors.borderStrong,
      error: Color(0xFFFF6B6B),
      onError: Color(0xFF1A0505),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      fontFamily: AppFonts.body,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
    );

    return base.copyWith(
      textTheme: _textTheme(base.textTheme),
      // Reveal + hero motion is driven by explicit controllers, so the shared
      // axis page transition is only used for the project detail route.
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 1,
      ),
      iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: AppColors.surfaceHigh,
          borderRadius: AppRadii.smAll,
          border: Border.all(color: AppColors.border),
        ),
        textStyle: AppText.caption.copyWith(color: AppColors.textPrimary),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        waitDuration: const Duration(milliseconds: 400),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.03),
        hintStyle: AppText.body.copyWith(color: AppColors.textTertiary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: _inputBorder(AppColors.border),
        enabledBorder: _inputBorder(AppColors.border),
        focusedBorder: _inputBorder(AppColors.accent, width: 1.5),
        errorBorder: _inputBorder(const Color(0xFFFF6B6B)),
        focusedErrorBorder: _inputBorder(const Color(0xFFFF6B6B), width: 1.5),
        errorStyle: AppText.caption.copyWith(color: const Color(0xFFFF8A8A)),
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.hovered)
              ? AppColors.accentOn(0.55)
              : Colors.white.withValues(alpha: 0.12),
        ),
        thickness: const WidgetStatePropertyAll(6),
        radius: const Radius.circular(999),
        crossAxisMargin: 2,
      ),
      // A visible, on-brand focus ring for keyboard users.
      focusColor: AppColors.accentOn(0.6),
    );
  }

  static OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: AppRadii.mdAll,
        borderSide: BorderSide(color: color, width: width),
      );

  static TextTheme _textTheme(TextTheme base) => base
      .copyWith(
        displayLarge: base.displayLarge?.copyWith(fontFamily: AppFonts.display),
        displayMedium: base.displayMedium?.copyWith(
          fontFamily: AppFonts.display,
        ),
        displaySmall: base.displaySmall?.copyWith(fontFamily: AppFonts.display),
        headlineLarge: base.headlineLarge?.copyWith(
          fontFamily: AppFonts.display,
        ),
        headlineMedium: base.headlineMedium?.copyWith(
          fontFamily: AppFonts.display,
        ),
        headlineSmall: base.headlineSmall?.copyWith(
          fontFamily: AppFonts.display,
        ),
        titleLarge: base.titleLarge?.copyWith(fontFamily: AppFonts.display),
        bodyLarge: base.bodyLarge?.copyWith(
          fontFamily: AppFonts.body,
          color: AppColors.textSecondary,
        ),
        bodyMedium: base.bodyMedium?.copyWith(
          fontFamily: AppFonts.body,
          color: AppColors.textSecondary,
        ),
      )
      .apply(
        bodyColor: AppColors.textSecondary,
        displayColor: AppColors.textPrimary,
      );

  /// Keeps the browser chrome (mobile address bar) in step with the page.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarColor: AppColors.background,
    systemNavigationBarIconBrightness: Brightness.light,
  );
}
