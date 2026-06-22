# AI Story Buddy

A Flutter based interactive storytelling and quiz application built for the Peblo Flutter Developer Assessment.

## Framework Choice

I chose Flutter because I am familiar with it and it allows building smooth cross-platform applications efficiently.

## Audio to Quiz Transition

After the story narration is completed, the quiz is automatically shown to the user through state management.

## Data-Driven Quiz

The quiz is rendered from JSON data instead of hardcoded UI. This allows different questions and option counts to be displayed without changing the UI code.

## Caching Approach

The application uses the device's native TTS engine (`flutter_tts`), so audio caching is not required. If a remote TTS service were used, generated audio could be cached locally.

## Audio Loading and Failure Handling

A loading state is shown before narration starts. If narration fails, the user is shown a retry option.

## Performance Profiling

Performance was verified using Flutter DevTools and the Performance Overlay. Narration transitions, quiz reveal animations, wrong-answer feedback, and confetti animations were tested. Frame timings remained within the 60 FPS budget during normal usage.

### Frame Timing Screenshot
<img width="1918" height="1018" alt="Screenshot 2026-06-22 120743" src="https://github.com/user-attachments/assets/8d9aba5c-26b8-4f8a-9492-1fbe04ec016a" />


## Optimization for Mid-Range Android Devices

* Native device TTS
* Lightweight animations
* Minimal rebuilds through state management
* Offline-first functionality

## AI Usage & Judgment

AI tools were used for brainstorming, project structure, and implementation support.

One suggestion that was changed was moving quiz data into a dedicated data layer instead of keeping it inside the UI.

A challenge encountered during development was replaying the wrong answer animation on every incorrect attempt, which was resolved using a state driven animation trigger.
