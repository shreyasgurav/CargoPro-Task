import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/api_object_model.dart';
import '../services/api_service.dart';
import '../utils/validators.dart';

/// Controller for CRUD operations on API objects
class ObjectController extends GetxController {
  final ApiService _apiService = ApiService();

  // Observable states
  final RxList<ApiObject> objects = <ApiObject>[].obs;
  final Rx<ApiObject?> selectedObject = Rx<ApiObject?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isCreating = false.obs;
  final RxBool isUpdating = false.obs;
  final RxBool isDeleting = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers
  final nameController = TextEditingController();
  // Structured data fields for better UX
  final colorController = TextEditingController();
  final capacityController = TextEditingController();
  final priceController = TextEditingController();
  // Advanced JSON editor (optional)
  final dataController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasMore = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchObjects();
  }

  @override
  void onClose() {
    nameController.dispose();
    colorController.dispose();
    capacityController.dispose();
    priceController.dispose();
    dataController.dispose();
    _apiService.dispose();
    super.onClose();
  }

  /// Fetch all objects from API
  Future<void> fetchObjects({bool showLoading = true}) async {
    if (showLoading) {
      isLoading.value = true;
    }
    errorMessage.value = '';

    try {
      final fetchedObjects = await _apiService.getObjects();
      objects.value = fetchedObjects;
      
      print('✅ Loaded ${fetchedObjects.length} objects');
      
      if (showLoading) {
        isLoading.value = false;
      }
    } catch (e) {
      if (showLoading) {
        isLoading.value = false;
      }
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to fetch objects: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Fetch object by ID
  Future<void> fetchObjectById(String id) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final object = await _apiService.getObjectById(id);
      selectedObject.value = object;
      isLoading.value = false;
      
      print('✅ Loaded object: ${object.id}');
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to fetch object: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Create new object
  Future<void> createObject() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isCreating.value = true;
    errorMessage.value = '';

    try {
      // Build data map from structured fields; fallback to JSON editor if provided
      Map<String, dynamic> dataMap = {};
      if (colorController.text.trim().isNotEmpty) {
        dataMap['color'] = colorController.text.trim();
      }
      if (capacityController.text.trim().isNotEmpty) {
        dataMap['capacity'] = capacityController.text.trim();
      }
      if (priceController.text.trim().isNotEmpty) {
        final p = num.tryParse(priceController.text.trim());
        if (p != null) dataMap['price'] = p;
      }
      if (dataController.text.trim().isNotEmpty) {
        // Let advanced JSON override/augment
        final advanced = Validators.parseJson(dataController.text) ?? <String, dynamic>{};
        dataMap.addAll(advanced);
      }

      // Create object
      final newObject = ApiObject(
        name: nameController.text.trim(),
        data: dataMap,
      );

      // Call API
      final createdObject = await _apiService.createObject(newObject);
      
      // Add to list
      objects.insert(0, createdObject);
      
      isCreating.value = false;

      Get.snackbar(
        'Success',
        'Object created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back
      Get.back();
      
      // Clear form
      clearForm();
    } catch (e) {
      isCreating.value = false;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to create object: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Update existing object
  Future<void> updateObject(String id) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    isUpdating.value = true;
    errorMessage.value = '';

    try {
      // Build data map from structured fields; fallback to JSON editor if provided
      Map<String, dynamic> dataMap = {};
      if (colorController.text.trim().isNotEmpty) {
        dataMap['color'] = colorController.text.trim();
      }
      if (capacityController.text.trim().isNotEmpty) {
        dataMap['capacity'] = capacityController.text.trim();
      }
      if (priceController.text.trim().isNotEmpty) {
        final p = num.tryParse(priceController.text.trim());
        if (p != null) dataMap['price'] = p;
      }
      if (dataController.text.trim().isNotEmpty) {
        final advanced = Validators.parseJson(dataController.text) ?? <String, dynamic>{};
        dataMap.addAll(advanced);
      }

      // Create updated object
      final updatedObject = ApiObject(
        id: id,
        name: nameController.text.trim(),
        data: dataMap,
      );

      // Call API
      final result = await _apiService.updateObject(id, updatedObject);
      
      // Update in list
      final index = objects.indexWhere((obj) => obj.id == id);
      if (index != -1) {
        objects[index] = result;
      }
      
      // Update selected object
      selectedObject.value = result;
      
      isUpdating.value = false;

      Get.snackbar(
        'Success',
        'Object updated successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back
      Get.back();
      
      // Clear form
      clearForm();
    } catch (e) {
      isUpdating.value = false;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to update object: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Delete object with confirmation
  Future<void> deleteObject(String id) async {
    // Show confirmation dialog
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Delete Object'),
        content: const Text('Are you sure you want to delete this object?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    isDeleting.value = true;
    errorMessage.value = '';

    // Store object for rollback
    final index = objects.indexWhere((obj) => obj.id == id);
    ApiObject? deletedObject;
    
    if (index != -1) {
      deletedObject = objects[index];
      // Optimistic update
      objects.removeAt(index);
    }

    try {
      // Call API
      await _apiService.deleteObject(id);
      
      isDeleting.value = false;

      Get.snackbar(
        'Success',
        'Object deleted successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );

      // Navigate back if on detail screen
      if (selectedObject.value?.id == id) {
        Get.back();
      }
    } catch (e) {
      isDeleting.value = false;
      errorMessage.value = e.toString();
      
      // Rollback on error
      if (deletedObject != null && index != -1) {
        objects.insert(index, deletedObject);
      }
      
      Get.snackbar(
        'Error',
        'Failed to delete object: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  /// Set selected object and populate form
  void setSelectedObject(ApiObject object) {
    selectedObject.value = object;
    nameController.text = object.name;
    final map = object.data ?? {};
    colorController.text = map['color']?.toString() ?? '';
    capacityController.text = map['capacity']?.toString() ?? '';
    priceController.text = map['price']?.toString() ?? '';
    dataController.text = object.getFormattedData();
  }

  /// Clear form
  void clearForm() {
    nameController.clear();
    colorController.clear();
    capacityController.clear();
    priceController.clear();
    dataController.clear();
    formKey.currentState?.reset();
  }

  /// Refresh objects list
  Future<void> refreshObjects() async {
    await fetchObjects(showLoading: false);
  }

  /// Load more objects (pagination)
  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) {
      return;
    }

    currentPage.value++;
    
    // Note: The API doesn't support pagination, so this is a placeholder
    // In a real app, you would pass page parameters to the API
    await fetchObjects(showLoading: false);
  }
}
