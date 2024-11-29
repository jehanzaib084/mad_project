// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mad_project/authentication/view/login.dart';
// import 'package:mad_project/home_screens/profile_crud/controller/profile_controller.dart';
// import 'package:mad_project/home_screens/profile_crud/view/profile_view.dart';

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   final ProfileController _profileController = Get.put(ProfileController());

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeIn,
//     );
//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFCACFF9),
//       body: FutureBuilder(
//         future: Future.delayed(const Duration(seconds: 3)),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: FadeTransition(
//                 opacity: _animation,
//                 child: SizedBox(
//                   width: 140,
//                   height: 140,
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(20),
//                     child: Image.asset('assets/splash_icon/play_store_512.png'),
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return StreamBuilder<User?>(
//               stream: FirebaseAuth.instance.authStateChanges(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (!snapshot.hasData) {
//                   return Login();
//                 } else {
//                   return FutureBuilder(
//                     future: _profileController.fetchAndSaveUserData(snapshot.data!.uid),
//                     builder: (context, snapshot) {
//                       if (snapshot.connectionState == ConnectionState.waiting) {
//                         return const Center(child: CircularProgressIndicator());
//                       }
//                       return ProfileScreen();
//                     },
//                   );
//                 }
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }