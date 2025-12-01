import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'dart:convert';

import 'package:cargo_pro_app/services/api_service.dart';
import 'package:cargo_pro_app/models/api_object_model.dart';

// Mock HTTP client
class MockHttpClient extends Mock implements http.Client {}

void main() {
  late ApiService apiService;
  late MockHttpClient mockClient;

  setUp(() {
    mockClient = MockHttpClient();
    apiService = ApiService(client: mockClient);
    
    // Register fallback values for any() matcher
    registerFallbackValue(Uri());
  });

  group('ApiService - getObjects', () {
    test('should return list of ApiObjects on successful response', () async {
      // Arrange
      final mockResponse = [
        {
          'id': '1',
          'name': 'Object 1',
          'data': {'key': 'value'}
        },
        {
          'id': '2',
          'name': 'Object 2',
          'data': {'color': 'red'}
        }
      ];

      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response(
                jsonEncode(mockResponse),
                200,
              ));

      // Act
      final result = await apiService.getObjects();

      // Assert
      expect(result, isA<List<ApiObject>>());
      expect(result.length, 2);
      expect(result[0].id, '1');
      expect(result[0].name, 'Object 1');
      expect(result[1].id, '2');
      expect(result[1].name, 'Object 2');
      
      verify(() => mockClient.get(any())).called(1);
    });

    test('should throw ApiException on 404 error', () async {
      // Arrange
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Not found', 404));

      // Act & Assert
      expect(
        () async => await apiService.getObjects(),
        throwsA(isA<ApiException>()),
      );
    });

    test('should throw ApiException on 500 server error', () async {
      // Arrange
      when(() => mockClient.get(any()))
          .thenAnswer((_) async => http.Response('Server error', 500));

      // Act & Assert
      expect(
        () async => await apiService.getObjects(),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('ApiService - createObject', () {
    test('should return created ApiObject on success', () async {
      // Arrange
      final newObject = ApiObject(
        name: 'Test Object',
        data: {'color': 'blue', 'size': 'large'},
      );

      final mockResponse = {
        'id': '123',
        'name': 'Test Object',
        'data': {'color': 'blue', 'size': 'large'}
      };

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(mockResponse),
            200,
          ));

      // Act
      final result = await apiService.createObject(newObject);

      // Assert
      expect(result, isA<ApiObject>());
      expect(result.id, '123');
      expect(result.name, 'Test Object');
      expect(result.data?['color'], 'blue');
      
      verify(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).called(1);
    });

    test('should throw ApiException on create failure', () async {
      // Arrange
      final newObject = ApiObject(
        name: 'Test Object',
        data: {'color': 'blue'},
      );

      when(() => mockClient.post(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Bad request', 400));

      // Act & Assert
      expect(
        () async => await apiService.createObject(newObject),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('ApiService - updateObject', () {
    test('should return updated ApiObject on success', () async {
      // Arrange
      final updatedObject = ApiObject(
        id: '123',
        name: 'Updated Object',
        data: {'color': 'green'},
      );

      final mockResponse = {
        'id': '123',
        'name': 'Updated Object',
        'data': {'color': 'green', 'updatedAt': '2024-01-01'}
      };

      when(() => mockClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response(
            jsonEncode(mockResponse),
            200,
          ));

      // Act
      final result = await apiService.updateObject('123', updatedObject);

      // Assert
      expect(result, isA<ApiObject>());
      expect(result.id, '123');
      expect(result.name, 'Updated Object');
      expect(result.data?['color'], 'green');
      
      verify(() => mockClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).called(1);
    });

    test('should throw ApiException when object not found', () async {
      // Arrange
      final updatedObject = ApiObject(
        id: '999',
        name: 'Non-existent',
        data: {},
      );

      when(() => mockClient.put(
            any(),
            headers: any(named: 'headers'),
            body: any(named: 'body'),
          )).thenAnswer((_) async => http.Response('Not found', 404));

      // Act & Assert
      expect(
        () async => await apiService.updateObject('999', updatedObject),
        throwsA(isA<ApiException>()),
      );
    });
  });

  group('ApiService - deleteObject', () {
    test('should complete successfully on 200 response', () async {
      // Arrange
      when(() => mockClient.delete(any()))
          .thenAnswer((_) async => http.Response('', 200));

      // Act & Assert
      expect(
        () async => await apiService.deleteObject('123'),
        returnsNormally,
      );
      
      verify(() => mockClient.delete(any())).called(1);
    });

    test('should complete successfully on 204 response', () async {
      // Arrange
      when(() => mockClient.delete(any()))
          .thenAnswer((_) async => http.Response('', 204));

      // Act & Assert
      expect(
        () async => await apiService.deleteObject('123'),
        returnsNormally,
      );
    });

    test('should throw ApiException when object not found', () async {
      // Arrange
      when(() => mockClient.delete(any()))
          .thenAnswer((_) async => http.Response('Not found', 404));

      // Act & Assert
      expect(
        () async => await apiService.deleteObject('999'),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
