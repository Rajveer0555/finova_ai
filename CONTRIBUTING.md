# Contributing
Thanks for taking the time to contribute to Finova AI.

## Development Setup
```bash
flutter pub get
flutter test
flutter analyze lib test
```

## Guidelines
- Keep UI and behavior consistent with the existing product direction unless the change explicitly requires redesign.
- Prefer small, focused pull requests.
- Add or update tests when changing forecasting or business logic.
- Keep Firebase and Supabase-related changes clearly documented in the PR description.

## Pull Request Checklist
- The app builds locally.
- Tests were added or updated when needed.
- No unrelated files were changed.
- README or docs were updated if behavior changed.
