import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';

class PlayfulProgressIndicator extends ConsumerWidget {
  const PlayfulProgressIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final quizState = ref.watch(quizProvider);

    String storyText = "Story";
    Color storyColor = const Color(0xFFFFB84D);
    IconData storyIcon = Icons.hourglass_empty_rounded;

    String quizText = "Quiz";
    Color quizColor = Colors.grey.shade400;
    IconData quizIcon = Icons.lock_outline_rounded;

    if (audioState == AudioState.preparing) {
      storyText = "Story";
      storyColor = const Color(0xFFFFB84D);
      storyIcon = Icons.hourglass_top_rounded;
    } else if (audioState == AudioState.reading) {
      storyText = "Story ";
      storyColor = const Color(0xFFFF8A00);
      storyIcon = Icons.menu_book_rounded;
    } else if (audioState == AudioState.error) {
      storyText = "Story ";
      storyColor = Colors.red.shade400;
      storyIcon = Icons.error_outline_rounded;
    } else if (audioState == AudioState.completed ||
        quizState.isCorrect == true) {
      storyText = "Story ";
      storyColor = const Color(0xFF5AC85A);
      storyIcon = Icons.check_circle_rounded;
    }

    if (quizState.isCorrect == true) {
      quizText = "Quiz ";
      quizColor = const Color(0xFF5AC85A);
      quizIcon = Icons.stars_rounded;
    } else if (audioState == AudioState.completed) {
      quizText = "Quiz ";
      quizColor = const Color(0xFFFFB84D);
      quizIcon = Icons.quiz_rounded;
    }

    return Semantics(
      label: 'Narration and Quiz progress steps',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildBadge(storyText, storyColor, storyIcon),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 16,
              height: 2,
              color: Colors.grey.shade300,
            ),
            _buildBadge(quizText, quizColor, quizIcon),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, IconData icon) {
    final Color textColor = Color.lerp(color, Colors.black, 0.2) ?? color;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: textColor,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
