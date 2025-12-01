# Architecture Documentation

This document explains the architecture and design decisions of the CargoPro Flutter application.

## 🏗 Architecture Overview

The app follows a **Clean Architecture** pattern with clear separation of concerns, using **GetX** for state management, navigation, and dependency injection.

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Views/Screens - UI Components)        │
└─────────────────────────────────────────┘
                  ↓ ↑
┌─────────────────────────────────────────┐
│          Controller Layer               │
│  (Business Logic & State Management)    │
└─────────────────────────────────────────┘
                  ↓ ↑
┌─────────────────────────────────────────┐
│           Service Layer                 │
│  (API Calls, Firebase Auth, etc.)       │
└─────────────────────────────────────────┘
                  ↓ ↑
┌─────────────────────────────────────────┐
│            Model Layer                  │
│  (Data Models & Entities)               │
└─────────────────────────────────────────┘
```

## 📁 Folder Structure

```
lib/
├── main.dart                    # Entry point, app initialization
│
├── routes/                      # Navigation configuration
│   ├── app_routes.dart         # Route name constants
│   └── app_pages.dart          # Route & binding configuration
│
├── models/                      # Data models
│   └── api_object_model.dart   # API object model with JSON serialization
│
├── controllers/                 # Business logic & state
│   ├── auth_controller.dart    # Authentication logic
│   └── object_controller.dart  # CRUD operations logic
│
├── views/                       # UI components
│   ├── auth/                   # Authentication screens
│   │   ├── login_screen.dart
│   │   └── otp_screen.dart
│   └── home/                   # Main application screens
│       ├── home_screen.dart
│       ├── object_list_screen.dart
│       ├── object_detail_screen.dart
│       ├── create_object_screen.dart
│       └── edit_object_screen.dart
│
├── services/                    # External service integrations
│   ├── auth_service.dart       # Firebase authentication
│   └── api_service.dart        # REST API client
│
├── utils/                       # Utilities & helpers
│   ├── theme.dart              # App theme configuration
│   ├── constants.dart          # App constants
│   └── validators.dart         # Input validation
│
└── bindings/                    # Dependency injection
    ├── auth_binding.dart       # Auth dependencies
    └── home_binding.dart       # Home dependencies
```

## 🎯 Design Patterns

### 1. MVC with GetX

**Model-View-Controller** pattern enhanced with GetX reactive programming:

- **Model**: Data classes (e.g., `ApiObject`)
- **View**: UI widgets (screens)
- **Controller**: Business logic and state management

**Example Flow:**
```
User taps button → View calls Controller method
                 ↓
Controller processes logic → Updates observable state
                 ↓
View automatically rebuilds → UI updates
```

### 2. Repository Pattern

Services act as repositories, abstracting data sources:

- `ApiService`: Repository for REST API
- `AuthService`: Repository for Firebase Auth

**Benefits:**
- Easy to test (mock services)
- Easy to swap implementations
- Centralized data access logic

### 3. Dependency Injection

GetX provides DI through bindings:

```dart
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiService>(() => ApiService());
    Get.lazyPut<ObjectController>(() => ObjectController());
  }
}
```

**Benefits:**
- Loose coupling
- Easy testing
- Lazy initialization

### 4. Reactive Programming

GetX reactive state management:

```dart
// In Controller
final RxList<ApiObject> objects = <ApiObject>[].obs;

// In View
Obx(() => ListView.builder(
  itemCount: controller.objects.length,
  ...
))
```

**Benefits:**
- Minimal boilerplate
- Automatic UI updates
- Performance optimized

## 🔄 Data Flow

### Authentication Flow

```
1. User enters phone number
   ↓
2. LoginScreen → AuthController.sendOtp()
   ↓
3. AuthController → AuthService.sendOtp()
   ↓
4. AuthService → Firebase Auth API
   ↓
5. Firebase sends SMS with OTP
   ↓
