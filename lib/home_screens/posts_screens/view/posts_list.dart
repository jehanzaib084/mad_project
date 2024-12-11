// posts_list.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/favorite_controller.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/view/post_detail_view.dart';
import 'package:shimmer/shimmer.dart';

class PostsList extends StatelessWidget {
  final PostController postController = Get.put(PostController());

  PostsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Posts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: postController.refreshPosts,
        child: Obx(() {
          if (postController.isLoading.value && postController.allPosts.isEmpty) {
            return _buildLoadingShimmer();
          }
      
          if (postController.error.value.isNotEmpty) {
            return _buildErrorView(postController.error.value);
          }
      
          if (postController.allPosts.isEmpty) {
            return _buildEmptyView();
          }
      
          return NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
                  !postController.isLoading.value) {
                postController.loadMorePosts();
              }
              return false;
            },
            child: ListView.builder(
              itemCount: postController.allPosts.length + 1,
              itemBuilder: (context, index) {
                if (index == postController.allPosts.length) {
                  return _buildLoadingIndicator();
                }
                final post = postController.allPosts[index];
                return _buildPostCard(post);
              },
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (_, __) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: SizedBox(
              height: 300,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorView(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: postController.loadPosts,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.hourglass_empty, size: 60),
        SizedBox(height: 16),
        Text('No posts available'),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: postController.refreshPosts,
          icon: Icon(Icons.refresh),
          label: Text('Reload'),
        ),
      ],
    ),
  );
}

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return GestureDetector(
      onTap: () => Get.to(() => PostDetailView(
            post: post,
            isLoved: false,
            onLoveToggle: () {},
          )),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostImage(post),
              _buildPostDetails(post),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostImage(Post post) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Image.memory(
            base64Decode(post.images.first),
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.error),
            ),
          ),
        ),
        // Add favorite button overlay
        Positioned(
          top: 8,
          right: 8,
          child: GetX<FavoriteController>(
            builder: (controller) => CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
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
    );
  }

  Widget _buildPostDetails(Post post) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.propertyName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  post.location,
                  style: const TextStyle(color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Rs. ${post.price}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}