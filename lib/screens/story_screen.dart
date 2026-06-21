import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audio_provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/buddy_section.dart';
import '../widgets/custom_button.dart';
import '../widgets/progress_indicator.dart';
import '../widgets/quiz_section.dart';
import '../widgets/story_card.dart';
import '../widgets/success_card.dart';

class StoryScreen extends ConsumerStatefulWidget {
  const StoryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends ConsumerState<StoryScreen> {
  late ConfettiController _confettiController;
  final String _storyText =
      "Once upon a time, a clever little robot named Pip lost his shiny blue gear in the Whispering Woods...";

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 6),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _handleStoryRead(AudioState audioState) {
    if (audioState == AudioState.error) {
      ref.read(audioProvider.notifier).reset();
      ref.read(quizProvider.notifier).resetQuiz();
      ref.read(audioProvider.notifier).speakStory(_storyText);
    } else {
      ref.read(audioProvider.notifier).speakStory(_storyText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final audioState = ref.watch(audioProvider);
    final quizState = ref.watch(quizProvider);

    ref.listen<QuizState>(quizProvider, (previous, next) {
      if (next.isCorrect == true && previous?.isCorrect != true) {
        _confettiController.play();
      }
    });

    final bool isQuizVisible =
        audioState == AudioState.completed || quizState.isCorrect == true;
    final bool isSuccess = quizState.isCorrect == true;

    String buttonText = "Read Me A Story";
    VoidCallback? buttonAction = () => _handleStoryRead(audioState);
    bool isButtonLoading = false;
    IconData? buttonIcon = Icons.volume_up_rounded;

    if (audioState == AudioState.preparing) {
      buttonText = "Preparing Story...";
      buttonAction = null;
      isButtonLoading = true;
      buttonIcon = null;
    } else if (audioState == AudioState.reading) {
      buttonText = "Story Time!";
      buttonAction = null;
      buttonIcon = null;
    } else if (audioState == AudioState.completed) {
      buttonText = "Story Completed";
      buttonAction = null;
      buttonIcon = Icons.check_rounded;
    } else if (audioState == AudioState.error) {
      buttonText = "Retry Narration";
      buttonAction = () => _handleStoryRead(audioState);
      buttonIcon = Icons.replay_rounded;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7E8),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  const PlayfulProgressIndicator(),
                  const SizedBox(height: 12),

                  const BuddySection(),

                  const StoryCard(),
                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: CustomButton(
                      text: buttonText,
                      onPressed: buttonAction,
                      isLoading: isButtonLoading,
                      icon: buttonIcon,
                      semanticLabel: buttonText,
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (isQuizVisible) ...[
                    const QuizSection(),
                    const SizedBox(height: 12),
                  ],

                  if (isSuccess) const SuccessCard(),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
                Colors.yellow,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