6. User enters OTP
   ↓
7. OtpScreen → AuthController.verifyOtp()
   ↓
8. AuthController → AuthService.verifyOtp()
   ↓
9. AuthService → Firebase Auth API
   ↓
10. Firebase verifies OTP
   ↓
11. AuthService updates auth state
   ↓
12. App navigates to HomeScreen
```

### CRUD Flow (Example: Create Object)

```
1. User fills form in CreateObjectScreen
   ↓
2. User taps "Create"
   ↓
3. View calls ObjectController.createObject()
   ↓
4. Controller validates form
   ↓
5. Controller creates ApiObject model
   ↓
6. Controller calls ApiService.createObject()
   ↓
7. ApiService makes POST request
   ↓
8. API returns created object
   ↓
9. ApiService parses JSON → ApiObject
   ↓
10. Controller adds to objects list
   ↓
11. View auto-updates (Obx)
   ↓
12. Controller shows success message
   ↓
13. App navigates back to list
```

## 🧩 Key Components

### 1. Models

**Purpose:** Data representation and serialization

```dart
class ApiObject {
  final String? id;
  final String name;
  final Map<String, dynamic>? data;
  
  // Serialization
  factory ApiObject.fromJson(Map<String, dynamic> json);
  Map<String, dynamic> toJson();
  
  // Helpers
  String getDataSummary();
  ApiObject copyWith({...});
}
```

**Responsibilities:**
- Data structure definition
- JSON serialization/deserialization
- Data manipulation helpers

### 2. Controllers

**Purpose:** Business logic and state management

```dart
class ObjectController extends GetxController {
  // State
  final RxList<ApiObject> objects = <ApiObject>[].obs;
  final RxBool isLoading = false.obs;
  
  // Methods
  Future<void> fetchObjects();
  Future<void> createObject();
  Future<void> updateObject(String id);
  Future<void> deleteObject(String id);
}
```

**Responsibilities:**
- Manage app state
- Handle user actions
- Coordinate between services
- Form validation and processing
- Error handling
- Navigation

### 3. Services

**Purpose:** External integrations

```dart
class ApiService {
  Future<List<ApiObject>> getObjects();
  Future<ApiObject> createObject(ApiObject object);
  Future<ApiObject> updateObject(String id, ApiObject object);
  Future<void> deleteObject(String id);
}
```

**Responsibilities:**
- HTTP requests
- Authentication calls
- Data transformation
- Error handling
- Timeout management

### 4. Views

**Purpose:** UI presentation

```dart
class ObjectListScreen extends GetView<ObjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => ListView.builder(...)),
    );
  }
}
```

**Responsibilities:**
- Render UI
- Handle user input
- Delegate logic to controllers
- Show loading/error states

## 🔐 State Management Strategy

### Why GetX?

1. **Minimal Boilerplate**: No need for BLoC events/states
2. **Performance**: Selective rebuild, not the entire tree
3. **All-in-One**: State + Navigation + DI
4. **Simple Syntax**: Easy to learn and use

### State Types

1. **Observable State** (`Rx`):
   ```dart
   final RxBool isLoading = false.obs;
   isLoading.value = true;  // Update
   ```

2. **Reactive Widgets** (`Obx`):
   ```dart
   Obx(() => Text(controller.name.value))
   ```

3. **Controller Lifecycle**:
   - `onInit()`: When controller is created
   - `onReady()`: When view is rendered
   - `onClose()`: When controller is destroyed

## 🧪 Testing Strategy

### Unit Tests

**Service Tests:**
```dart
test('should return list of ApiObjects', () async {
  // Arrange
  when(() => mockClient.get(any()))
    .thenAnswer((_) async => http.Response(...));
  
  // Act
  final result = await apiService.getObjects();
  
  // Assert
  expect(result, isA<List<ApiObject>>());
});
```

**Controller Tests:**
```dart
test('should populate objects list', () async {
  // Act
  await controller.fetchObjects();
  
  // Assert
  expect(controller.objects.length, greaterThan(0));
});
```

**Mocking Strategy:**
- Use `mocktail` for mock objects
- Mock services, not controllers
- Test controllers with mocked services

## 🚀 Performance Optimizations

### 1. Lazy Loading

```dart
Get.lazyPut<ApiService>(() => ApiService());
// Only created when first accessed
```

### 2. Selective Rebuilds

```dart
Obx(() => Text(controller.name.value))
// Only this widget rebuilds when name changes
```

### 3. Pagination

```dart
Future<void> loadMore() async {
  if (!hasMore.value) return;
  currentPage.value++;
  await fetchObjects(showLoading: false);
}
```

### 4. Optimistic Updates

```dart
// Remove from UI immediately
objects.removeAt(index);

