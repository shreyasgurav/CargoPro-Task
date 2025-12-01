import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../routes/app_routes.dart';
import '../utils/validators.dart';

/// Controller for authentication logic
class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Form controllers
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // Form keys
  final phoneFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();

  // Observable states
  final RxBool isLoading = false.obs;
  final RxBool otpSent = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt resendTimer = 0.obs;

  // Phone number for OTP verification
  String? _phoneNumber;

  @override
  void onClose() {
    phoneController.dispose();
    otpController.dispose();
    super.onClose();
  }

  /// Send OTP to phone number
  Future<void> sendOtp() async {
    if (!phoneFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      _phoneNumber = Validators.cleanPhone(phoneController.text);
      
      await _authService.sendOtp(
        phoneNumber: _phoneNumber!,
        onCodeSent: (verificationId) {
          otpSent.value = true;
          isLoading.value = false;
          _startResendTimer();
          
          Get.snackbar(
            'Success',
            'OTP sent to $_phoneNumber',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          
          // Navigate to OTP screen
          Get.toNamed(AppRoutes.otp);
        },
        onError: (error) {
          isLoading.value = false;
          errorMessage.value = error;
          
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        },
      );
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to send OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Verify OTP and sign in
  Future<void> verifyOtp() async {
    if (!otpFormKey.currentState!.validate()) {
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final success = await _authService.verifyOtp(
        otp: otpController.text,
        onError: (error) {
          errorMessage.value = error;
          
          Get.snackbar(
            'Error',
            error,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
        },
      );

      isLoading.value = false;

      if (success) {
        Get.snackbar(
          'Success',
          'Logged in successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home screen
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = e.toString();
      
      Get.snackbar(
        'Error',
        'Failed to verify OTP: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Resend OTP
  Future<void> resendOtp() async {
    if (resendTimer.value > 0) {
      Get.snackbar(
        'Wait',
        'Please wait ${resendTimer.value} seconds before resending',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Clear OTP field
    otpController.clear();
    
    // Resend OTP
    await sendOtp();
  }

  /// Start countdown timer for resend button
  void _startResendTimer() {
    resendTimer.value = 60;
    
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      
      Get.snackbar(
        'Success',
        'Logged out successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to login screen
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign out: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  /// Check if user is logged in
  bool get isLoggedIn => _authService.isLoggedIn;

  /// Get formatted phone number
  String get formattedPhone {
    if (_phoneNumber == null) return '';
    return Validators.formatPhone(_phoneNumber!);
  }
}
