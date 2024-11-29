import 'package:get/get.dart';
import 'package:mad_project/authentication/view/forgot_pass.dart';
import 'package:mad_project/authentication/view/login.dart';
import 'package:mad_project/authentication/view/register.dart';
import 'package:mad_project/authentication/view/register_profile.dart';
import 'package:mad_project/home_screens/profile_crud/view/profile_view.dart';
import 'package:mad_project/home_screens/profile_crud/view/profile_edit.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => Login()),
    
    // AUTHENTICATION SCREENS
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/register', page: () => Register()),
    GetPage(name: '/registerProfile', page: () => ProfileUpdateScreen()),
    GetPage(name: '/forgot', page: () => Forgot()),

    // PROFILE SCREENS
    GetPage(name: '/profile', page: () => ProfileScreen()),
    GetPage(name: '/profileEdit', page: () => ProfileEdit(
      uid: '', firstName: '', lastName: '', email: '', age: '', phoneNumber: '', profilePicUrl: ''
    )),
  ];
}