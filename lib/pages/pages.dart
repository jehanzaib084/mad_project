// pages.dart
import 'package:get/get.dart';
import 'package:mad_project/authentication/view/forgot_pass.dart';
import 'package:mad_project/authentication/view/intro_screen.dart';
import 'package:mad_project/authentication/view/login.dart';
import 'package:mad_project/authentication/view/register.dart';
import 'package:mad_project/authentication/view/register_profile.dart';
import 'package:mad_project/bindings/create_post_binding.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/create_post.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/my_posts.dart';
import 'package:mad_project/home_screens/settings_screens/view/faqs_screen.dart';
import 'package:mad_project/home_screens/settings_screens/view/profile_crud/profile_view.dart';
import 'package:mad_project/home_screens/settings_screens/view/profile_crud/profile_edit.dart';
import 'package:mad_project/home_screens/master_nav/master_nav.dart';
import 'package:mad_project/home_screens/settings_screens/view/settings_list.dart';
import 'package:mad_project/home_screens/settings_screens/view/about_screen.dart';
import 'package:mad_project/home_screens/settings_screens/view/terms_screen.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage(name: '/', page: () => MasterNav()),

    // AUTHENTICATION SCREENS
    GetPage(name: '/intro', page: () => IntroScreen()),
    GetPage(name: '/login', page: () => Login()),
    GetPage(name: '/register', page: () => Register()),
    GetPage(name: '/registerProfile', page: () => ProfileUpdateScreen()),
    GetPage(name: '/forgot', page: () => Forgot()),

    // PROFILE SCREENS
    GetPage(name: '/masterNav', page: () => MasterNav()),
    GetPage(name: '/settings', page: () => SettingsList()),
    GetPage(name: '/profile', page: () => ProfileScreen()),
    GetPage(name: '/profileEdit', page: () => ProfileEdit(
      uid: '', firstName: '', lastName: '', email: '', age: '', phoneNumber: '', profilePicUrl: ''),
    ),

    // ADDITIONAL SCREENS
    GetPage(name: '/faq_screen', page: () => FAQScreen()),
    GetPage(name: '/terms_screen', page: () => TermsScreen()),
    GetPage(name: '/about_screen', page: () => AboutScreen()),

    // POST CREATION RELATED SCREENS
    GetPage(name: '/my_posts', page: () => MyPostsScreen()),
    GetPage(
      name: '/create_post',
      page: () => CreatePostScreen(),
      binding: CreatePostBinding(),
    ),
  ];
}