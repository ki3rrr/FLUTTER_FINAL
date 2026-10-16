import 'package:flutter/material.dart';

import 'screens/library_screen.dart';
import 'theme/app_colors.dart';

void main() {
  runApp(const BookLibraryApp());
}

class BookLibraryApp extends StatelessWidget {
  const BookLibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Library Management System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.forest,
          surface: AppColors.canvas,
        ),
        fontFamily: 'Georgia',
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.canvas,
          foregroundColor: AppColors.ink,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const LibraryScreen(),
    );
  }
}
