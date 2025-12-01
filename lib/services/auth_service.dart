import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/constants.dart';

/// Service for handling Firebase authentication
class AuthService extends GetxService {
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observable auth state
  final Rx<String?> _userId = Rx<String?>(null);
  String? get userId => _userId.value;
  bool get isLoggedIn => _userId.value != null;

  // For OTP verification
  String? _verificationId;
  int? _resendToken;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  /// Initialize auth state listener
  void _initAuthListener() {
    // Listen to Firebase auth state changes
    _auth.authStateChanges().listen((User? user) {
      _userId.value = user?.uid;
      print('🔐 Auth state changed: ${user?.uid}');
    });
  }

  /// Send OTP to phone number
  Future<void> sendOtp({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      print('📱 Sending OTP to: $phoneNumber');

      // For web, set up reCAPTCHA verifier
      if (kIsWeb) {
        _auth.setSettings(appVerificationDisabledForTesting: false);
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: AppConstants.otpTimeout,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-verification (Android only)
          print('✅ Auto-verification completed');
          await _signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print('❌ Verification failed: ${e.message}');
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          print('📨 Code sent, verification ID: $verificationId');
          _verificationId = verificationId;
          _resendToken = resendToken;
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print('⏱️ Auto-retrieval timeout');
          _verificationId = verificationId;
        },
        forceResendingToken: _resendToken,
      );
    } catch (e) {
      print('❌ Error sending OTP: $e');
      onError(e.toString());
    }
  }

  /// Verify OTP and sign in
  Future<bool> verifyOtp({
    required String otp,
    required Function(String) onError,
  }) async {
    try {
      if (_verificationId == null) {
        onError('Verification ID not found. Please request OTP again.');
        return false;
      }

      print('🔐 Verifying OTP: $otp');

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );
      await _signInWithCredential(credential);
      return true;
    } catch (e) {
      print('❌ Error verifying OTP: $e');
      onError(e.toString());
      return false;
    }
  }

  /// Sign in with credential
  Future<void> _signInWithCredential(PhoneAuthCredential credential) async {
    try {
      final userCredential = await _auth.signInWithCredential(credential);
      _userId.value = userCredential.user?.uid;
      print('✅ Signed in: ${_userId.value}');
    } catch (e) {
      print('❌ Error signing in: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _userId.value = null;
      print('✅ Signed out');
    } catch (e) {
      print('❌ Error signing out: $e');
      rethrow;
    }
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
