// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mad_project/home_screens/profile_crud/controller/profile_controller.dart';

// class Resetpass extends StatelessWidget {
//   Resetpass({super.key});

//   final ProfileController _profileController = Get.put(ProfileController());

//   Future<void> _resetPassword() async {
//     await _profileController.resetPassword();
//     Get.back();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: SingleChildScrollView(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 50,
//                     backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image asset
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Reset Password',
//                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'A password reset link will be sent to your email.',
//                     textAlign: TextAlign.center,
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 32),
//                   SizedBox(
//                     width: double.infinity,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _resetPassword,
//                       style: ElevatedButton.styleFrom(
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         backgroundColor: Colors.blue,
//                       ),
//                       child: const Text(
//                         'Send Reset Email',
//                         style: TextStyle(fontSize: 18, color: Colors.white),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   TextButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: const Text(
//                       'Cancel',
//                       style: TextStyle(fontSize: 16, color: Colors.blue),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }