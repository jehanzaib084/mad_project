import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad_project/authentication/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var profileImageBase64 = ''.obs;

  final RxBool isLoading = false.obs;

  Future<bool> isEmailAlreadyExists(String email) async {
    try {
      // Create a dummy action code for checking
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: 'temporary_password_123',
      );
      
      // If we reach here, email doesn't exist
      return false;
    } on FirebaseAuthException catch (e) {
      // Check specific error codes
      if (e.code == 'email-already-in-use') {
        return true;
      }
      // Handle other potential errors
      print('Error checking email: ${e.message}');
      return false;
    } catch (e) {
      print('Unexpected error checking email: $e');
      return false;
    }
  }

  Future<void> signUp(String email, String password, UserModel userModel) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      userModel.uid = userCredential.user!.uid;
      await _firestore.collection('users').doc(userModel.uid).set(userModel.toMap());
      await _saveUserDataToPreferences(userModel);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Sign up failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userCredential.user!.uid).get();
      UserModel userModel = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      await _saveUserDataToPreferences(userModel);
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Login failed');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> completeProfile(String email, String password, String firstName, String lastName, int age, String phoneNumber) async {
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
      // Get.snackbar('Success', 'Password reset email sent');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to send password reset email');
    }
  }
  
}