import 'dart:convert';

/// Model class for API objects from restful-api.dev
class ApiObject {
  final String? id;
  final String name;
  final Map<String, dynamic>? data;

  ApiObject({
    this.id,
    required this.name,
    this.data,
  });

  /// Create ApiObject from JSON
  factory ApiObject.fromJson(Map<String, dynamic> json) {
    return ApiObject(
      id: json['id']?.toString(),
      name: json['name'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
    );
  }

  /// Convert ApiObject to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
    };

    // Include id only if it exists (for updates)
    if (id != null) {
      json['id'] = id;
    }

    // Include data only if it exists and is not empty
    if (data != null && data!.isNotEmpty) {
      json['data'] = data;
    }

    return json;
  }

  /// Create a copy with updated fields
  ApiObject copyWith({
    String? id,
    String? name,
    Map<String, dynamic>? data,
  }) {
    return ApiObject(
      id: id ?? this.id,
      name: name ?? this.name,
      data: data ?? this.data,
    );
  }

  /// Get a summary of data for display
  String getDataSummary() {
    if (data == null || data!.isEmpty) {
      return 'No data';
    }

    final keys = data!.keys.take(3).toList();
    if (keys.isEmpty) return 'Empty data';

    final preview = keys.map((key) {
      final value = data![key];
      return '$key: ${_formatValue(value)}';
    }).join(', ');

    return data!.length > 3 ? '$preview...' : preview;
  }

  /// Format value for display
  String _formatValue(dynamic value) {
    if (value == null) return 'null';
    if (value is String) {
      return value.length > 20 ? '${value.substring(0, 20)}...' : value;
    }
    if (value is Map || value is List) {
      return jsonEncode(value).length > 30
          ? '${jsonEncode(value).substring(0, 30)}...'
          : jsonEncode(value);
    }
    return value.toString();
  }

  /// Get formatted data as JSON string
  String getFormattedData() {
    if (data == null || data!.isEmpty) {
      return '{}';
    }
    try {
      return const JsonEncoder.withIndent('  ').convert(data);
    } catch (e) {
      return data.toString();
    }
  }

  @override
  String toString() {
    return 'ApiObject(id: $id, name: $name, data: $data)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ApiObject &&
        other.id == id &&
        other.name == name &&
        _mapsEqual(other.data, data);
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ data.hashCode;

  /// Compare two maps for equality
  bool _mapsEqual(Map<String, dynamic>? map1, Map<String, dynamic>? map2) {
    if (map1 == null && map2 == null) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;

    for (final key in map1.keys) {
      if (!map2.containsKey(key)) return false;
      if (map1[key] != map2[key]) return false;
    }

    return true;
  }
}
