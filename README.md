# AI Story Buddy

A Flutter-based interactive storytelling and quiz application built for the Peblo Flutter Developer Assessment.

## Framework Choice

Flutter was chosen for its fast development workflow, smooth animations, and cross-platform support.

## Audio to Quiz Transition

Once the narration finishes, the quiz is automatically revealed through state-driven UI updates.

## Data-Driven Quiz

The quiz is generated from JSON data rather than hardcoded UI elements, allowing different questions and option counts to be supported without UI changes.

## Caching Approach

The application uses the device's native TTS engine (`flutter_tts`), so audio caching is not required. If a remote TTS service were used, generated audio could be cached locally.

## Audio Loading and Failure Handling

A loading state is shown before narration begins. If narration fails, the user is shown a friendly retry option.

## Performance Profiling

Tested using Flutter DevTools and Performance Overlay.

Checked:

* Narration transitions
* Quiz reveal animation
* Wrong-answer feedback
* Confetti animation

Frame Timing Screenshot:

## Optimization for Mid-Range Android Devices

* Native device TTS
* Lightweight animations
* Minimal rebuilds through state management
* Offline-first functionality

## AI Usage & Judgment

AI tools were used for brainstorming, project structure, and implementation support.

One suggestion that was changed was moving quiz data into a dedicated data layer instead of keeping it inside the UI.

A challenge encountered during development was replaying the wrong-answer animation on every incorrect attempt, which was resolved using a state-driven animation trigger.
