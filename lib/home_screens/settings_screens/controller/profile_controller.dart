import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mad_project/authentication/model/user_model.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();
  var userModel = UserModel(
    uid: '',
    firstName: '',
    lastName: '',
    age: 0,
    phoneNumber: '',
    email: '',
    profilePicUrl: '',
    role: UserRole.student,
  ).obs;
  var isLoading = false.obs;

  bool canEditRole() => false;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (doc.exists) {
          userModel.value = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateUserData(UserModel updatedUser) async {
    try {
      await _firestore.collection('users').doc(updatedUser.uid).update(updatedUser.toMap());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', updatedUser.firstName);
      await prefs.setString('lastName', updatedUser.lastName);
      await prefs.setInt('age', updatedUser.age);
      await prefs.setString('phoneNumber', updatedUser.phoneNumber);
      await prefs.setString('email', updatedUser.email);
      await prefs.setString('profilePicUrl', updatedUser.profilePicUrl);
      userModel.value = updatedUser;
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    }
  }

  Future<void> fetchAndSaveUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        UserModel user = UserModel.fromMap(doc.data() as Map<String, dynamic>);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);
        await prefs.setString('firstName', user.firstName);
        await prefs.setString('lastName', user.lastName);
        await prefs.setInt('age', user.age);
        await prefs.setString('phoneNumber', user.phoneNumber);
        await prefs.setString('email', user.email);
        await prefs.setString('profilePicUrl', user.profilePicUrl);
        userModel.value = user;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch user data');
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      userModel.update((user) {
        user?.profilePicUrl = base64Image;
      });
    }
  }

  Future<void> logout() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out');
    }
  }
}