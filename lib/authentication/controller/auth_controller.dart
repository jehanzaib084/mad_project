import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var profileImageBase64 = ''.obs;

  final RxBool isLoading = false.obs;

  final RxInt resendTimer = 60.obs;
  final RxBool canResendEmail = false.obs;
  Timer? _timer;

  void startResendTimer() {
    canResendEmail.value = false;
    resendTimer.value = 60;
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResendEmail.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send verification email',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  Future<bool> checkEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  Future<void> deleteUnverifiedUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Delete from Firestore first
        await _firestore.collection('users').doc(user.uid).delete();
        // Then delete auth user
        await user.delete();

        // Clear stored data
        profileImageBase64.value = '';

        Get.snackbar(
          'Account Deleted',
          'Your unverified account has been deleted. Please register again.',
          backgroundColor: Colors.blue.withOpacity(0.5),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      // print('Error deleting unverified user: $e');
    }
  }

  Future<void> signUp(
      String email, String password, UserModel userModel) async {
    try {
      isLoading.value = true;
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userModel.uid = userCredential.user!.uid;
      await _firestore
          .collection('users')
          .doc(userModel.uid)
          .set(userModel.toMap());
      await _saveUserDataToPreferences(userModel);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenIntro', true);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Sign up failed',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        Get.snackbar(
          'Error',
          'Please verify your email first',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
        await sendEmailVerification();
        return;
      }

      DocumentSnapshot userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      UserModel userModel =
          UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      await _saveUserDataToPreferences(userModel);

      Get.offAllNamed('/masterNav');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,);
    } finally {
      isLoading.value = false;
    }
  }

  // Modify completeProfile method
  Future<void> completeProfile(String email, String password, String firstName,
      String lastName, int age, String phoneNumber) async {
    UserModel userModel = UserModel(
      uid: '',
      firstName: firstName,
      lastName: lastName,
      age: age,
      phoneNumber: phoneNumber,
      email: email,
      profilePicUrl: profileImageBase64.value,
    );

    await signUp(email, password, userModel);

    // Send verification email
    await sendEmailVerification();

    // Show verification dialog
    Get.dialog(
      PopScope(
        canPop: false,
        child: AlertDialog(
          title: const Text('Verify Your Email'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.mark_email_unread_outlined,
                size: 50,
                color: Assets.primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'A verification link has been sent to your email.\n'
                'Please verify your email to continue.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Obx(() => Text(
                    canResendEmail.value
                        ? 'Resend verification email'
                        : 'Resend email in ${resendTimer.value}s',
                    style: TextStyle(
                      color: Assets.lightTextColor,
                      fontSize: 14,
                    ),
                  )),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: Obx(() => ElevatedButton(
                        onPressed: canResendEmail.value
                            ? () async {
                                await sendEmailVerification();
                                startResendTimer();
                                Get.snackbar(
                                    'Success', 'Verification email sent again',
                                    backgroundColor:
                                        Colors.green.withOpacity(0.5),
                                        colorText: Colors.white,);
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Assets.btnBgColor,
                          disabledBackgroundColor: Colors.grey[300],
                        ),
                        child: Text(
                          'Resend',
                          style: TextStyle(
                            color: canResendEmail.value
                                ? Colors.white
                                : Colors.grey[600],
                          ),
                        ),
                      )),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      _timer?.cancel();
                      await deleteUnverifiedUser();
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    startResendTimer();

    // Start verification check loop
    bool isVerified = false;
    while (!isVerified) {
      await Future.delayed(const Duration(seconds: 3));
      isVerified = await checkEmailVerified();

      if (isVerified) {
        Get.back(); // Close dialog
        Get.offAllNamed('/masterNav');
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> _saveUserDataToPreferences(UserModel userModel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', userModel.uid);
    await prefs.setString('firstName', userModel.firstName);
    await prefs.setString('lastName', userModel.lastName);
    await prefs.setInt('age', userModel.age);
    await prefs.setString('phoneNumber', userModel.phoneNumber);
    await prefs.setString('email', userModel.email);
    await prefs.setString('profilePicUrl', userModel.profilePicUrl);
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6 || value.length > 24) {
      return 'Password must be between 6 and 24 characters';
    }
    return null;
  }

  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> pickProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      profileImageBase64.value = base64Encode(bytes);
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      Get.snackbar('Success', 'Password reset email sent',
          backgroundColor: Colors.green.withOpacity(0.5),
          colorText: Colors.white,);
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Error',
        e.message ?? 'Failed to send password reset email',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
