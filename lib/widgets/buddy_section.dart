import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';

class BuddySection extends ConsumerWidget {
  const BuddySection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audioState = ref.watch(audioProvider);
    final quizState = ref.watch(quizProvider);
    String message = "Hello! Let's read a story together.";
    Color messageBg = Colors.white;
    Color messageTextColor = Colors.black87;
    bool isHappy = false;
    bool isSpeaking = false;
    bool isError = false;

    if (audioState == AudioState.preparing) {
      message = "Preparing Story...";
      messageBg = const Color(0xFFFFB84D).withOpacity(0.2);
      isSpeaking = true;
    } else if (audioState == AudioState.reading) {
      message = "Story Time!";
      messageBg = const Color(0xFFFF8A00).withOpacity(0.2);
      isSpeaking = true;
    } else if (audioState == AudioState.error) {
      message = "Oops! I couldn't read the story.\nLet's try again.";
      messageBg = Colors.red.shade50;
      messageTextColor = Colors.red.shade800;
      isError = true;
    } else if (quizState.isCorrect == true) {
      message = "Great Job!\nYou remembered the story perfectly.";
      messageBg = const Color(0xFF5AC85A).withOpacity(0.15);
      messageTextColor = const Color(0xFF5AC85A);
      isHappy = true;
    } else if (quizState.isCorrect == false) {
      message = "Oops! Pip says that's not quite right.\nTry again!";
      messageBg = Colors.orange.shade50;
      messageTextColor = Colors.orange.shade800;
      isError = true;
    } else if (audioState == AudioState.completed) {
      message = "Can you help me solve this challenge?";
      messageBg = Colors.white;
      isHappy = false;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              if (isSpeaking)
                Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFFF8A00).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      end: const Offset(1.15, 1.15),
                      duration: 800.ms,
                      curve: Curves.easeInOut,
                    ),

              if (isHappy)
                Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5AC85A).withOpacity(0.3),
                        blurRadius: 25,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),

              _buildBuddyImage(isHappy, isSpeaking, isError),
            ],
          ),
          const SizedBox(height: 20),

          Semantics(
            liveRegion: true,
            label: "Pip the Robot says: $message",
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: messageBg,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isError
                      ? Colors.red.shade200
                      : (isHappy
                            ? const Color(0xFF5AC85A).withOpacity(0.5)
                            : Colors.grey.shade200),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: messageTextColor,
                  height: 1.3,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyImage(bool isHappy, bool isSpeaking, bool isError) {
    Widget character = Image.asset(
      'assets/images/robot.png',
      width: 140,
      height: 140,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return _RobotVectorPlaceholder(
          isHappy: isHappy,
          isSpeaking: isSpeaking,
          isError: isError,
        );
      },
    );

    if (isHappy) {
      return character
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .moveY(
            begin: 0.0,
            end: -12.0,
            duration: 600.ms,
            curve: Curves.easeInOut,
          )
          .scale(begin: const Offset(1.0, 1.0), end: const Offset(1.08, 1.08));
    } else if (isSpeaking) {
      return character
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .scale(
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.05, 1.05),
            duration: 500.ms,
          )
          .shake(hz: 2, curve: Curves.easeInOut);
    } else if (isError) {
      return character.animate().shake(
        duration: 400.ms,
        hz: 6,
        curve: Curves.easeIn,
      );
    } else {
      return character
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .slideY(
            begin: -0.05,
            end: 0.05,
            duration: 1500.ms,
            curve: Curves.easeInOut,
          );
    }
  }
}

class _RobotVectorPlaceholder extends StatelessWidget {
  final bool isHappy;
  final bool isSpeaking;
  final bool isError;

  const _RobotVectorPlaceholder({
    Key? key,
    this.isHappy = false,
    this.isSpeaking = false,
    this.isError = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFFFB84D), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            left: 12,
            top: 48,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: 48,
            child: Container(
              width: 10,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),

          Positioned(
            top: 8,
            child: Column(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: isError
                        ? Colors.red
                        : (isHappy
                              ? const Color(0xFF5AC85A)
                              : const Color(0xFFFF8A00)),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(width: 3, height: 14, color: Colors.grey.shade400),
              ],
            ),
          ),

          Positioned(
            top: 26,
            child: Container(
              width: 72,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.blueGrey.shade300, width: 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 58,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade800,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  Positioned(left: 12, child: _buildEye()),

                  Positioned(right: 12, child: _buildEye()),

                  Positioned(bottom: 3, child: _buildMouth()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEye() {
    if (isError) {
      return Text(
        "x",
        style: GoogleFonts.poppins(
          color: Colors.redAccent,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }
    if (isHappy) {
      return const Icon(Icons.favorite, color: Colors.pinkAccent, size: 12);
    }
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: Color(0xFF00E5FF),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildMouth() {
    if (isError) {
      return Container(width: 14, height: 2, color: Colors.redAccent);
    }
    if (isHappy || isSpeaking) {
      return Container(
        width: 14,
        height: 6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
      );
    }
    return Container(width: 10, height: 1.5, color: Colors.white);
  }
}
