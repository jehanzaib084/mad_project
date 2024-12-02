import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/favorite_controller.dart';
import 'package:mad_project/home_screens/posts_screens/view/post_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class FavoritePostsScreen extends StatelessWidget {
  final FavoriteController favoriteController = Get.find<FavoriteController>();

  FavoritePostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Posts'),
      ),
      body: Obx(() {
        final favorites = favoriteController.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'No favorite posts yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        }

        return ListView.builder(
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final post = favorites[index];
            return GestureDetector(
              onTap: () => Get.to(
                () => PostDetailView(
                  post: post,
                  isLoved: true,
                  onLoveToggle: () => favoriteController.toggleFavorite(post),
                ),
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: post.image,
                          imageBuilder: (context, imageProvider) => Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
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
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
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
                                onPressed: () =>
                                    controller.toggleFavorite(post),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            post.propertyName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            post.rating,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.price,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
