# AI Story Buddy

AI Story Buddy is a polished, child-friendly, offline-first Flutter application designed as an educational hiring assessment. It features a friendly AI Buddy (Pip the Robot) that narrates stories to kids, engages them in story comprehension challenges with real-time feedback, and celebrates their success with rich animations.

---

## 🚀 Project Overview

The app is built as a single-screen interactive learning flow:
1. **Pip the Robot (AI Buddy)** welcomes the child and indicates his status with playful animations (floating, talking, pulsing glows).
2. **Story Card** contains the story text.
3. **Narration Control** triggers text-to-speech with simulated preparation delays and states.
4. **Interactive Quiz** dynamically renders options from JSON, animating into view only upon narration completion.
5. **Success Feedback** displays a custom celebration card and launches a confetti explosion when the correct answer is selected.

---

## 🛠️ Tech Stack & Architecture

- **Flutter (Latest Stable)**: Multi-platform support, smooth 60fps rendering, and custom vector fallback drawing.
- **Riverpod**: Centralized reactive state management, using `StateNotifier` to enforce strict unidirectional data flow.
- **flutter_tts**: Native text-to-speech engine wrapper configured with child-friendly pitch and speech speed.
- **flutter_animate**: Lightweight, declarative widget animations (floating, glow pulses, shake feedback, scale transitions).
- **confetti**: Playful particle physics system for celebration.
- **google_fonts (Poppins)**: Readable, child-friendly premium typography.

---

## 📐 Architecture & Data Flow

```
lib/
├── main.dart
├── data/
│   └── quiz_data.dart        # Mock JSON data mimicking backend response
├── models/
│   └── quiz_model.dart       # De-serialized QuizModel
├── services/
│   └── tts_service.dart      # Native flutter_tts engine interface
├── providers/
│   ├── audio_provider.dart   # AudioState: idle -> preparing -> reading -> completed
│   └── quiz_provider.dart    # QuizState: answer submit, shake feedback, haptics
├── screens/
│   └── story_screen.dart     # Layout assembly with confetti & state listeners
└── widgets/
    ├── buddy_section.dart    # Pip character & animated speech bubbles
    ├── story_card.dart       # Title and text holder
    ├── quiz_section.dart     # Interactive option cards & shake trigger
    ├── success_card.dart     # Celebration badge
    ├── progress_indicator.dart # State-driven playful badges
    └── custom_button.dart    # Accessible, scale-on-tap primary button
```

---

## 🎨 Design System

- **Background**: `Color(0xFFFFF7E8)` (Warm vanilla tone)
- **Primary Color**: `Color(0xFFFF8A00)` (Vibrant orange for buttons/accents)
- **Secondary Color**: `Color(0xFFFFB84D)` (Soft yellow-orange for badges/highlights)
- **Success Color**: `Color(0xFF5AC85A)` (Bright green for correct state)
- **Card Design**: Pure white with high-contrast borders and subtle shadows to mimic cardboard toys.
- **Border Radius**: Consistent `20` to `24` dp for kid-friendly rounded aesthetics.

---

## 🔍 Engineering & Design Decisions

### 1. State Management Approach
We chose **Riverpod** over raw Statefulness or Bloc because of its compile-time safety, dependency injection capability, and performance optimization.
- **Audio State Provider**: Manages the exact state of the TTS engine (`idle`, `preparing`, `reading`, `completed`, `error`). The UI listens to this state to block double-narration actions and automatically reveal the quiz.
- **Quiz Provider**: Keeps track of selection states, correct answers, and shake triggers.
- This decoupling ensures that widgets only rebuild when their observed state changes.

### 2. Audio Flow Explanation
Narration follows a strict flow:
```
[Idle] ➔ Press "Read Me A Story" ➔ [Preparing Story] (1.2s delay) ➔ [Reading Story] ➔ [Completed] (Triggers Quiz Reveal)
```
- **Overlap Prevention**: The "Read Me A Story" button is fully disabled during the `preparing` and `reading` states to prevent concurrent TTS sessions.
- **Audio Disposal**: The `TtsService` cleans up native handler callbacks and stops the device audio channel on widget disposal, eliminating memory leaks and dangling hardware locks.

