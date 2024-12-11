// my_post_detail_view.dart
import 'dart:convert';
import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MyPostDetailView extends StatelessWidget {
  final Post post;

  const MyPostDetailView({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.propertyName),
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
}