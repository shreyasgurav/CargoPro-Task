import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';

/// Binding for authentication dependencies
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // AuthService is already initialized in main.dart as permanent
    // Just initialize AuthController
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
  }
}
