import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class StoryCard extends StatelessWidget {
  final String title = "📖 Today's Story";
  final String storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  const StoryCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: "Story Card. Title: $title. Story text: $storyText",
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFFF8A00),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                storyText,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ).animate()
       .fade(duration: 600.ms, curve: Curves.easeOut)
       .slideY(begin: 0.1, end: 0.0, duration: 600.ms, curve: Curves.easeOut),
    );
  }
}
