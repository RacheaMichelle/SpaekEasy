import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:language_learning_assistant/screens/sign_in_page.dart';
import 'package:language_learning_assistant/screens/sign_up_page.dart';
import 'package:language_learning_assistant/screens/home_screen.dart';
import 'package:language_learning_assistant/screens/settings_page.dart';
import 'package:language_learning_assistant/screens/user_profile_page.dart';

import 'package:language_learning_assistant/screens/language_page.dart';

import 'package:language_learning_assistant/screens/language_details.dart';
import 'package:language_learning_assistant/firestore_service.dart'; // Import your FirestoreService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize FirestoreService and populate languages
  final firestoreService = FirestoreService();
  await firestoreService.populateLanguages();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpeakEasy',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: '/sign-in',
      routes: {
        '/sign-in': (context) => SignInPage(),
        '/sign-up': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/language-selection': (context) => LanguageSelectionPage(
              onToggleDarkMode: _toggleDarkMode,
            ),
        '/language-details': (context) => LanguageDetailsPage(),
        '/user-profile': (context) => UserProfilePage(),
        '/settings': (context) => SettingsPage(),
      },
    );
  }
}
