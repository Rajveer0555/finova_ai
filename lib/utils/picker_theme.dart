import 'package:flutter/material.dart';

const Color finovaPickerBlue = Color(0xFF4A90FF);
const Color finovaPickerLightBlue = Color(0xFFEAF3FF);

Widget finovaPickerTheme(BuildContext context, Widget? child) {
  final baseTheme = Theme.of(context);
  final colorScheme = baseTheme.colorScheme.copyWith(
    primary: finovaPickerBlue,
    onPrimary: Colors.white,
    secondary: finovaPickerBlue,
    onSecondary: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  );

  return Theme(
    data: baseTheme.copyWith(
      colorScheme: colorScheme,
      dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
      datePickerTheme: DatePickerThemeData(
        backgroundColor: Colors.white,
        headerBackgroundColor: finovaPickerBlue,
        headerForegroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        todayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return finovaPickerBlue;
        }),
        todayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return finovaPickerBlue;
          }
          return Colors.transparent;
        }),
        dayForegroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black87;
        }),
        dayBackgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return finovaPickerBlue;
          }
          return Colors.transparent;
        }),
        rangePickerBackgroundColor: Colors.white,
        rangePickerHeaderBackgroundColor: finovaPickerBlue,
        rangePickerHeaderForegroundColor: Colors.white,
        rangeSelectionBackgroundColor: finovaPickerLightBlue,
        rangeSelectionOverlayColor: WidgetStateProperty.all(
          finovaPickerBlue.withValues(alpha: 0.12),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: Colors.white,
        hourMinuteColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return finovaPickerBlue;
          }
          return finovaPickerLightBlue;
        }),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return finovaPickerBlue;
        }),
        dialBackgroundColor: finovaPickerLightBlue,
        dialHandColor: finovaPickerBlue,
        dialTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return Colors.black87;
        }),
        entryModeIconColor: finovaPickerBlue,
        dayPeriodColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return finovaPickerBlue;
          }
          return finovaPickerLightBlue;
        }),
        dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }
          return finovaPickerBlue;
        }),
        helpTextStyle: const TextStyle(
          color: Colors.black,
          fontFamily: 'SFProText',
          fontWeight: FontWeight.w600,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: finovaPickerBlue,
          textStyle: const TextStyle(
            fontFamily: 'SFProText',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ),
    child: child ?? const SizedBox.shrink(),
  );
}
