# MVP Flutter Starter Guide (Mentor Mode)

This guide is for your **2-day class project**: Flutter frontend + Node.js backend.  
Goal: give you a clean structure and starter templates so **you implement it yourselves**.

---

## Assumptions (So We Can Move Fast)

I could not directly parse your PDF contract files in this environment, so I am using practical appointment-booking assumptions from your shared UI screens:

- Roles: `client`, `admin` (admin/staff)
- Main entities: `User`, `Service`, `Appointment`, `TimeSlot`
- Core flows:
  - Client: login -> browse services -> book -> view my appointments
  - Admin: dashboard -> manage services -> view bookings

When your backend contract differs, keep this structure and only rename fields/endpoints.

---

## 1) Folder Structure (Simple + Real-World)

Use this structure in `lib/`:

```text
lib/
  main.dart

  core/
    config/
      env.dart
    network/
      dio_client.dart
      api_service.dart
      api_exception.dart
    router/
      app_router.dart
      route_names.dart
    storage/
      secure_storage_service.dart
    theme/
      app_theme.dart
    shared_widgets/
      app_colors.dart

  shared/
    widgets/
      app_scaffold.dart
      loading_view.dart
      error_view.dart
    utils/
      validators.dart
      date_time_formatter.dart

  features/
    auth/
      data/
        models/
          user_model.dart
          login_request_model.dart
          auth_response_model.dart
      presentation/
        pages/
          login_page.dart
      providers/
        auth_providers.dart

    services/
      data/
        models/
          service_model.dart
      presentation/
        pages/
          service_list_page.dart
          service_details_page.dart
      providers/
        services_providers.dart

    bookings/
      data/
        models/
          appointment_model.dart
          create_appointment_request_model.dart
          timeslot_model.dart
      presentation/
        pages/
          booking_page.dart
          my_appointments_page.dart
      providers/
        booking_providers.dart

    admin/
      presentation/
        pages/
          admin_dashboard_page.dart
          manage_services_page.dart
      providers/
        admin_providers.dart
```

### Responsibility of each layer

- `presentation/`: UI widgets/screens only
- `providers/`: state + calling API services
- `data/models/`: API request/response objects
- `core/network/`: Dio setup and centralized API methods
- `shared/`: reusable widgets/helpers used by many features

### Rule for your team

- UI code must not call Dio directly.
- UI asks providers.
- Providers call `ApiService`.
- `ApiService` returns models.

---

## 2) Dependencies Setup

### Required dependencies for MVP

1. `flutter_riverpod`
- Why: predictable state management; cleaner than passing state manually everywhere.

2. `go_router`
- Why: centralized routing and easier role-based navigation.

3. `dio`
- Why: strong HTTP client, interceptors, timeout, better error handling.

4. `flutter_secure_storage`
- Why: store auth token safely on device.

5. `intl` (recommended)
- Why: format booking dates/times clearly.

### Install commands

```bash
flutter pub add flutter_riverpod go_router dio flutter_secure_storage intl
flutter pub get
```

### Basic initialization templates

`main.dart` (minimal app bootstrap):

```dart
void main() {
  // TODO: Wrap app with ProviderScope for Riverpod
  runApp(const AppRoot());
}

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Read go_router instance from provider
    // TODO: Use app theme from core/theme/app_theme.dart
    return MaterialApp.router(
      // routerConfig: ...
    );
  }
}
```

`core/network/dio_client.dart`:

```dart
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // TODO: Replace with backend base URL
      baseUrl: 'http://YOUR_BACKEND_BASE_URL',
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // TODO: Add interceptor for auth token from secure storage
  // TODO: Add simple logging interceptor for debugging
  return dio;
});
```

---

## 3) Page Breakdown (Scaffold-Only Templates)

Build these pages first. Keep layout simple and functional.

### Client pages

#### `LoginPage`
- Purpose: authenticate and know user role.

```dart
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // TODO: Email field
            // TODO: Password field
            // TODO: Sign in button
            // TODO: Show validation / API error messages
          ],
        ),
      ),
    );
  }
}
```

#### `ServiceListPage`
- Purpose: show available services and allow booking entry.

