# Flutter Development Guide (Class Project)

Last updated: 2026-03-29  
Project context: Flutter frontend + Node.js backend  
Audience: Beginners learning Flutter while building a real team project

---

## 1) Recommended Project Scope

Keep this project strong but realistic for class delivery.

### MVP pages to build first

1. `HomePage`
2. `ServicesPage` (list of services/items)
3. `ServiceDetailsPage` (single item details)
4. `ContactPage` (form submission)
5. `AboutPage`
6. `NotFoundPage` (for bad routes)

### Optional pages (only if time allows)

1. `SplashPage` (branding + initialization)
2. `LoginPage` and `RegisterPage`
3. `ProfilePage`
4. `SettingsPage`

You already created:
- `lib/pages/home_page.dart`
- `lib/pages/services_page.dart`
- `lib/pages/contact_page.dart`
- `lib/pages/about_page.dart`

Good next step is to complete those 4 first, then add `ServiceDetailsPage`.

---

## 2) What Each Page Should Contain

### `HomePage`

- Purpose: first impression + quick navigation.
- Suggested sections:
  - Hero/title area
  - Short project/service intro
  - Top services preview (3-5 cards)
  - Primary actions (View Services, Contact Us)
- Backend needs:
  - Optional featured services endpoint
- States to handle:
  - Loading
  - Empty (no featured services)
  - Error + retry

### `ServicesPage`

- Purpose: browse all available services/items.
- Suggested sections:
  - Search bar
  - Category/filter chips (optional)
  - Paginated or scroll list of service cards
- Backend needs:
  - Get services list
  - Optional query params: search, filter, page
- States to handle:
  - Loading
  - Empty results
  - Network error

### `ServiceDetailsPage`

- Purpose: show full info for a selected service/item.
- Suggested sections:
  - Main image
  - Title and description
  - Price/rate (if applicable)
  - Contact/Book action
- Backend needs:
  - Get service by id
- States to handle:
  - Loading
  - Item not found
  - Error + back action

### `ContactPage`

- Purpose: let user send inquiry/feedback.
- Suggested fields:
  - Name
  - Email
  - Phone (optional)
  - Message
- Backend needs:
  - Submit contact form endpoint
- Validation needed:
  - Required fields
  - Email format
  - Minimum message length
- UX needed:
  - Disabled submit while sending
  - Success confirmation
  - Friendly error message

### `AboutPage`

- Purpose: who you are + what the project does.
- Suggested sections:
  - Team mission
  - What problem you solve
  - Team members (optional)
  - Social/contact links (optional)
- Backend needs:
  - Usually none (can be static)

### `NotFoundPage`

- Purpose: handle broken links/routes.
- Should include:
  - Simple error message
  - Button to return home

---

## 3) Recommended Dependency Stack (Class Friendly)

Use this minimal stack. It is beginner-friendly and enough for clean architecture.

### Core dependencies

1. `go_router`
- Why: clean navigation/routing and easy deep-link style route management.
- Install: `flutter pub add go_router`
- Use it for: central route table and named navigation.

2. `flutter_riverpod`
- Why: predictable state management with less hidden behavior than `setState` everywhere.
- Install: `flutter pub add flutter_riverpod`
- Use it for: page state, API loading state, shared app state.

3. `dio`
- Why: robust HTTP client with interceptors, timeout control, and cleaner error handling.
- Install: `flutter pub add dio`
- Use it for: all backend communication.

4. `flutter_secure_storage`
- Why: secure local storage for auth tokens.
- Install: `flutter pub add flutter_secure_storage`
- Use it for: storing access token and clearing it on logout.

5. `intl`
- Why: formatting dates, times, and numbers in a clean way.
- Install: `flutter pub add intl`
- Use it for: user-facing date/time and currency formatting.

6. `url_launcher`
- Why: open email, phone dialer, or external links.
- Install: `flutter pub add url_launcher`
- Use it for: contact actions from About or Contact pages.

7. `cached_network_image` (optional but useful)
- Why: smooth image loading with caching and placeholders.
- Install: `flutter pub add cached_network_image`
- Use it for: service images from backend URLs.

### Model and serialization dependencies

8. `json_annotation`
- Why: standard annotations for generated JSON model mapping.
- Install: `flutter pub add json_annotation`

9. `json_serializable` (dev dependency)
- Why: auto-generates model parsing to reduce manual bugs.
- Install: `flutter pub add --dev json_serializable`

10. `build_runner` (dev dependency)
- Why: runs code generation for models.
- Install: `flutter pub add --dev build_runner`

### Testing dependencies

11. `mocktail` (dev dependency)
- Why: easier mocking for unit tests.
- Install: `flutter pub add --dev mocktail`

---

## 4) Dependency Installation Order

Run these in this order:

