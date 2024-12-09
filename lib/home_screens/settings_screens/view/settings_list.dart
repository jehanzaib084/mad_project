import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/home_screens/settings_screens/controller/profile_controller.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController = Get.put(ProfileController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
        child: Obx(() {
          if (profileController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16.0),
                  margin: const EdgeInsets.symmetric(vertical: 16.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                    ),
                  ),
                  child: ClipOval(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: profileController
                              .userModel.value.profilePicUrl.isNotEmpty
                          ? Image.memory(
                              base64Decode(profileController
                                  .userModel.value.profilePicUrl),
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            )
                          : Image.asset(
                              Assets.dummyProfilePic,
                              fit: BoxFit.cover,
                              width: 200,
                              height: 200,
                            ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${profileController.userModel.value.firstName} ${profileController.userModel.value.lastName}',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildProfileOption(context, '👤 Profile', () {
                Get.toNamed('/profile');
              }),
              _buildProfileOption(context, '❓ FAQ', () {
                Get.toNamed('/faq_screen');
              }),
              _buildProfileOption(context, '📜 Terms & Conditions', () {
                Get.toNamed('/terms_screen');
              }),
              _buildProfileOption(context, 'ℹ️ About App', () {
                Get.toNamed('/about_screen');
              }),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      profileController.logout();
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
              ),
              const SizedBox(height: 60),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