```dart
class ServiceListPage extends ConsumerWidget {
  const ServiceListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Services')),
      body: Column(
        children: [
          // TODO: Search/filter area (optional for MVP)
          // TODO: Display list of services from API
          // TODO: Tap item -> open service details or booking page
        ],
      ),
    );
  }
}
```

#### `BookingPage`
- Purpose: select slot and create appointment.

```dart
class BookingPage extends ConsumerWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: Column(
        children: [
          // TODO: Selected service summary
          // TODO: Date picker / slot picker
          // TODO: Confirm booking button
        ],
      ),
    );
  }
}
```

#### `MyAppointmentsPage`
- Purpose: show upcoming/past bookings and status.

```dart
class MyAppointmentsPage extends ConsumerWidget {
  const MyAppointmentsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Appointments')),
      body: Column(
        children: [
          // TODO: Tabs/filters (Upcoming, Past, Cancelled)
          // TODO: Display appointments from API
          // TODO: Empty state UI when no appointments
        ],
      ),
    );
  }
}
```

### Admin pages

#### `AdminDashboardPage`
- Purpose: quick stats and today's schedule.

```dart
class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: Column(
        children: [
          // TODO: Stats cards (today bookings, revenue, etc.)
          // TODO: Today's appointments list
        ],
      ),
    );
  }
}
```

#### `ManageServicesPage`
- Purpose: admin adds/updates/deletes services.

```dart
class ManageServicesPage extends ConsumerWidget {
  const ManageServicesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Services')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Open add service form
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // TODO: Display admin's services
          // TODO: Edit/Delete actions
        ],
      ),
    );
  }
}
```

---

## 4) Models (Keep Simple, Match Backend Names)

Below are starter DTOs. Replace field names to match contract exactly.

### `user_model.dart`

```dart
class UserModel {
  // Unique user identifier from backend
  final String id;

  // Display name shown in UI
  final String fullName;

  // Login email
  final String email;

  // Role used for route decisions: client | admin
  final String role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'role': role,
    };
  }
}
```

### `service_model.dart`

```dart
class ServiceModel {
  // Service identifier
  final String id;

  // Name shown in list and detail screen
  final String name;

  // Short description of service
  final String description;

  // Price in your backend currency format
  final double price;

  // Duration in minutes for scheduling
  final int durationMinutes;

  ServiceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.durationMinutes,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      durationMinutes: json['durationMinutes'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'durationMinutes': durationMinutes,
    };
  }
}
```

### `appointment_model.dart`

```dart
class AppointmentModel {
  // Appointment identifier
  final String id;

  // Linked service id
  final String serviceId;

  // Client who created appointment
  final String clientId;

  // Admin assigned to appointment
  final String adminId;

  // Start time in ISO string format
  final DateTime startTime;

  // End time in ISO string format
  final DateTime endTime;

  // Status: pending | confirmed | cancelled | completed
  final String status;

  AppointmentModel({
    required this.id,
    required this.serviceId,
    required this.clientId,
    required this.adminId,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id'] as String,
      serviceId: json['serviceId'] as String,
      clientId: json['clientId'] as String,
      adminId: json['adminId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceId': serviceId,
      'clientId': clientId,
      'adminId': adminId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'status': status,
    };
  }
}
```

### `create_appointment_request_model.dart`

```dart
class CreateAppointmentRequestModel {
  // Service selected by client
  final String serviceId;

  // Admin selected for appointment
  final String adminId;

  // Desired slot start time
  final DateTime startTime;

  CreateAppointmentRequestModel({
    required this.serviceId,
    required this.adminId,
    required this.startTime,
  });

  Map<String, dynamic> toJson() {
    return {
      'serviceId': serviceId,
      'adminId': adminId,
      'startTime': startTime.toIso8601String(),
    };
  }
}
```

---

## 5) API Layer Structure (Dio)

`core/network/api_service.dart`:

