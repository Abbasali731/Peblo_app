import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quiz_provider.dart';

class QuizSection extends ConsumerWidget {
  const QuizSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final quiz = quizState.quiz;

    if (quiz == null) {
      return const SizedBox.shrink();
    }

    final bool isCorrect = quizState.isCorrect == true;

    Widget quizCard = Semantics(
      container: true,
      label: "Story Challenge Section",
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.04),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "🧠 Story Challenge",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF8A00),
                    ),
                  ),
                  const Spacer(),
                  if (isCorrect)
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF5AC85A),
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: 14),

              Text(
                quiz.question,
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quiz.options.length,
                itemBuilder: (context, index) {
                  final option = quiz.options[index];
                  final isSelected = quizState.selectedAnswer == option;

                  return OptionCard(
                    text: option,
                    isSelected: isSelected,
                    isCorrect: isCorrect,
                    disabled: isCorrect,
                    onTap: () {
                      ref.read(quizProvider.notifier).submitAnswer(option);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    if (quizState.shakeCount > 0) {
      quizCard = quizCard
          .animate(key: ValueKey(quizState.shakeCount))
          .shake(duration: 400.ms, hz: 6, curve: Curves.easeInOut);
    }

    return quizCard
        .animate()
        .fade(duration: 500.ms, curve: Curves.easeOut)
        .slideY(begin: 0.1, end: 0.0, duration: 500.ms, curve: Curves.easeOut);
  }
}

class OptionCard extends StatefulWidget {
  final String text;
  final bool isSelected;
  final bool isCorrect;
  final VoidCallback onTap;
  final bool disabled;

  const OptionCard({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.isCorrect,
    required this.onTap,
    required this.disabled,
  }) : super(key: key);

  @override
  State<OptionCard> createState() => _OptionCardState();
}

class _OptionCardState extends State<OptionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.96,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Color cardBgColor = Colors.white;
    Color borderColor = Colors.grey.shade200;
    Color textColor = Colors.black87;

    if (widget.isSelected) {
      if (widget.isCorrect) {
        cardBgColor = const Color(0xFF5AC85A).withOpacity(0.12);
        borderColor = const Color(0xFF5AC85A);
        textColor = const Color(0xFF5AC85A);
      } else {
        cardBgColor = Colors.red.shade50;
        borderColor = Colors.red.shade300;
        textColor = Colors.red.shade800;
      }
    }

    return Semantics(
      label: "Answer option: ${widget.text}",
      button: true,
      enabled: !widget.disabled,
      child: GestureDetector(
        onTapDown: (_) => widget.disabled ? null : _controller.forward(),
        onTapUp: (_) {
          if (!widget.disabled) {
            _controller.reverse();
            widget.onTap();
          }
        },
        onTapCancel: () => widget.disabled ? null : _controller.reverse(),
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(vertical: 8),
            constraints: const BoxConstraints(minHeight: 56),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: cardBgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isSelected
                          ? borderColor
                          : Colors.grey.shade400,
                      width: 2.5,
                    ),
                    color: widget.isSelected ? borderColor : Colors.transparent,
                  ),
                  child: widget.isSelected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    widget.text,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
