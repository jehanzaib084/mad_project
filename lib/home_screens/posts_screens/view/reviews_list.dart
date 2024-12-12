// reviews_list.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/view/create_review_view.dart';

class ReviewsList extends StatelessWidget {
  final Post post;

  ReviewsList({required this.post, super.key}) {
    // Start listening to reviews when screen opens
    Get.find<PostController>().startReviewsStream(post.id);
  }

  @override
  Widget build(BuildContext context) {
    final PostController postController = Get.find<PostController>();
    final bool isOwner = postController.currentUser?.uid == post.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      floatingActionButton: Obx(() {
        final hasReviewed = postController.currentPostReviews.value
            .any((review) => review.userEmail == postController.currentUser?.email);

        if (!isOwner && !hasReviewed) {
          return FloatingActionButton(
            onPressed: () => Get.to(
              () => CreateReviewView(),
              arguments: {'post': post},
            ),
            tooltip: 'Add Review',
            child: Icon(Icons.add_comment),
          );
        } else {
          return SizedBox.shrink();
        }
      }),
      body: Obx(() {
        final reviews = postController.currentPostReviews.value;

        if (reviews.isEmpty) {
          return const Center(child: Text('No reviews yet'));
        }

        return ListView.builder(
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.blue,
                        child: Text(
                          review.userName[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  review.date,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: List.generate(5, (starIndex) {
                                return Icon(
                                  starIndex < review.rating
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: const Color.fromARGB(255, 240, 217, 8),
                                  size: 16,
                                );
                              }),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              review.comment,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}