# Patungan App

A Flutter mobile application for personal finance and budget tracking, built on the Patungan API.

## Features

- **Authentication** – Login, register, JWT with refresh token support
- **Dashboard** – Current balance, income/expense summary, quick stats
- **Transactions** – View, add, edit, delete transactions by month
- **Budget** – Overview, spending by category, carryover history
- **Reports** – Cash flow, income vs expense comparison, trend analysis
- **Summary** – Monthly and yearly financial summaries

## Architecture

```
MVC + Provider state management

lib/
├── core/
│   ├── constants/    # API URLs
│   ├── network/      # HTTP client
│   └── utils/        # Token storage, currency formatter
├── models/           # Data classes (auth, budget, summary, report, transaction)
├── services/         # API calls per domain
├── controllers/      # ChangeNotifier providers
└── views/            # UI screens per feature
```

## Setup

1. **Install dependencies**
   ```bash
   flutter pub get
   ```

2. **Configure API URL**  
   Edit `lib/core/constants/api_constants.dart`:
   ```dart
   static const String baseUrl = 'https://YOUR_API_HOST';
   ```
   > For local development on Android emulator use `https://10.0.2.2:7200`  
   > For iOS simulator use `https://localhost:7200`

3. **Run**
   ```bash
   flutter run
   ```

## Dependencies

| Package | Purpose |
|---|---|
| `provider` | State management |
| `http` | HTTP requests |
| `shared_preferences` | Token persistence |
| `intl` | Currency & date formatting |
| `fl_chart` | Charts (available for extension) |
