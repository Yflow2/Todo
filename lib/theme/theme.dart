

import 'package:flutter/material.dart';

ThemeData lightmode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    primary: Colors.blueAccent,
    secondary: Colors.white
  )

);

ThemeData darkmode = ThemeData(
  brightness: Brightness.dark,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFF0A3D62),
        secondary: Color(0xFF1E5F74)
    )
);