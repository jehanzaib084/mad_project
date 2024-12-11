// create_post_controller.dart
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';

class CreatePostController extends GetxController {
  final currentStep = 0.obs;

  // Form Controllers
  late final propertyNameController = TextEditingController();
  late final propertyTypeController = TextEditingController();
  late final descriptionController = TextEditingController();
  late final priceController = TextEditingController();
  late final locationController = TextEditingController();
  late final phoneController = TextEditingController();

  // Observable form data with proper typing
  final facilities = <String, RxBool>{
    'garage': false.obs,
    'light': false.obs,
    'water': false.obs,
    'kitchen': false.obs,
    'gyser': false.obs,
  }.obs;

  final features = <String, dynamic>{
    'hasWifi': false.obs,
    'mealsIncluded': false.obs,
    'studentsPerRoom': 1.obs,
    'gender': 'boys'.obs,
  }.obs;

  final images = <String>[].obs;
  final isLoading = false.obs;
  final priceType = '/month'.obs;

  final base64Images = <String>[].obs;
  final selectedImages = <File>[].obs;
  static const int maxImages = 10;

  @override
  void onInit() {
    super.onInit();
    _prefillPhoneNumber();
  }

  void nextStep() {
    if (currentStep.value < 3) {
      currentStep.value++;
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void validateAndProceed(int step) {
    switch (step) {
      case 0:
        if (validateBasicInfo()) nextStep();
        break;
      case 1:
        if (validateFacilities()) nextStep();
        break;
      case 2:
        if (validateFeatures()) nextStep();
        break;
    }
  }

  bool validateBasicInfo() {
    if (propertyNameController.text.isEmpty) {
      Get.snackbar('Error', 'Property name is required');
      return false;
    }
    if (propertyTypeController.text.isEmpty) {
      Get.snackbar('Error', 'Property type is required');
      return false;
    }
    if (descriptionController.text.isEmpty) {
      Get.snackbar('Error', 'Description is required');
      return false;
    }
    return true;
  }

  bool validateFacilities() {
    bool hasAnyFacility = facilities.values.any((facility) => facility.value);
    if (!hasAnyFacility) {
      Get.snackbar('Error', 'Select at least one facility');
      return false;
    }
    return true;
  }

  bool validateFeatures() {
    if ((features['studentsPerRoom'] as RxInt).value < 1) {
      Get.snackbar('Error', 'Invalid number of students per room');
      return false;
    }
    return true;
  }

  Future<void> pickImages() async {
    try {
      if (selectedImages.length >= maxImages) {
        Get.snackbar(
          'Limit Reached',
          'Maximum $maxImages images allowed',
          backgroundColor: Colors.orange.withOpacity(0.1),
        );
        return;
      }

      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        imageQuality: 70,
      );

      if (pickedFiles.isNotEmpty) {
        if (selectedImages.length + pickedFiles.length > maxImages) {
          Get.snackbar(
            'Too Many Images',
            'You can select up to $maxImages images only',
            backgroundColor: Colors.orange.withOpacity(0.1),
          );
          return;
        }

        // Convert images to base64 while picking
        for (var file in pickedFiles) {
          final bytes = await file.readAsBytes();
          final base64String = base64Encode(bytes);
          base64Images.add(base64String);
          selectedImages.add(File(file.path));
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    }
  }

  void removeImage(int index) {
    selectedImages.removeAt(index);
    base64Images.removeAt(index);
  }

  Future<List<String>> prepareImages() async {
    return base64Images;
  }

  Future<bool> showCancelConfirmation() async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Cancel Post Creation'),
        content:
            Text('Are you sure you want to cancel? All data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Yes'),
          ),
        ],
      ),
    );
    if (result == true) {
      resetForm();
      return true;
    }
    return false;
  }

  void resetForm() {
    currentStep.value = 0;
    propertyNameController.clear();
    propertyTypeController.clear();
    descriptionController.clear();
    priceController.clear();
    locationController.clear();
    phoneController.clear();

    facilities.forEach((key, value) {
      value.value = false;
    });

    (features['hasWifi'] as RxBool).value = false;
    (features['mealsIncluded'] as RxBool).value = false;
    (features['studentsPerRoom'] as RxInt).value = 1;
    (features['gender'] as RxString).value = 'boys';

    base64Images.clear();
    images.clear();
    selectedImages.clear();
  }

  Future<void> submitForm() async {
    if (!validateAllFields()) return;

    try {
      isLoading.value = true;
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        Get.snackbar(
          'Error',
          'Please login to create a post',
          backgroundColor: Colors.red.withOpacity(0.1),
        );
        return;
      }

      final postData = Post(
        id: '',
        propertyName: propertyNameController.text,
        propertyType: propertyTypeController.text,
        description: descriptionController.text,
        images: base64Images,
        garage: facilities['garage']?.value ?? false,
        light: facilities['light']?.value ?? false,
        water: facilities['water']?.value ?? false,
        kitchen: facilities['kitchen']?.value ?? false,
        gyser: facilities['gyser']?.value ?? false,
        price: priceController.text,
        rating: '0',
        ownerPhone: phoneController.text,
        location: locationController.text,
        hasWifi: (features['hasWifi'] as RxBool).value,
        mealsIncluded: (features['mealsIncluded'] as RxBool).value,
        studentsPerRoom: (features['studentsPerRoom'] as RxInt).value,
        reviews: [],
        wifiDetails: (features['hasWifi'] as RxBool).value ? 'Available' : 'Not available',
        mealDetails: (features['mealsIncluded'] as RxBool).value ? 'Included' : 'Not included',
        gender: (features['gender'] as RxString).value,
      ).toJson();

      await FirebaseFirestore.instance.collection('posts').add(postData);

      showSuccessMsg();

      resetForm();
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create post: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> showSuccessMsg() async {
    Get.snackbar(
      'Success',
      'Post created successfully',
      backgroundColor: Colors.green.withOpacity(0.1),
    );
  }

  bool validateAllFields() {
    if (!validateBasicInfo()) return false;
    if (!validateFacilities()) return false;
    if (!validateFeatures()) return false;

    if (base64Images.isEmpty) {
      Get.snackbar('Error', 'Please add at least one image');
      return false;
    }
    if (priceController.text.isEmpty ||
        double.tryParse(priceController.text) == null) {
      Get.snackbar('Error', 'Please enter a valid price');
      return false;
    }
    if (locationController.text.isEmpty) {
      Get.snackbar('Error', 'Location is required');
      return false;
    }
    if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(phoneController.text)) {
      Get.snackbar('Error', 'Please enter a valid phone number');
      return false;
    }
    return true;
  }

  Future<void> _prefillPhoneNumber() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final phoneNumber = userDoc.data()?['phoneNumber'] ?? '';
        phoneController.text = phoneNumber;
      }
    }
  }

  @override
  void onClose() {
    propertyNameController.dispose();
    propertyTypeController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    locationController.dispose();
    phoneController.dispose();
    super.onClose();
  }
}