1. `flutter pub add go_router flutter_riverpod dio flutter_secure_storage intl url_launcher`
2. `flutter pub add cached_network_image`
3. `flutter pub add json_annotation`
4. `flutter pub add --dev build_runner json_serializable mocktail`
5. `flutter pub get`

When model generation is needed:

- `dart run build_runner build --delete-conflicting-outputs`

When model files are changed frequently during development:

- `dart run build_runner watch --delete-conflicting-outputs`

---

## 5) How to Use Each Dependency (No-Code Workflow)

### `go_router` workflow

1. Create one central route file.
2. Define all page routes in one place.
3. Use named routes instead of hardcoded path strings across files.
4. Add unknown-route fallback to `NotFoundPage`.

### `flutter_riverpod` workflow

1. Create feature-level state providers.
2. Keep API calls outside widgets (service/repository layer).
3. Widgets read provider state and display loading/error/data UI.
4. Avoid mixing business logic directly inside page widgets.

### `dio` workflow

1. Create one configured HTTP client with base URL and timeout.
2. Add request/response interceptors for logging during development.
3. Centralize API error mapping into user-friendly messages.
4. Do not call backend directly from page widgets.

### `flutter_secure_storage` workflow

1. Save token after successful login.
2. Read token when app starts.
3. Attach token to API headers (through `dio` interceptor).
4. Delete token on logout or auth failure.

### `json_serializable` workflow

1. Create model classes based on backend JSON contracts.
2. Run generator after model changes.
3. Keep model naming aligned with backend keys.
4. Regenerate files before pushing code to avoid CI failures.

### `mocktail` workflow

1. Mock repository or API layer, not UI widgets.
2. Write tests for success, failure, and empty responses.
3. Use widget tests only for key flows and forms.

---

## 6) Suggested Folder Structure

Use this structure to keep project easy to understand:

- `lib/main.dart` -> app entry
- `lib/app/` -> app-level setup
- `lib/app/router/` -> routing config
- `lib/core/config/` -> environment config and constants
- `lib/core/network/` -> API client and network error mapping
- `lib/core/storage/` -> secure/local storage service
- `lib/shared/widgets/` -> reusable UI components
- `lib/shared/theme/` -> colors, text styles, spacing
- `lib/features/home/` -> home feature files
- `lib/features/services/` -> services list + details
- `lib/features/contact/` -> contact form flow
- `lib/features/about/` -> about content
- `lib/features/auth/` -> login/register (if needed)

Inside each feature folder:

- `data/` -> models, remote data source, repository implementation
- `domain/` -> entities/use-cases (lightweight for class project)
- `presentation/` -> pages, providers, widgets

---

## 7) Backend Contract Checklist (Before UI Implementation)

For each endpoint, confirm:

1. URL path and HTTP method
2. Required headers
3. Request body fields and types
4. Success response shape
5. Error response shape
6. Which fields are nullable
7. Example request and response payload

Minimum backend endpoints to request from Node.js team:

1. `GET /services`
2. `GET /services/{id}`
3. `POST /contact`
4. `POST /auth/login` (if auth is part of MVP)
5. `POST /auth/register` (if auth is part of MVP)

---

## 8) Step-by-Step Build Plan (Execution Order)

### Phase 1: Foundation

1. Clean template app.
2. Configure theme and routing.
3. Add dependency stack.
4. Set folder structure.

### Phase 2: Static UI

1. Build Home, Services, Contact, About with static data.
2. Finalize navigation flow between pages.
3. Make UI responsive on small/medium phones.

### Phase 3: Backend Integration

1. Connect Services list and details to API.
2. Connect Contact form submission.
3. Add loading/empty/error handling on each connected page.

### Phase 4: Quality Pass

1. Add form validation and user feedback states.
2. Add tests for core services and key widgets.
3. Run `flutter analyze`, `dart format .`, `flutter test`.
4. Fix final bugs and freeze scope.

---

## 9) Common Mistakes to Avoid

1. Calling API directly inside widget build methods.
2. Mixing route names and literal paths across files.
3. Starting all pages at once before finishing one complete flow.
4. Ignoring loading and error states until the end.
5. Hardcoding backend URLs in many places.
6. Skipping basic tests for forms and API mapping.

---

## 10) Definition of Done (Per Feature)

A feature is considered done only when all are true:

1. UI is complete and navigable.
2. Backend integration works for success and failure cases.
3. Loading, empty, and error states are visible and usable.
4. Basic validation exists for user inputs.
5. At least one test covers the feature's key behavior.
6. README/API notes updated if behavior changed.

---

## 11) Quick Commands Reference

- Install dependencies: `flutter pub get`
- Run app: `flutter run`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Test: `flutter test`
- Build Android APK: `flutter build apk`
- Build web (if needed): `flutter build web`

