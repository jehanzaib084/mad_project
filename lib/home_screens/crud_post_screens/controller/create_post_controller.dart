// create_post_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';

class CreatePostController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final currentPage = 0.obs;
  
  // Form data
  final propertyName = ''.obs;
  final propertyType = ''.obs;
  final description = ''.obs;
  final price = ''.obs;
  final location = ''.obs;
  final gender = 'boys'.obs;
  final hasWifi = false.obs;
  final mealsIncluded = false.obs;
  final studentsPerRoom = 1.obs;
  final images = <String>[].obs;
  final isLoading = false.obs;

  void nextPage() {
    if (currentPage.value < 3) {
      currentPage.value++;
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      currentPage.value--;
    }
  }

  Future<void> pickAndConvertImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await File(image.path).readAsBytes();
        final base64Image = base64Encode(bytes);
        images.add('data:image/jpeg;base64,$base64Image');
        update();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  Future<bool> createPost() async {
    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return false;

      final post = Post(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        propertyName: propertyName.value,
        propertyType: propertyType.value,
        description: description.value,
        image: images.isNotEmpty ? images[0] : '',
        images: images,
        garage: 'No',
        light: 'Yes',
        water: 'Yes',
        kitchen: 'Yes',
        gyser: 'No',
        price: price.value,
        rating: '0.0',
        ownerPhone: user.phoneNumber ?? '',
        location: location.value,
        hasWifi: hasWifi.value,
        mealsIncluded: mealsIncluded.value,
        studentsPerRoom: studentsPerRoom.value,
        reviews: [],
        wifiDetails: hasWifi.value ? 'Available' : 'Not available',
        mealDetails: mealsIncluded.value ? 'Included' : 'Not included',
        gender: gender.value,
      );

      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .set(post.toJson());
      
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}