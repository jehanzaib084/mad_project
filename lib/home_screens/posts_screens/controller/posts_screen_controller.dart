import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PostController extends GetxController {
  static const int pageSize = 10;
  final PagingController<int, Post> pagingController = PagingController(firstPageKey: 0);
  final RxBool isLoading = false.obs;
  final RxList<Post> allPosts = <Post>[].obs;

  /// Create separate controllers for detail view and dialog
  final PageController detailPageController = PageController();
  final PageController dialogPageController = PageController();
  final RxInt currentPage = 0.obs;

  final RxString phoneNumber = '+923054266700'.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await loadPosts(0);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void syncPageControllers(int index) {
    currentPage.value = index;
    detailPageController.jumpToPage(index);
    dialogPageController.jumpToPage(index);
  }

  Future<void> loadPosts(int pageKey) async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString('assets/dummy_posts.json');
      final List<dynamic> data = json.decode(response);
      final List<Post> newPosts = data.map((json) => Post.fromJson(json)).toList();

      pagingController.appendPage(newPosts, pageKey + newPosts.length);
    } catch (e) {
      print('Error loading posts: $e');
      pagingController.error = e;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> launchCall(String phoneNumber) async {
    final Uri callUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        Get.snackbar(
          'Error', 
          'Could not launch Call',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to make call: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  Future<void> launchWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse(
        'https://wa.me/$phoneNumber?text=Hello, I am interested in your property');
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
      } else {
        Get.snackbar(
          'Error', 
          'Could not launch WhatsApp',
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to open WhatsApp: ${e.toString()}',
      );
    }
  }

  @override
  void dispose() {
    detailPageController.dispose();
    dialogPageController.dispose();
    pagingController.dispose();
    super.dispose();
  }
}