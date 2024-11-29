import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/profile_crud/controller/profile_controller.dart';
import 'package:mad_project/home_screens/profile_crud/view/profile_edit.dart';
import 'dart:convert';

class ProfileScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile Information',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Obx(() {
                final user = _profileController.userModel.value;
                return Column(
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        backgroundImage: user.profilePicUrl.isNotEmpty
                            ? MemoryImage(base64Decode(user.profilePicUrl))
                            : null,
                        child: user.profilePicUrl.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileInfo('First Name', user.firstName),
                            _buildProfileInfo('Last Name', user.lastName),
                            _buildProfileInfo('Email', user.email),
                            _buildProfileInfo('Age', user.age.toString()),
                            _buildProfileInfo('Phone Number', user.phoneNumber),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => ProfileEdit(
                            uid: user.uid,
                            firstName: user.firstName,
                            lastName: user.lastName,
                            email: user.email,
                            age: user.age.toString(),
                            phoneNumber: user.phoneNumber,
                            profilePicUrl: user.profilePicUrl,
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {
                          _profileController.logout();
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          side: const BorderSide(color: Colors.red),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            Obx(() {
              if (_profileController.isLoading.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}