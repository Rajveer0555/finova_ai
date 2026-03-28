<div align="center">
  <img src="assets/AppLogo.png" alt="Finova AI logo" width="100" />
  <h1>Finova AI</h1>
  <p><strong>AI-assisted expense tracking, budgeting, and short-term forecasting built with Flutter.</strong></p>
  <p>
    <img src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" alt="Flutter" />
    <img src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" alt="Dart" />
    <img src="https://img.shields.io/badge/Firebase-Auth%20%26%20Firestore-FFCA28?logo=firebase&logoColor=black" alt="Firebase" />
    <img src="https://img.shields.io/badge/Riverpod-State%20Management-4C6FFF" alt="Riverpod" />
    <img src="https://img.shields.io/badge/Supabase-Profile%20Storage-3ECF8E?logo=supabase&logoColor=white" alt="Supabase" />
  </p>
</div>

## Overview
Finova AI is a personal finance mobile app focused on making day-to-day money tracking simpler and more actionable. Users can log expenses, manage category budgets, review historical transactions, and get AI-driven insights plus short-term spending forecasts based on real transaction patterns.

The app is built with Flutter and uses Firebase for authentication and Firestore data storage, Riverpod for state management, and Supabase Storage for profile image handling.

## Preview
<img src="flutter_01.png" alt="Finova AI app preview" width="900" />

## What The App Does
- Tracks daily expenses with category, payment method, date, and notes.
- Supports email/password login and Google sign-in.
- Stores user data, budgets, and transaction history in Cloud Firestore.
- Lets users set monthly income and category-level budgets.
- Shows dashboard summaries, analytics, and transaction history.
- Generates AI Insights from recent spending behavior.
- Generates AI Prediction for the next 30 days using recent trends and older history.
- Includes profile editing with avatar upload support.

## AI Layer
The current AI implementation is a local forecasting and insight engine inside the app.

It currently uses:
- the last 30 days of transactions
- the previous 30 days for trend comparison
- older saved history to smooth predictions
- current category budgets and recorded monthly income

This powers:
- focus-category insights
- spending change analysis
- top spending factors
- 30-day spend prediction
- category-wise expected increase or decrease
- budget suggestions

Note: this is not yet an external LLM-backed assistant. The current AI is deterministic and data-driven inside the Flutter app, which keeps the experience fast and usable without requiring an extra backend AI service.

## Tech Stack
- Flutter
- Dart
- Flutter Riverpod
- Firebase Auth
- Cloud Firestore
- Google Sign-In
- Supabase Storage
- fl_chart
- shared_preferences
- image_picker

## Key Screens
- Onboarding
- Authentication
- Home dashboard
- AI Insights
- AI Prediction
- Analytics
- Transaction history
- Profile and budget management

## Project Structure
```text
lib/
  main.dart
  models/
  pages/
    ai_insights_screen.dart
    ai_prediction_screen.dart
    analytics.dart
    auth_screen.dart
    history_screen.dart
    home_screen.dart
    profileScreens/
  providers/
  services/
    finova_ai_engine.dart
  utils/
  widgets/
```

## Running Locally
### Prerequisites
- Flutter SDK
- Dart SDK
- Android Studio or VS Code
- Firebase project configured for Android/iOS
- Supabase project for profile image storage

### Setup
```bash
git clone <your-repo-url>
cd finova_ai
flutter pub get
flutter run
```

### Backend Notes
- Firebase is used for authentication and Firestore persistence.
- Supabase is used for profile image storage.
- If you are setting this up on a fresh backend, add your Firebase configuration files and update your Firestore rules.
- For a production/public portfolio version, it is better to move backend configuration to `--dart-define` or another secure config flow instead of keeping values directly in source.

## Testing
This repository includes focused tests for the AI forecasting engine.

```bash
flutter test
```

A GitHub Actions workflow is also included to run formatting, analysis, and tests on pushes and pull requests.

## Portfolio Highlights
Why this project is strong for a portfolio:
- Real product-style onboarding, auth, storage, and navigation flow.
- Non-trivial state management with Riverpod.
- Practical data modeling around budgets, analytics, and history.
- A custom in-app AI engine instead of only static UI mockups.
- Clean separation between pages, providers, services, and reusable widgets.

## Roadmap
- Add LLM-backed financial assistant/chat layer.
- Add recurring expense detection.
- Add export/report sharing.
- Add notifications and reminders.
- Add stronger automated widget/integration coverage.

## Status
Active personal project. Core expense tracking and forecasting flows are implemented, and the AI layer can be extended further with an external model-backed assistant in a future version.
