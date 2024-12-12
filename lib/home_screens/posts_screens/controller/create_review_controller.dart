// create_review_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/model/review_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateReviewController extends GetxController {
  final Post post;

  final TextEditingController commentController = TextEditingController();
  final RxDouble rating = 0.0.obs;
  final RxBool isSubmitting = false.obs;
  final RxBool isSubmitted = false.obs;

  CreateReviewController({
    required this.post,
  });

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  Future<void> submitReview() async {
    if (isSubmitted.value) return; // Prevent multiple submissions
    if (rating.value == 0) {
      Get.snackbar(
        'Rating Required',
        'Please add a rating to continue',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
      return;
    }

    if (commentController.text.trim().isEmpty) {
      Get.snackbar(
        'Comment Required',
        'Please add a comment to continue',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
      return;
    }

    isSubmitting.value = true;

    try {
      final postController = Get.find<PostController>();
      final user = postController.currentUser;
      if (user == null) {
        Get.snackbar(
          'Authentication Error',
          'Please login to add a review',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
        return;
      }

      // Format date properly
      final now = DateTime.now();
      final formattedDate = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

      final review = Review(
        userId: user.uid,
        userName: '${await _getFirstName()} ${await _getLastName()}',
        userEmail: user.email ?? '',
        comment: commentController.text.trim(),
        rating: rating.value,
        date: formattedDate,
      );

      final result = await postController.addReview(post.id, review);
      if (result) {
        await postController.recalculateRating(post.id);
        isSubmitted.value = true; // Set submitted flag
        Get.snackbar(
          'Success',
          'Your review has been submitted successfully',
          backgroundColor: Colors.green.withOpacity(0.5),
          colorText: Colors.white,
        );
        FocusScope.of(Get.context!).unfocus(); // Hide keyboard
        Get.back(result: true); // Navigate back to reviews list
      } else {
        Get.snackbar(
          'Error',
          'Failed to submit review. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.5),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        backgroundColor: Colors.red.withOpacity(0.5),
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<String> _getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('firstName') ?? 'Anonymous';
  }

  Future<String> _getLastName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('lastName') ?? '';
  }
}