```dart
class ApiService {
  final Dio _dio;

  ApiService(this._dio);

  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    // TODO: Call backend endpoint (example: POST /auth/login)
    // TODO: Parse response into AuthResponseModel
    throw UnimplementedError();
  }

  Future<List<ServiceModel>> fetchServices() async {
    // TODO: Call backend endpoint (example: GET /services)
    // TODO: Parse list response into List<ServiceModel>
    throw UnimplementedError();
  }

  Future<AppointmentModel> createAppointment(
    CreateAppointmentRequestModel request,
  ) async {
    // TODO: Call backend endpoint (example: POST /appointments)
    // TODO: Parse response into AppointmentModel
    throw UnimplementedError();
  }

  Future<List<AppointmentModel>> fetchMyAppointments() async {
    // TODO: Call backend endpoint (example: GET /appointments/me)
    // TODO: Parse response list
    throw UnimplementedError();
  }
}
```

Provider wiring:

```dart
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});
```

---

## 6) State Management (Riverpod, MVP Style)

Keep it simple:

- `authProvider`: handles login/logout state
- `servicesProvider`: loads list of services
- `appointmentsProvider`: loads current user appointments

`auth_providers.dart` (starter):

```dart
final authProvider = StateNotifierProvider<AuthController, AsyncValue<UserModel?>>(
  (ref) => AuthController(ref.read(apiServiceProvider)),
);

class AuthController extends StateNotifier<AsyncValue<UserModel?>> {
  final ApiService _api;

  AuthController(this._api) : super(const AsyncValue.data(null));

  Future<void> login(String email, String password) async {
    // TODO: set state loading
    // TODO: call _api.login(...)
    // TODO: save token in secure storage
    // TODO: set state with current user
  }

  Future<void> logout() async {
    // TODO: clear secure storage token
    // TODO: reset state to null user
  }
}
```

`services_providers.dart` (starter):

```dart
final servicesProvider = FutureProvider<List<ServiceModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  // TODO: return api.fetchServices();
  throw UnimplementedError();
});
```

`booking_providers.dart` (starter):

```dart
final appointmentsProvider = FutureProvider<List<AppointmentModel>>((ref) async {
  final api = ref.read(apiServiceProvider);
  // TODO: return api.fetchMyAppointments();
  throw UnimplementedError();
});
```

---

## 7) Navigation (go_router + Role-Based Flow)

### Route list

- Public:
  - `/login`
- Client:
  - `/client/services`
  - `/client/booking`
  - `/client/appointments`
- Admin:
  - `/admin/dashboard`
  - `/admin/manage-services`

### Router skeleton

```dart
final appRouterProvider = Provider<GoRouter>((ref) {
  // TODO: read auth state from authProvider
  // TODO: use redirect based on login state + role
  return GoRouter(
    initialLocation: '/login',
    routes: [
      // TODO: Add GoRoute entries for each page
    ],
    redirect: (context, state) {
      // TODO: If not logged in -> /login
      // TODO: If logged in as client -> allow only /client/*
      // TODO: If logged in as admin -> allow only /admin/*
      return null;
    },
  );
});
```

### Role navigation decision

After successful login:

- If role is `client`, navigate to `/client/services`
- If role is `admin`, navigate to `/admin/dashboard`

---

## 8) Two-Day Execution Plan (Practical)

### Day 1

1. Finalize folder structure
2. Install dependencies
3. Configure `main.dart` with `ProviderScope` + router
4. Create model files (with exact API field names)
5. Build page scaffolds only

### Day 2

1. Implement `login`, `fetchServices`, `createAppointment` in `ApiService`
2. Connect providers to pages
3. Add loading/error UI states
4. Validate booking flow end-to-end
5. Polish theme + spacing using your `app_theme.dart`

---

## 9) What Not To Do (For This MVP)

1. Do not add complex architecture layers you cannot finish in 2 days.
2. Do not build every nice-to-have screen.
3. Do not duplicate API logic inside widgets.
4. Do not skip role-based routing checks.
5. Do not leave model field names mismatched with backend.

---

## 10) Immediate Next Action for Your Team

1. Open this guide and create missing folders/files first.
2. Put exact backend contract field names into the model templates.
3. Implement only these three API methods first:
   - `login()`
   - `fetchServices()`
   - `createAppointment()`
4. Demo one complete path:
   - login -> services -> booking -> my appointments

