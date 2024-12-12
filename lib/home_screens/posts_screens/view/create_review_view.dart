// create_review_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/create_review_controller.dart';

class CreateReviewView extends StatelessWidget {
  final controller = Get.put(CreateReviewController(
    post: Get.arguments['post'],
  ));

  CreateReviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Review'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Rate the property',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return IconButton(
                      icon: Icon(
                        index < controller.rating.value
                            ? Icons.star
                            : Icons.star_border,
                        color: Colors.amber,
                      ),
                      onPressed: () => controller.rating.value = index + 1.0,
                    );
                  }),
                )),
            const SizedBox(height: 16),
            TextField(
              controller: controller.commentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Comment',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => ElevatedButton(
                      onPressed: (controller.isSubmitting.value ||
                              controller.isSubmitted.value)
                          ? null
                          : controller.submitReview,
                      child: controller.isSubmitting.value
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Text(controller.isSubmitted.value
                              ? 'Review Submitted'
                              : 'Submit Review'),
                    )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
