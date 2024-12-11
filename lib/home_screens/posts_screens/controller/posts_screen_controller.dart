// import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostController extends GetxController {
  final RxBool isLoading = false.obs;
  final List<Post> allPosts = []; // Non-reactive list
  final RxList<Post> filteredPosts = <Post>[].obs;
  final RxList<String> selectedFilters = <String>[].obs;
  final RxBool hasMorePosts = true.obs; // To track if more posts are available
  final RxString error = ''.obs;

  /// Create separate controllers for detail view and dialog
  final PageController detailPageController = PageController();
  final PageController dialogPageController = PageController();
  final RxInt currentPage = 0.obs;

  final int pageSize = 100;
  DocumentSnapshot? lastDocument;

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
  Future<void> loadPosts({bool isRefresh = false}) async {
    try {
      if (isRefresh) {
        lastDocument = null;
        allPosts.clear();
        hasMorePosts.value = true;
      }

      if (!hasMorePosts.value) return;

      isLoading.value = true;
      error.value = '';

      Query query = FirebaseFirestore.instance
          .collection('posts')
          .orderBy('createdAt', descending: true)
          .limit(pageSize);

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();
      final List<Post> newPosts = querySnapshot.docs.map((doc) {
        return Post.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();

      if (newPosts.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        allPosts.addAll(newPosts);
      } else {
        hasMorePosts.value = false;
      }
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
      update(); // Update the controller to refresh the UI
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts(isRefresh: true);
  }

  Future<void> loadMorePosts() async {
    if (!isLoading.value) {
      await loadPosts();
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
