# SharpCut Flutter (Class Project)

This project is simple:
- basic Flutter widgets
- Riverpod providers only where needed
- clean folder layout with clear responsibilities

## Folder Structure

```text
lib/
  core/
    config/            # Environment constants
    network/           # Dio client + API service
    router/            # Route names + GoRouter setup
    storage/           # Secure storage helpers
    shared_widgets/    # App-wide design tokens (colors)
    theme/             # Global ThemeData
  features/
    auth/
      data/models/     # Auth request/response models
      providers/       # Auth controller/provider
    booking/
      data/models/     # Appointment models
      providers/       # Booking + appointments providers
    services/
      data/models/     # Service model
      providers/       # Service list provider
  pages/               # App screens (beginner-friendly flat structure)
  shared/
    data/              # Demo seed data fallback for unfinished backend
    utils/             # Validators and simple helpers
    widgets/           # Reusable UI pieces (section headers, bottom navs)
```

## Widget Suggestions Per Page

- `login_page.dart`
  - `SingleChildScrollView`, `Card`, `Form`, `TextFormField`, `ElevatedButton`
- `services_page.dart`
  - `ListView.separated`, `Card`, `ChoiceChip`/badge, `NavigationBar`
- `booking_page.dart`
  - `ChoiceChip`, `Wrap`, `Card`, `ElevatedButton`, `SnackBar`
- `my_appointments_page.dart`
  - `ListView`, `Card`, small status badge container, `TextButton`
- `admin_dashboard_page.dart`
  - `Wrap` (metric cards), `Card`, `ListTile`, `NavigationBar`
- `manage_services_page.dart`
  - `ListView.separated`, `Card`, `TextButton`, `FloatingActionButton.extended`

## Beginner Rules For This Project

1. Keep each page readable: split complex UI into small private widgets inside the same file.
2. Prefer simple state (`StatefulWidget`) for local UI state and Riverpod providers for app data.
3. Use shared theme/colors first before adding custom per-page styling.
4. Keep TODO comments where backend integration is still pending.

## Run With Mock Backend (json-server)

From project root:

```bash
cd mock-api
npm install
npm start
```

In a second terminal (project root):

```bash
flutter pub get
flutter run
```

Quick login accounts:

- `admin@sharpcut.dev` / `password123`
- `client@sharpcut.dev` / `password123`

Any email containing `admin` is also accepted and created as admin automatically.
