/// App-wide constants
class AppConstants {
  // Prevent instantiation
  AppConstants._();

  // API Configuration
  static const String apiBaseUrl = 'https://api.restful-api.dev';
  static const String objectsEndpoint = '/objects';
  
  // Request timeouts
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration otpTimeout = Duration(seconds: 60);
  
  // Pagination
  static const int itemsPerPage = 20;
  
  // Validation
  static const int minPhoneLength = 10;
  static const int maxPhoneLength = 15;
  static const int otpLength = 6;
  
  // Messages
  static const String networkError = 'Network error. Please check your connection.';
  static const String unknownError = 'Something went wrong. Please try again.';
  static const String invalidOtp = 'Invalid OTP. Please try again.';
  static const String otpExpired = 'OTP expired. Please request a new one.';
  
  // Firebase
  static const String firebaseWebApiKey = 'YOUR_WEB_API_KEY';
  static const String firebaseAppId = 'YOUR_APP_ID';
}
