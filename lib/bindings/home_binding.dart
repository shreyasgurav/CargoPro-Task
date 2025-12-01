import 'package:get/get.dart';
import '../controllers/object_controller.dart';
import '../services/api_service.dart';

/// Binding for home/CRUD dependencies
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Initialize ApiService
    Get.lazyPut<ApiService>(
      () => ApiService(),
    );

    // Initialize ObjectController as permanent singleton
    Get.put<ObjectController>(
      ObjectController(),
      permanent: true,
    );
  }
}
