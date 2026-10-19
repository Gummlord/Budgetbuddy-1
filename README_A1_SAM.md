# BudgetBuddy — A1: Firebase + Auth + Integration (Sam)

## Setup (one time)

1. **Flutter project** (kung wala pa): `flutter create budgetbuddy`, tapos i-copy ang `lib/` at `firestore.rules` galing dito.
2. **Dependencies:**
   ```
   flutter pub add firebase_core firebase_auth cloud_firestore firebase_storage provider google_fonts image_picker flutter_local_notifications intl
   ```
   (Kasama na ang para kina A5/B-modules para isang pub get na lang ng buong team.)
3. **Firebase Console** → Create project → **Authentication → Sign-in method → Email/Password: Enable**.
4. **Firestore Database** → Create database → ilagay ang laman ng `firestore.rules` sa *Rules* tab → Publish.
5. (Optional) **Storage** → Get started (para sa receipt images ni A5).
6. **FlutterFire:**
   ```
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
   Gagawa ito ng `lib/firebase_options.dart` (DO NOT EDIT). I-commit ito sa GitHub para pareho ang Firebase project ng buong team.
7. `flutter run`

## Files (lib/)

| File | Ano ang laman |
|---|---|
| `main.dart` | Firebase init + MultiProvider + MaterialApp |
| `config/app_theme.dart` | `AppColors` (palette), `AppTextStyles` (35/25/20/14 px), `AppTheme.dark` |
| `config/app_routes.dart` | Route names + route map (may placeholders pa para sa ibang modules) |
| `config/constants.dart` | `kAppName`, `kDefaultPadding`, `kDefaultRadius`, collection names |
| `models/app_user.dart` | `AppUser` (uid, email, displayName, createdAt) |
| `services/auth_service.dart` | register, login, logout, authStateChanges |
| `services/database_service.dart` | `userRef`, `budgetsRef`, `expensesRef` |
| `providers/auth_provider.dart` | user state, loading, error |
| `features/auth/screens/` | `splash_screen` (AuthGate), `login_screen`, `register_screen` |
| `features/auth/widgets/` | `auth_text_field`, `auth_button`, `auth_layout` |
| `utils/validators.dart` | `validateEmail`, `validatePassword`, `validateAmount` |

## Firestore structure (para sa buong team)

```
users/{uid}                       -> AppUser profile
users/{uid}/budgets/{docId}       -> daily, weekly, monthly, updatedAt
users/{uid}/expenses/{expenseId}  -> name, amount, category, date, notes, receiptUrl, createdAt
```
Gamitin ng teammates ang `DatabaseService().budgetsRef(uid)` / `expensesRef(uid)`; kunin ang `uid` sa `context.read<AuthProvider>().user!.uid`.

## Paano mag-merge ng modules (end of project)

1. I-pull ang bawat branch/PR galing sa GitHub.
2. `main.dart` → i-uncomment/add ang providers nila (BudgetProvider, ExpenseProvider, SummaryProvider).
3. `config/app_routes.dart` → palitan ang `_PlaceholderScreen` ng totoong screen + import (may `TODO(merge)` markers).
4. Logout mula sa screen na naka-push: `Navigator.of(context).popUntil((r) => r.isFirst);` bago `logout()`.

## Notes

- Colors ay galing sa Figma palette (sampled sa screenshot) — i-double check ang exact hex kapag nailabas na ang Figma link.
- **Firestore vs Realtime Database:** ang requirements ay *Firestore*, pero ang folder standards (`database_service`) at B1 (`onValue`) ay Realtime DB. Firestore ang ginamit dito (may "user document" sa A1). Kung Realtime DB ang gusto ng team, `database_service.dart` at `auth_service.dart` lang ang papalitan.
