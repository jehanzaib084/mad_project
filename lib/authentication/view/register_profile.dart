import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/authentication/controller/auth_controller.dart';

class ProfileUpdateScreen extends StatelessWidget {
  ProfileUpdateScreen({super.key});

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final AuthController _authController = Get.find<AuthController>();

  Future<void> _completeProfile(BuildContext context) async {
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
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AppBar(
          title: const Text(
            'Profile',
            style: TextStyle(
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(Assets.backgroundImage),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: () {
                        _authController.pickProfileImage();
                      },
                      child: Obx(() {
                        return CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: _authController
                                  .profileImageBase64.value.isNotEmpty
                              ? MemoryImage(base64Decode(
                                  _authController.profileImageBase64.value))
                              : null,
                          child:
                              _authController.profileImageBase64.value.isEmpty
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
                    const SizedBox(height: 16),
                    const Text(
                      'Kindly complete your profile',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, color: Assets.lightTextColor),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First Name',
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
                        hintText: 'Last Name',
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
                        hintText: 'Age',
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
                        hintText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        prefixText: '+92 ',
                        prefixIcon: const Icon(Icons.phone_outlined),
                      ),
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      onChanged: (value) {
                        // Remove any non-digits and limit to 10 digits
                        final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
                        if (digits != value) {
                          _phoneNumberController.text =
                              digits.substring(0, min(digits.length, 10));
                          _phoneNumberController.selection =
                              TextSelection.fromPosition(
                            TextPosition(
                                offset: _phoneNumberController.text.length),
                          );
                        }
                      },
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
        ));
  }
}
