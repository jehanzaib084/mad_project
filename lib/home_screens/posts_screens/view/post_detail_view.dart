import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:mad_project/home_screens/posts_screens/controller/favorite_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:shimmer/shimmer.dart';

class PostDetailView extends StatelessWidget {
  final Post post;
  final bool isLoved;
  final VoidCallback onLoveToggle;

  const PostDetailView({
    required this.post,
    required this.isLoved,
    required this.onLoveToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.propertyName),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: post.image,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 16),
              Text(
                post.propertyName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                post.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Beds: ${post.beds}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Washrooms: ${post.washrooms}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Garage: ${post.garage}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gas: ${post.gas}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Light: ${post.light}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Water: ${post.water}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Date Range: ${post.dateRange}',
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Price: ${post.price}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rating: ${post.rating}',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: GetX<FavoriteController>(
                      builder: (controller) => Icon(
                        controller.isFavorite(post.id)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: controller.isFavorite(post.id)
                            ? Colors.red
                            : Colors.grey,
                      ),
                    ),
                    onPressed: () =>
                        Get.find<FavoriteController>().toggleFavorite(post),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