// Then call API
try {
  await apiService.deleteObject(id);
} catch (e) {
  // Rollback on error
  objects.insert(index, deletedObject);
}
```

## 🛡 Error Handling

### Layered Error Handling

1. **Service Layer**: Catch and throw custom exceptions
   ```dart
   throw ApiException('Failed to fetch', statusCode: 500);
   ```

2. **Controller Layer**: Catch and show user messages
   ```dart
   try {
     await _apiService.getObjects();
   } catch (e) {
     Get.snackbar('Error', e.toString());
   }
   ```

3. **View Layer**: Display error states
   ```dart
   if (controller.errorMessage.isNotEmpty) {
     return ErrorWidget(message: controller.errorMessage);
   }
   ```

## 🎨 UI/UX Patterns

### 1. Loading States

```dart
Obx(() => controller.isLoading.value
  ? CircularProgressIndicator()
  : ContentWidget()
)
```

### 2. Empty States

```dart
if (controller.objects.isEmpty) {
  return EmptyStateWidget();
}
```

### 3. Pull to Refresh

```dart
RefreshIndicator(
  onRefresh: controller.refreshObjects,
  child: ListView(...),
)
```

### 4. Confirmation Dialogs

```dart
final confirmed = await Get.dialog<bool>(
  AlertDialog(
    title: Text('Confirm'),
    actions: [
      TextButton(onPressed: () => Get.back(result: false)),
      TextButton(onPressed: () => Get.back(result: true)),
    ],
  ),
);
```

## 🔄 Navigation Flow

```
LoginScreen
    ↓ (OTP sent)
OtpScreen
    ↓ (Verified)
HomeScreen
    ├─→ ObjectListScreen
    │       ↓ (Tap item)
    │   ObjectDetailScreen
    │       ├─→ EditObjectScreen
    │       └─→ Delete (confirmation)
    └─→ CreateObjectScreen
```

## 📊 Decision Log

### Why GetX over BLoC?

- **Simpler syntax**: Less boilerplate
- **Faster development**: All-in-one solution
- **Better for small-medium apps**: Not over-engineered
- **Team preference**: Easier for new Flutter developers

### Why Not Redux/Provider?

- **GetX is more feature-rich**: Includes routing and DI
- **Better performance**: Selective rebuilds
- **Cleaner code**: No need for context everywhere

### API Service Design

- **Injected HTTP client**: Makes testing easier
- **Timeout handling**: Prevents hanging requests
- **Custom exceptions**: Better error messages
- **Generic design**: Easy to extend

## 🎯 Best Practices Used

1. ✅ Separation of concerns
2. ✅ Single responsibility principle
3. ✅ Dependency injection
4. ✅ Testable code
5. ✅ Reactive programming
6. ✅ Error handling at all layers
7. ✅ Loading and empty states
8. ✅ Form validation
9. ✅ Optimistic updates
10. ✅ Clean code and comments

## 📚 Further Reading

- [GetX Documentation](https://pub.dev/packages/get)
- [Flutter Architecture Samples](https://github.com/brianegan/flutter_architecture_samples)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
