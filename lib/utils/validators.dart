import 'dart:convert';
import 'constants.dart';

/// Input validation utilities
class Validators {
  // Prevent instantiation
  Validators._();

  /// Validate phone number
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    
    // Remove spaces and special characters
    final cleaned = value.replaceAll(RegExp(r'[^\d+]'), '');
    
    if (cleaned.length < AppConstants.minPhoneLength) {
      return 'Phone number too short';
    }
    
    if (cleaned.length > AppConstants.maxPhoneLength) {
      return 'Phone number too long';
    }
    
    // Must start with + or digit
    if (!RegExp(r'^[\d+]').hasMatch(cleaned)) {
      return 'Invalid phone number format';
    }
    
    return null;
  }

  /// Validate OTP
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }
    
    if (value.length != AppConstants.otpLength) {
      return 'OTP must be ${AppConstants.otpLength} digits';
    }
    
    if (!RegExp(r'^\d+$').hasMatch(value)) {
      return 'OTP must contain only numbers';
    }
    
    return null;
  }

  /// Validate object name
  static String? validateObjectName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    
    return null;
  }

  /// Validate JSON string
  static String? validateJson(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data is required';
    }
    
    try {
      final decoded = jsonDecode(value);
      
      // Must be a Map (JSON object)
      if (decoded is! Map) {
        return 'Data must be a valid JSON object';
      }
      
      return null;
    } catch (e) {
      return 'Invalid JSON format: ${e.toString()}';
    }
  }

  /// Parse and validate JSON, returning Map or null
  static Map<String, dynamic>? parseJson(String value) {
    try {
      final decoded = jsonDecode(value);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Clean phone number (remove spaces, special chars except +)
  static String cleanPhone(String phone) {
    return phone.replaceAll(RegExp(r'[^\d+]'), '');
  }

  /// Format phone number for display
  static String formatPhone(String phone) {
    final cleaned = cleanPhone(phone);
    
    // If starts with country code, format with spaces
    if (cleaned.startsWith('+')) {
      if (cleaned.length > 3) {
        return '${cleaned.substring(0, 3)} ${cleaned.substring(3)}';
      }
    }
    
    return cleaned;
  }
}
