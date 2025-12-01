import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/api_object_model.dart';
import '../utils/constants.dart';

/// Service for handling REST API calls
class ApiService {
  final String baseUrl;
  final http.Client? client;

  ApiService({
    this.baseUrl = AppConstants.apiBaseUrl,
    this.client,
  });

  /// Get HTTP client (injectable for testing)
  http.Client get _client => client ?? http.Client();

  /// Get all objects
  Future<List<ApiObject>> getObjects() async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.objectsEndpoint}');
      print('🌐 GET: $url');

      final response = await _client
          .get(url)
          .timeout(AppConstants.apiTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        final objects = jsonList
            .map((json) => ApiObject.fromJson(json as Map<String, dynamic>))
            .toList();
        
        print('✅ Fetched ${objects.length} objects');
        return objects;
      } else {
        throw ApiException(
          'Failed to fetch objects: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error fetching objects: $e');
      rethrow;
    }
  }

  /// Get object by ID
  Future<ApiObject> getObjectById(String id) async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.objectsEndpoint}/$id');
      print('🌐 GET: $url');

      final response = await _client
          .get(url)
          .timeout(AppConstants.apiTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final object = ApiObject.fromJson(json);
        
        print('✅ Fetched object: ${object.id}');
        return object;
      } else if (response.statusCode == 404) {
        throw ApiException(
          'Object not found',
          statusCode: 404,
        );
      } else {
        throw ApiException(
          'Failed to fetch object: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error fetching object: $e');
      rethrow;
    }
  }

  /// Create new object
  Future<ApiObject> createObject(ApiObject object) async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.objectsEndpoint}');
      print('🌐 POST: $url');
      print('📤 Body: ${jsonEncode(object.toJson())}');

      final response = await _client
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(object.toJson()),
          )
          .timeout(AppConstants.apiTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final createdObject = ApiObject.fromJson(json);
        
        print('✅ Created object: ${createdObject.id}');
        return createdObject;
      } else {
        throw ApiException(
          'Failed to create object: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error creating object: $e');
      rethrow;
    }
  }

  /// Update object
  Future<ApiObject> updateObject(String id, ApiObject object) async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.objectsEndpoint}/$id');
      print('🌐 PUT: $url');
      print('📤 Body: ${jsonEncode(object.toJson())}');

      final response = await _client
          .put(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(object.toJson()),
          )
          .timeout(AppConstants.apiTimeout);

      print('📡 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final updatedObject = ApiObject.fromJson(json);
        
        print('✅ Updated object: ${updatedObject.id}');
        return updatedObject;
      } else if (response.statusCode == 404) {
        throw ApiException(
          'Object not found',
          statusCode: 404,
        );
      } else {
        throw ApiException(
          'Failed to update object: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error updating object: $e');
      rethrow;
    }
  }

  /// Delete object
  Future<void> deleteObject(String id) async {
    try {
      final url = Uri.parse('$baseUrl${AppConstants.objectsEndpoint}/$id');
      print('🌐 DELETE: $url');

      final response = await _client
          .delete(url)
          .timeout(AppConstants.apiTimeout);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Deleted object: $id');
      } else if (response.statusCode == 404) {
        throw ApiException(
          'Object not found',
          statusCode: 404,
        );
      } else {
        throw ApiException(
          'Failed to delete object: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      print('❌ Error deleting object: $e');
      rethrow;
    }
  }

  /// Dispose HTTP client
  void dispose() {
    client?.close();
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => 'ApiException: $message (status: $statusCode)';
}
