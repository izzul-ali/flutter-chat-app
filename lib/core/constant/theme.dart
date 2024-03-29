import 'package:flutter/material.dart';
import 'package:flutter_chat_app/core/constant/color.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData themeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryChatColor),
  scaffoldBackgroundColor: const Color(0xffFCFCFC),
  textTheme: GoogleFonts.interTextTheme(),
  appBarTheme: const AppBarTheme(surfaceTintColor: Colors.white),
);
