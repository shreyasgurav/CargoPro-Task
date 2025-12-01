import 'package:get/get.dart';
import '../bindings/auth_binding.dart';
import '../bindings/home_binding.dart';
import '../views/auth/login_screen.dart';
import '../views/auth/otp_screen.dart';
import '../views/home/home_screen.dart';
import '../views/home/object_list_screen.dart';
import '../views/home/object_detail_screen.dart';
import '../views/home/create_object_screen.dart';
import '../views/home/edit_object_screen.dart';
import 'app_routes.dart';

/// App pages configuration for GetX navigation
class AppPages {
  // Prevent instantiation
  AppPages._();

  /// Initial route for the app
  static const initial = AppRoutes.login;

  /// All app routes with their bindings
  static final routes = [
    // Auth routes
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () => const OtpScreen(),
      binding: AuthBinding(),
    ),

    // Main app routes
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.objectList,
      page: () => const ObjectListScreen(),
    ),
    GetPage(
      name: AppRoutes.objectDetail,
      page: () => const ObjectDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.createObject,
      page: () => const CreateObjectScreen(),
    ),
    GetPage(
      name: AppRoutes.editObject,
      page: () => const EditObjectScreen(),
    ),
  ];
}
