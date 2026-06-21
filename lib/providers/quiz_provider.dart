import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/quiz_data.dart';
import '../models/quiz_model.dart';

class QuizState {
  final QuizModel? quiz;
  final String? selectedAnswer;
  final bool? isCorrect;
  final int shakeCount;
  final String? feedbackMessage;

  const QuizState({
    this.quiz,
    this.selectedAnswer,
    this.isCorrect,
    this.shakeCount = 0,
    this.feedbackMessage,
  });

  QuizState copyWith({
    QuizModel? quiz,
    String? selectedAnswer,
    bool? isCorrect,
    int? shakeCount,
    String? feedbackMessage,
  }) {
    return QuizState(
      quiz: quiz ?? this.quiz,
      selectedAnswer: selectedAnswer ?? this.selectedAnswer,
      isCorrect: isCorrect ?? this.isCorrect,
      shakeCount: shakeCount ?? this.shakeCount,
      feedbackMessage: feedbackMessage ?? this.feedbackMessage,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier() : super(const QuizState()) {
    _loadQuiz();
  }

  void _loadQuiz() {
    try {
      final quizModel = QuizModel.fromJson(quizJson);
      state = state.copyWith(quiz: quizModel);
    } catch (e) {
      state = state.copyWith(
        feedbackMessage: "Error loading story challenge questions.",
      );
    }
  }

  void submitAnswer(String answer) {
    final currentQuiz = state.quiz;
    if (currentQuiz == null) return;
    if (state.isCorrect == true) return;

    if (answer.trim().toLowerCase() ==
        currentQuiz.answer.trim().toLowerCase()) {
      state = state.copyWith(
        selectedAnswer: answer,
        isCorrect: true,
        feedbackMessage: "Great Job!\nYou remembered the story perfectly.",
      );
    } else {
      HapticFeedback.vibrate();

      state = state.copyWith(
        selectedAnswer: answer,
        isCorrect: false,
        shakeCount: state.shakeCount + 1,
        feedbackMessage: "Oops! Pip says that's not quite right.\nTry again!",
      );
    }
  }

  void resetQuiz() {
    state = QuizState(quiz: state.quiz);
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
