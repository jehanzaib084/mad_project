import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assets.dart';
import 'package:mad_project/home_screens/settings_screens/controller/profile_controller.dart';
import 'package:mad_project/home_screens/settings_screens/view/profile_crud/profile_edit.dart';
import 'dart:convert';

// In profile_view.dart
class ProfileScreen extends StatelessWidget {
  final ProfileController _profileController = Get.put(ProfileController());

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('Personal Information',),
        
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Assets.primaryColor.withOpacity(0.1),
        ),
        child: Center(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() {
                  final user = _profileController.userModel.value;
                  return Column(
                    children: [
                      // Profile Picture
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
                              radius: 70,
                              backgroundColor: Colors.transparent,
                              child: user.profilePicUrl.isNotEmpty
                                  ? Image.memory(
                                      base64Decode(user.profilePicUrl),
                                      fit: BoxFit.cover,
                                      width: 200, // 2x radius
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

                      // User Name
                      Text(
                        "${user.firstName} ${user.lastName}",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 32.0),

                      // Info Cards
                      Info(infoKey: "First Name", info: user.firstName),
                      Info(infoKey: "Last Name", info: user.lastName),
                      Info(infoKey: "Age", info: user.age.toString()),
                      Info(infoKey: "Phone", info: user.phoneNumber),
                      Info(infoKey: "Email", info: user.email),

                      const SizedBox(height: 32),

                      // Keep existing update profile button
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
                            backgroundColor: Assets.btnBgColor,
                          ),
                          child: const Text(
                            'Update Profile',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              // Loading overlay
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
      ),
    );
  }
}

class Info extends StatelessWidget {
  final String infoKey;
  final String info;

  const Info({
    super.key,
    required this.infoKey,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    // Special case for email to allow wrapping
    final bool isEmail = infoKey == "Email";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            isEmail ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            infoKey,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          if (isEmail)
            Expanded(
              child: Text(
                info,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
                softWrap: true,
              ),
            )
          else
            Text(
              info,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
    );
  }
}
