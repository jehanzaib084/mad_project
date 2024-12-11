// import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PostFilter { recent, popular, nearby }

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

  final int pageSize = 2;
  DocumentSnapshot? lastDocument;

  final Rx<PostFilter> currentFilter = PostFilter.recent.obs;
  final RxString currentCity = ''.obs;
  final RxMap<String, bool> additionalFilters = <String, bool>{}.obs;
  final RxString ratingSort = ''.obs; // 'asc' or 'desc'

  final RxMap<String, bool> dialogFilters = <String, bool>{
    'wifi': false,
    'kitchen': false,
    'garage': false,
    'water': false,
    'light': false,
  }.obs;

  final Rx<String> priceSort = ''.obs; // 'asc', 'desc', or ''

  bool get hasActiveDialogFilters =>
      dialogFilters.values.any((v) => v) || priceSort.value.isNotEmpty;

  @override 
  void onInit() {
    super.onInit();
    currentCity.value = 'Lahore'; // Set default
    setupLocationListener();
    getCurrentLocation();
    initializeData();
  }

  void setupLocationListener() {
    // Listen to location service status changes
    Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      if (status == ServiceStatus.enabled) {
        getCurrentLocation();
      }
    });
  }

  // Initialize data, load posts once
  Future<void> initializeData() async {
    try {
      await loadPosts(); // Load posts directly, no pagination needed
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

      Query query = FirebaseFirestore.instance.collection('posts');

      // Apply base query based on active filter type
      if (hasActiveDialogFilters) {
        // Apply dialog filters
        if (priceSort.value.isNotEmpty) {
          query = query.orderBy('price', descending: priceSort.value == 'desc');
        }

        // Apply facility filters
        dialogFilters.forEach((facility, isEnabled) {
          if (isEnabled) {
            query = query.where(facility, isEqualTo: true);
          }
        });
      } else {
        // Apply tab filters
        switch (currentFilter.value) {
          case PostFilter.recent:
            query = query.orderBy('createdAt', descending: true);
            break;
          case PostFilter.popular:
            query = query.orderBy('views', descending: true);
            break;
          case PostFilter.nearby:
            // TODO: Handle this case.
        }
      }

      query = query.limit(pageSize);
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
      Get.snackbar('Error', 'Failed to load posts');
    } finally {
      isLoading.value = false;
      update();
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

  Future<void> incrementPostView(Post post) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Don't increment if user already viewed or is post owner
    if (post.viewedBy.contains(user.uid) || post.userId == user.uid) return;

    try {
      await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
        'views': FieldValue.increment(1),
        'viewedBy': FieldValue.arrayUnion([user.uid])
      });
    } catch (e) {
      print('Error incrementing view: $e');
    }
  }

  void clearAllFilters() {
    dialogFilters.updateAll((key, value) => false);
    priceSort.value = '';
    currentFilter.value = PostFilter.recent;
    refreshPosts();
  }

  Future<void> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          return; // Keep default 'Lahore'
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return; // Keep default 'Lahore'
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      
      if (placemarks.isNotEmpty) {
        currentCity.value = placemarks.first.locality ?? 'Lahore';
      }
    } catch (e) {
      print('Location error: $e');
      // Keep default 'Lahore' on error
    }
  }

  void applyDialogFilters() {
    currentFilter.value = PostFilter.recent;
    refreshPosts();
  }

  void changeFilter(PostFilter filter) {
    // Clear dialog filters when changing tab filters
    dialogFilters.updateAll((key, value) => false);
    priceSort.value = '';

    if (currentFilter.value != filter) {
      currentFilter.value = filter;
      refreshPosts();
    }
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
  // Update launchWhatsApp method in PostController
Future<void> launchWhatsApp(String phoneNumber) async {
  // Format phone number (remove any spaces or special characters)
  final formattedNumber = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
  
  // Create WhatsApp URLs for different scenarios
  final whatsappUrlAndroid = Uri.parse(
    "whatsapp://send?phone=+92$formattedNumber&text=Hello, I am interested in your property listing."
  );
  final whatsappUrlWeb = Uri.parse(
    'https://wa.me/92$formattedNumber?text=Hello, I am interested in your property listing.'
  );

  try {
    // Try launching WhatsApp app first
    if (await canLaunchUrl(whatsappUrlAndroid)) {
      await launchUrl(whatsappUrlAndroid);
    } 
    // If app launch fails, try web version
    else if (await canLaunchUrl(whatsappUrlWeb)) {
      await launchUrl(whatsappUrlWeb);
    } 
    // If both fail, show error
    else {
      Get.snackbar(
        'Error',
        'WhatsApp is not installed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        duration: Duration(seconds: 2),
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Could not launch WhatsApp',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withOpacity(0.1),
      duration: Duration(seconds: 2),
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
