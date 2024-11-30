import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class ProfileUpdateScreen extends StatelessWidget {
  ProfileUpdateScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthController _authController =
      Get.find<AuthController>(); // Use Get.find to get the existing instance

  Future<void> _completeProfile(BuildContext context) async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    try {
      _authController.isLoading.value = true;
      final email = Get.parameters['email']!;
      final password = Get.parameters['password']!;

      await _authController.completeProfile(
        email,
        password,
        _firstNameController.text,
        _lastNameController.text,
        int.parse(_ageController.text),
        _phoneNumberController.text,
      );

      Get.offAllNamed('/masterNav');
    } catch (e) {
      Get.snackbar('Error', 'Failed to complete profile: ${e.toString()}');
    } finally {
      _authController.isLoading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Profile',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Assets.primaryColor),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Kindly complete your profile',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 16, color: Assets.lightTextColor),
                  ),
                  const SizedBox(height: 32),
                  GestureDetector(
                    onTap: () {
                      _authController.pickProfileImage();
                    },
                    child: Obx(() {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            _authController.profileImageBase64.value.isNotEmpty
                                ? MemoryImage(base64Decode(
                                    _authController.profileImageBase64.value))
                                : null,
                        child: _authController.profileImageBase64.value.isEmpty
                            ? Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue,
                                    style: BorderStyle.solid,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                              )
                            : null,
                      );
                    }),
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    keyboardType: TextInputType.name,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.cake_outlined),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: Obx(() => ElevatedButton(
                          onPressed: _authController.isLoading.value
                              ? null
                              : () => _completeProfile(context),
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Assets.btnBgColor,
                          ),
                          child: _authController.isLoading.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Complete Profile',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
