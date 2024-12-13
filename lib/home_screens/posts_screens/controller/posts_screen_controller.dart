// post_screen_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/model/review_model.dart';
import 'package:mad_project/utils/logging.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum PostFilter { recent, popular, hot }

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

  final int pageSize = 4;
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

  User? get currentUser => FirebaseAuth.instance.currentUser;

  final RxBool isSubmittingReview = false.obs;

  final Rx<List<Review>> currentPostReviews = Rx<List<Review>>([]);

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

  final RxBool isLoadingMore = false.obs;

  Future<void> loadMorePosts() async {
    if (!hasMorePosts.value || isLoadingMore.value) return;

    isLoadingMore.value = true;
    await loadPosts();
    isLoadingMore.value = false;
  }

  // Initialize data, load posts once
  Future<void> initializeData() async {
    try {
      await loadPosts(); // Load posts directly, no pagination needed
    } catch (e) {
      Get.snackbar('Error initializing data: $e', 'We are very sorry',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,);
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

// Apply filters
      switch (currentFilter.value) {
        case PostFilter.recent:
          query = query.orderBy('createdAt', descending: true);
          break;
        case PostFilter.popular:
          query = query
              .where('rating', isGreaterThan: '0.0')
              .orderBy('rating', descending: true);
          break;
        case PostFilter.hot:
          query = query
              .where('views', isGreaterThan: 0)
              .orderBy('views', descending: true);
          break;
      }

      query = query.limit(pageSize);
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }

      final querySnapshot = await query.get();
      final List<Post> newPosts = querySnapshot.docs
          .map((doc) => Post.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (newPosts.isNotEmpty) {
        lastDocument = querySnapshot.docs.last;
        allPosts.addAll(newPosts);
      } else {
        hasMorePosts.value = false;
      }
    } catch (e) {
      error.value = 'Failed to load posts: $e';
      Get.snackbar('Error', 'Failed to load posts', backgroundColor: Colors.red.withOpacity(0.5),colorText: Colors.white,);
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts(isRefresh: true);
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

    // First check: Don't increment if user is owner or has viewed
    if (post.userId == user.uid) {
      logger.i('Post owner viewing - no increment');
      return;
    }

    try {
      // Get latest post data to ensure accurate viewedBy check
      final postDoc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .get();

      if (!postDoc.exists) return;

      final currentPost = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      // Second check: Verify user hasn't already viewed
      if (currentPost.viewedBy.contains(user.uid)) {
        logger.i('User already viewed - no increment');
        return;
      }

      // If checks pass, increment view and add user to viewedBy
      await FirebaseFirestore.instance.collection('posts').doc(post.id).update({
        'views': FieldValue.increment(1),
        'viewedBy': FieldValue.arrayUnion([user.uid])
      });
    } catch (e) {
      logger.e('Error incrementing view: $e');
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
      logger.e('Location error: $e');
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
        "whatsapp://send?phone=+92$formattedNumber&text=Hello, I am interested in your property listing.");
    final whatsappUrlWeb = Uri.parse(
        'https://wa.me/92$formattedNumber?text=Hello, I am interested in your property listing.');

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
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not launch WhatsApp',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    }
  }

  Future<void> updatePostRating(String postId) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      final postDoc = await postRef.get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      if (post.reviews.isEmpty) {
        await postRef.update({'rating': '0.0'});
        return;
      }

      double totalRating =
          post.reviews.map((r) => r.rating).reduce((a, b) => a + b);
      double averageRating = totalRating / post.reviews.length;

      await postRef.update({'rating': averageRating.toStringAsFixed(1)});
    } catch (e) {
      logger.e('Error updating post rating: $e');
    }
  }

  Future<bool> addReview(String postId, Review review) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);

      // Add review
      await postRef.update({
        'reviews': FieldValue.arrayUnion([review.toJson()]),
      });

      // Update average rating
      await updatePostRating(postId);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> recalculateRating(String postId) async {
    try {
      final postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      final postDoc = await postRef.get();
      final post = Post.fromJson(postDoc.data() as Map<String, dynamic>);

      if (post.reviews.isEmpty) {
        await postRef.update({'rating': '0.0'});
        return;
      }

      double totalRating =
          post.reviews.map((r) => r.rating).reduce((a, b) => a + b);
      double averageRating = totalRating / post.reviews.length;

      await postRef.update({'rating': averageRating.toStringAsFixed(1)});
    } catch (e) {
      logger.e('Error recalculating rating: $e');
    }
  }

  Future<void> refreshPostById(String postId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get();

      if (doc.exists) {
        final index = allPosts.indexWhere((post) => post.id == postId);
        if (index != -1) {
          allPosts[index] = Post.fromJson(doc.data() as Map<String, dynamic>);
          update();
        }
      }
    } catch (e) {
      logger.e('Error refreshing post: $e');
    }
  }

  Future<void> startReviewsStream(String postId) async {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final post = Post.fromJson(snapshot.data() as Map<String, dynamic>);
        currentPostReviews.value = post.reviews;
        updatePostRating(postId); // Ensure rating is updated reactively
      }
    });
  }

  @override
  void dispose() {
    detailPageController.dispose();
    dialogPageController.dispose();
    super.dispose();
  }
}
