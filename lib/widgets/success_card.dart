import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';
import 'custom_button.dart';

class SuccessCard extends ConsumerWidget {
  const SuccessCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Semantics(
      label: 'Story challenge successfully completed. Great job!',
      container: true,
      child: Card(
        color: Colors.white,
        elevation: 6,
        shadowColor: const Color(0xFF5AC85A).withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: Color(0xFF5AC85A), width: 2.5),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Great Job!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5AC85A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "You remembered the story perfectly.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: "Start Again",
                semanticLabel: "Restart story and quiz",
                onPressed: () {
                  ref.read(audioProvider.notifier).reset();
                  ref.read(quizProvider.notifier).resetQuiz();
                },
              ),
            ],
          ),
        ),
      ).animate()
       .fade(duration: 500.ms, curve: Curves.easeOut)
       .scale(duration: 500.ms, curve: Curves.easeOutBack, begin: const Offset(0.8, 0.8)),
    );
  }
}