### 3. Data-Driven Quiz Architecture
The quiz structure is fully data-driven. The quiz UI parses raw JSON from `lib/data/quiz_data.dart` into a `QuizModel`.
- Options are built dynamically via `ListView.builder`.
- Zero UI elements are hardcoded; the layouts automatically expand and scale for quizzes with 3, 4, or 5 options without writing code.

### 4. Error Handling Strategy
The native TTS engine can fail due to device-specific issues (missing voices, service interruptions).
- All calls to `flutter_tts` are wrapped in `try/catch` blocks.
- On failure, state updates to `AudioState.error`.
- The Buddy changes to a concern expression showing: *"Oops! I couldn't read the story. Let's try again."*
- A dedicated **Retry Narration** button is displayed. Clicking it resets the provider and initiates the prep sequence from scratch. The app never crashes or hangs.

### 5. Caching Strategy
- **Current Approach**: The native `flutter_tts` engine uses the device's built-in text-to-speech synthesizer, meaning audio files are synthesized in real-time. Therefore, **no local audio caching is required** for online/offline TTS generation.
- **Future Scale-Out Approach**: If transitioning to custom cloud TTS API engines (e.g., Google Cloud TTS or Amazon Polly), we would cache generated MP3 audio files on the local filesystem. This would use `path_provider` to locate the documents directory and write bytes, preventing redownloads and ensuring offline functionality after the first download.

### 6. Performance Optimizations
To ensure 60fps rendering on mid-range Android devices (~3GB RAM):
- **`const` Constructors**: Extensively utilized to bypass widget rebuilding when parent rebuilds occur.
- **Riverpod `select`**: Widgets listen only to specific fields (e.g., `ref.watch(quizProvider.select((s) => s.shakeCount))`), ignoring other fields.
- **Lightweight Animations**: Instead of heavy custom tickers or Lottie JSONs, animations are composed of simple scale, slide, and fade transitions using `flutter_animate`, which leverages the underlying Flutter rendering framework.

### 7. Accessibility (A11y)
- **Min Touch Targets**: All interactive elements (Custom buttons, option cards, retry actions) maintain a height/width of at least `52` dp (exceeding the standard `48x48` px guidelines).
- **Semantic Mapping**: Elements are wrapped in `Semantics` tags specifying their role (e.g., buttons, header text, card wrappers) for screen readers.
- **Visual Contrast**: Large font weights, high contrast borders, and soft high-contrast background highlights.

### 8. Offline-First Execution
The application depends entirely on `flutter_tts` and local asset files. It contains no network calls, database calls, or external APIs, ensuring it remains fully functional in airplane mode.

---

## 📈 Performance Profiling

### Verification Methods
1. **Flutter DevTools**: Monitored GPU and UI thread usage during operations. GPU and UI thread timings remained well within the green zone (less than 16ms per frame).
2. **Performance Overlay**: Enabled during compilation verification to ensure no red frame bars appeared during animation transitions.
3. **Frame Timing**: Verified key transition boundaries:
   - Story narration initiation.
   - Quiz card slide-in transition.
   - Shake feedback animation on incorrect answer.
   - Confetti particle calculation and rendering.

### Performance Screenshots

[Insert Flutter DevTools Screenshot]

[Insert Performance Overlay Screenshot]

---

## 🤖 AI Usage Reflection

### Where AI was used
- Brainstorming the kid-friendly Material 3 theme colors.
- Designing the custom vector fallback widget (`_RobotVectorPlaceholder`) using native drawing classes when the local image asset isn't present.
- Architectural layout of the Riverpod provider lifecycle management.

### AI Suggestion Rejected
- **Suggestion**: Use a complex JSON configuration specifying animation curve parameters directly from the backend data layer.
- **Reasoning**: This would violate separation of concerns. Animation configurations should belong exclusively to the UI presentation layer. Keeping them in the JSON payload would increase data deserialization overhead and degrade the maintainability of the codebase.

---

## 📂 Asset Placement

The AI Buddy reads the local assets folder. To add the real robot asset:
1. Create a folder named `assets/images` at the root of the project.
2. Put your character image named `robot.png` inside `assets/images/`.
3. Verify that the asset entry is declared in your `pubspec.yaml` (which is already registered as `- assets/images/`).
4. Re-run `flutter pub get` and build the application.
