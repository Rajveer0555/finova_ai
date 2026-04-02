# Finova AI Functions

This folder contains Firebase Cloud Functions for server-side AI push alerts.

## What it does

- Reads each user's saved `fcmToken`
- Checks `notificationSettings.pushEnabled`
- Checks `aiEnabled`
- Analyses recent transactions from `users/{uid}/transactions`
- Sends AI push notifications for:
  - strong category spending increase
  - likely category budget risk next month
  - next-month total forecast above income

## Deploy

1. Install the Firebase CLI.
2. Log in with `firebase login`.
3. Set your Firebase project with `firebase use <your-project-id>`.
4. Install function dependencies from the `functions` folder.
5. Deploy with `firebase deploy --only functions`.

## Scheduled job

- `sendAiInsightAlerts`
- Runs daily at `8:45 PM` in `Asia/Kolkata`
- Region: `asia-south1`

## Data expected

User document fields:
- `fcmToken`
- `aiEnabled`
- `monthlyIncome`
- `budgets`
- `notificationSettings.pushEnabled`

Transaction fields:
- `title`
- `category`
- `amount`
- `date`
