import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:mad_project/home_screens/posts_screens/controller/favorite_controller.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/view/image_carousel_dialog.dart';
import 'package:mad_project/home_screens/posts_screens/view/reviews_list.dart';

class PostDetailView extends StatelessWidget {
  final Post post;
  final bool isLoved;
  final VoidCallback onLoveToggle;
  final PostController controller = Get.find<PostController>();
  final FavoriteController favoriteController = Get.find<FavoriteController>();
  final RxBool isDescriptionExpanded = false.obs;

  PostDetailView({
    required this.post,
    required this.isLoved,
    required this.onLoveToggle,
    super.key,
  });

  Widget _buildDescription(BuildContext context) {
    final descriptionWords = post.description.split(' ');
    final wordLimit = 30;
    final hasMoreText = descriptionWords.length > wordLimit;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.propertyName),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: GetX<FavoriteController>(
                builder: (controller) => IconButton(
                  icon: Icon(
                    controller.isFavorite(post.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: controller.isFavorite(post.id)
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () => controller.toggleFavorite(post),
                ),
              ),
            ),
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
                CarouselSlider.builder(
                  itemCount: post.images.length,
                  options: CarouselOptions(
                    height: 250,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) =>
                        controller.currentPage.value = index,
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return GestureDetector(
                      onTap: () => Get.dialog(
                        ImageCarouselDialog(
                          images: post.images,
                          initialIndex: controller.currentPage.value,
                        ),
                      ),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SmoothPageIndicator(
                    controller: controller.detailPageController,
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
                      _buildAmenityItem(Icons.lightbulb, 'Light: ${post.light ? "Yes" : "No"}'),
                      _buildAmenityItem(Icons.water_drop, 'Water: ${post.water ? "Yes" : "No"}'),
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
                  Text('Garage: ${post.garage ? "Yes" : "No"}'),
                  Text('Kitchen: ${post.kitchen ? "Yes" : "No"}'),
                  Text('Gyser: ${post.gyser ? "Yes" : "No"}'),
                  Text('WiFi Details: ${post.hasWifi ? post.wifiDetails : "No"}'),
                  Text('Meals Included: ${post.mealsIncluded ? post.mealDetails : "No"}'),
                  Text('Number of Persons per Room: ${post.studentsPerRoom}'),
                  Text('Location: ${post.location}'),

                  const Divider(),

                  // Contact Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            controller.launchWhatsApp(post.ownerPhone),
                        icon: const Icon(Icons.wechat),
                        label: const Text('WhatsApp'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => controller.launchCall(post.ownerPhone),
                        icon: const Icon(Icons.phone),
                        label: const Text('Call'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  const Divider(),

                  // Reviews Section
                  ListTile(
                    title: Text('Reviews (${post.reviews.length})'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () =>
                        Get.to(() => ReviewsList(reviews: post.reviews)),
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
}