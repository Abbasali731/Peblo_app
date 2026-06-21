import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/story_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Story Buddy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF7E8),
        primaryColor: const Color(0xFFFF8A00),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8A00),
          primary: const Color(0xFFFF8A00),
          secondary: const Color(0xFFFFB84D),
          error: Colors.red.shade400,
        ),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: const StoryScreen(),
    );
  }
}
