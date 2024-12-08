import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:url_launcher/url_launcher.dart';

class PostController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Post> allPosts = <Post>[].obs; // Observable list of posts
  final RxList<Post> filteredPosts = <Post>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxString error = ''.obs;

  /// Create separate controllers for detail view and dialog
  final PageController detailPageController = PageController();
  final PageController dialogPageController = PageController();
  final RxInt currentPage = 0.obs;

  final RxString phoneNumber = '+923054266700'.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData(); // Load posts on initialization
  }

  // Initialize data, load posts once
  Future<void> initializeData() async {
    try {
      await loadPosts();  // Load posts directly, no pagination needed
    } catch (e) {
      Get.snackbar('Error initializing data: $e', 'We are very sorry');
    }
  }

  // Load posts from the local file (no pagination logic needed)
  Future<void> loadPosts() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      final String response = await rootBundle.loadString('assets/dummy_posts.json');
      final List<dynamic> data = json.decode(response);
      final List<Post> newPosts = data.map((json) => Post.fromJson(json)).toList();
      
      allPosts.clear(); // Clear existing posts
      allPosts.addAll(newPosts);
    } catch (e) {
      error.value = 'Failed to load posts: $e';
      Get.snackbar(
        'Error',
        'Failed to load posts',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Getter for the number of posts
  int get postCount => allPosts.length;

  // Getter for the list of posts
  List<Post> get posts => allPosts;

  // Change the page view when page changes
  void onPageChanged(int index) {
    currentPage.value = index;
  }

  // Synchronize two page controllers
  void syncPageControllers(int index) {
    currentPage.value = index;
    detailPageController.jumpToPage(index);
    dialogPageController.jumpToPage(index);
  }

  // Launch a call
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

  // Launch WhatsApp
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
    super.dispose();
  }
}
