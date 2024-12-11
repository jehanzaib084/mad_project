import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mad_project/home_screens/crud_post_screens/controller/create_post_controller.dart';

class MyPostDetailView extends StatelessWidget {
  final Post post;

  const MyPostDetailView({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.propertyName),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editPost(context),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deletePost(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Carousel
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                SizedBox(
                  height: 250,
                  child: PageView.builder(
                    itemCount: post.images.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          base64Decode(post.images[index]),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: Icon(Icons.broken_image, size: 50),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: PageController(),
                    count: post.images.length,
                    effect: const WormEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: Colors.white,
                      dotColor: Colors.white54,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Details
                  Text(
                    post.propertyName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${post.price} - ${post.propertyType}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).primaryColor,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Amenities Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    children: [
                      _buildAmenityItem(Icons.lightbulb, 'Light: ${post.light}'),
                      _buildAmenityItem(Icons.water_drop, 'Water: ${post.water}'),
                      _buildAmenityItem(Icons.wifi, 'WiFi: ${post.hasWifi ? "Yes" : "No"}'),
                    ],
                  ),

                  const Divider(),

                  // Description
                  const SizedBox(height: 16),
                  _buildDescription(context),

                  // Additional Details
                  const SizedBox(height: 16),
                  Text(
                    'Additional Features',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Garage: ${post.garage}'),
                  Text('Kitchen: ${post.kitchen}'),
                  Text('Gyser: ${post.gyser}'),
                  Text('WiFi Details: ${post.hasWifi ? post.wifiDetails : "No"}'),
                  Text('Meals Included: ${post.mealsIncluded ? post.mealDetails : "No"}'),
                  Text('Number of Persons per Room: ${post.studentsPerRoom}'),
                  Text('Location: ${post.location}'),

                  const Divider(),

                  // Contact Information
                  const SizedBox(height: 16),
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Phone: ${post.ownerPhone}',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String text) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescription(BuildContext context) {
    final descriptionWords = post.description.split(' ');
    final wordLimit = 30;
    final hasMoreText = descriptionWords.length > wordLimit;
    final isDescriptionExpanded = false.obs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Obx(() => RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium,
                children: [
                  TextSpan(
                    text: isDescriptionExpanded.value || !hasMoreText
                        ? post.description
                        : '${descriptionWords.take(wordLimit).join(' ')}... ',
                    style: const TextStyle(color: Colors.black87),
                  ),
                  if (hasMoreText)
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () => isDescriptionExpanded.toggle(),
                        child: Text(
                          isDescriptionExpanded.value
                              ? 'Show less'
                              : 'Show more',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )),
      ],
    );
  }

  void _editPost(BuildContext context) {
    final CreatePostController createPostController = Get.put(CreatePostController());
    createPostController.propertyNameController.text = post.propertyName;
    createPostController.propertyTypeController.text = post.propertyType;
    createPostController.descriptionController.text = post.description;
    createPostController.priceController.text = post.price;
    createPostController.locationController.text = post.location;
    createPostController.phoneController.text = post.ownerPhone;
    createPostController.base64Images.value = post.images;
    createPostController.facilities['garage']?.value = post.garage;
    createPostController.facilities['light']?.value = post.light;
    createPostController.facilities['water']?.value = post.water;
    createPostController.facilities['kitchen']?.value = post.kitchen;
    createPostController.facilities['gyser']?.value = post.gyser;
    createPostController.features['hasWifi']?.value = post.hasWifi;
    createPostController.features['mealsIncluded']?.value = post.mealsIncluded;
    createPostController.features['studentsPerRoom']?.value = post.studentsPerRoom;
    createPostController.features['gender']?.value = post.gender;

    Get.toNamed('/create_post', arguments: post);
  }

  void _deletePost(BuildContext context) async {
    final bool? result = await Get.dialog<bool>(
      AlertDialog(
        title: Text('Delete Post'),
        content: Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await FirebaseFirestore.instance.collection('posts').doc(post.id).delete();
        Get.back();
        Get.snackbar(
          'Success',
          'Post deleted successfully',
          backgroundColor: Colors.green.withOpacity(0.1),
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to delete post: $e',
          backgroundColor: Colors.red.withOpacity(0.1),
        );
      }
    }
  }
}