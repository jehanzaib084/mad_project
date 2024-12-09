import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/authentication/model/user_model.dart';
import 'package:mad_project/home_screens/settings_screens/controller/profile_controller.dart';

class ProfileEdit extends StatelessWidget {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String age;
  final String phoneNumber;
  final String profilePicUrl;

  ProfileEdit({
    super.key,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.age,
    required this.phoneNumber,
    required this.profilePicUrl,
  });

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final ProfileController _profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    _firstNameController.text = firstName;
    _lastNameController.text = lastName;
    _ageController.text = age;
    _phoneNumberController.text = phoneNumber;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Update Profile',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  _profileController.pickProfileImage();
                },
                child: Obx(() {
                  return CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.transparent,
                    backgroundImage: _profileController
                            .userModel.value.profilePicUrl.isNotEmpty
                        ? MemoryImage(base64Decode(
                            _profileController.userModel.value.profilePicUrl))
                        : null,
                    child:
                        _profileController.userModel.value.profilePicUrl.isEmpty
                            ? const Icon(
                                Icons.camera_alt_outlined,
                                size: 50,
                                color: Colors.blue,
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
                  prefixIcon: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Text('+92', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                  counterText: '', // This hides the counter text
                ),
                keyboardType: TextInputType.phone,
                maxLength: 11,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final updatedUser = UserModel(
                      uid: uid,
                      firstName: _firstNameController.text,
                      lastName: _lastNameController.text,
                      age: int.parse(_ageController.text),
                      phoneNumber: _phoneNumberController.text,
                      email: email,
                      profilePicUrl:
                          _profileController.userModel.value.profilePicUrl,
                    );
                    _profileController.updateUserData(updatedUser);
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
