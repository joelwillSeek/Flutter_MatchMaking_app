import 'package:flutter/material.dart';

final darkTheme = ThemeData.dark().copyWith(
  // Define primary and accent colors
  primaryColor: Colors.blue[700], // Example accent color

  // Define scaffold background color
  scaffoldBackgroundColor: Colors.grey[900], // Dark background color

  // Define card and surface colors for containers
  cardColor: Colors.grey[800], // Background color for cards and surfaces
  canvasColor: Colors.grey[800], // Canvas color for dialogs and bottom sheets

  // Define button theme
  buttonTheme: ButtonThemeData(
    buttonColor: Colors.blue[700], // Button background color
    textTheme: ButtonTextTheme.primary, // Use primary color for button text
  ),

  // Define text theme
  textTheme: TextTheme(
    headlineSmall: TextStyle(color: Colors.white), // Headline text color
    headlineLarge: TextStyle(color: Colors.white70), // Body text color
    bodyMedium: TextStyle(color: Colors.white), // Button text color
  ),

  // Define input decoration theme for text fields
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[800], // Background color for text fields
    hintStyle: TextStyle(color: Colors.white70), // Hint text color
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(10.0),
    ),
  ),

  // Define icon theme
  iconTheme: IconThemeData(color: Colors.white),
  colorScheme: ColorScheme.fromSwatch()
      .copyWith(secondary: Colors.blueAccent[400]), // Icon color
);
