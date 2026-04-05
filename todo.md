# Flutter Frontend TODO (Class Project)

> Scope: Flutter frontend only (backend by Node.js team)
> Last updated: 2026-03-29
> Status: `[ ]` Not Started, `[~]` In Progress, `[x]` Done
> Goal: Ship a strong class project with clean code, core features, and basic testing.

## 1) Scope and Planning

- [ ] FE-001 Confirm MVP feature list (only what must demo in class).
- [ ] FE-002 Confirm target platform(s) for submission (`Android` only or `Android + Web`).
- [ ] FE-003 List all required screens and expected actions per screen.
- [ ] FE-004 Define user flow order (entry -> auth -> core features -> logout/exit).
- [ ] FE-005 Split work into milestone weeks with owners.

## 2) Backend Integration Plan (with Node.js Team)

- [ ] FE-101 Confirm base URL for local/dev backend.
- [ ] FE-102 Confirm auth flow (`login`, `register`, token usage).
- [ ] FE-103 Confirm endpoint list needed for frontend screens.
- [ ] FE-104 Confirm request/response field names for each endpoint.
- [ ] FE-105 Confirm standard error response format.
- [ ] FE-106 Create mock JSON responses for blocked endpoints.
- [ ] FE-107 Keep a shared API contract file in repo (`docs/api-contract.md` or OpenAPI link).

## 3) Flutter Foundation Setup

- [ ] FE-201 Remove counter template and create app shell.
- [ ] FE-202 Set app name and package identifiers.
- [ ] FE-203 Choose state management approach and stick to it.
- [ ] FE-204 Choose routing/navigation approach and stick to it.
- [ ] FE-205 Create clean folder structure (`core`, `features`, `shared`).
- [ ] FE-206 Add environment config for backend URL (`dev` at minimum).
- [ ] FE-207 Add reusable API service class (`GET`, `POST`, `PUT/PATCH`, `DELETE`).
- [ ] FE-208 Add common error handling for network/API failures.
- [ ] FE-209 Add loading/empty/error UI widgets reused across screens.

## 4) UI and UX Baseline

- [ ] FE-301 Define simple theme (colors, text styles, spacing).
- [ ] FE-302 Build reusable components (`PrimaryButton`, `AppTextField`, `AppCard`).
- [ ] FE-303 Ensure responsive layout for common phone sizes.
- [ ] FE-304 Add form validation messages (required fields, invalid input).
- [ ] FE-305 Add user feedback on actions (`SnackBar`/inline status).
- [ ] FE-306 Replace placeholder app icon/splash if required by rubric.

## 5) Core Feature Implementation

Use this checklist for each real feature in your project:

- [ ] FE-401 Create models from backend response.
- [ ] FE-402 Implement API/repository functions.
- [ ] FE-403 Build screen UI and connect to state.
- [ ] FE-404 Handle loading, success, empty, and error states.
- [ ] FE-405 Add create/edit/delete actions where needed.
- [ ] FE-406 Add navigation to and from this feature.
- [ ] FE-407 Add one unit/widget test for key behavior.

## 6) Minimum Security and Data Handling

- [ ] FE-501 Do not hardcode secrets/tokens in source files.
- [ ] FE-502 Store auth token safely (secure storage if auth is used).
- [ ] FE-503 Clear token on logout.
- [ ] FE-504 Validate/sanitize user input before API submission.

## 7) Testing and Code Quality (Class-Level)

- [ ] FE-601 Keep `flutter analyze` clean (no errors).
- [ ] FE-602 Keep formatting clean (`dart format .`).
- [ ] FE-603 Write unit tests for core logic/services.
- [ ] FE-604 Write widget tests for critical screens/forms.
- [ ] FE-605 Test main user flow manually on emulator/device before submission.
- [ ] FE-606 Update `.github/workflows/flutter.yml` only for essential checks (`pub get`, `analyze`, `test`).

## 8) Documentation and Submission Readiness

- [ ] FE-701 Expand `README.md` with setup and run steps.
- [ ] FE-702 Add architecture summary (state management + folder structure).
- [ ] FE-703 Add API integration notes and known limitations.
- [ ] FE-704 Add team contribution section (who did what).
- [ ] FE-705 Add demo script/checklist for final presentation.
- [ ] FE-706 Freeze scope 2-3 days before deadline (bug fixes only after freeze).

---

## Suggested Documentation Additions (For Class Project)

| Suggestion | Reason |
| --- | --- |
| Add one-page MVP scope section | Prevents adding extra features late and missing core requirements. |
| Add screen inventory table (`Screen`, `Purpose`, `API Used`) | Makes frontend planning and grading evidence clearer. |
| Add API endpoint quick reference | Reduces frontend-backend confusion during integration. |
| Add local setup steps (`flutter pub get`, `flutter run`) | New team members and graders can run the app quickly. |
| Add known limitations section | Shows transparency and helps explain scope decisions in presentation. |
| Add test checklist used before demo | Improves confidence that key flows work during live demo. |
