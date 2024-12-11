// posts_list.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/controller/favorite_controller.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/view/post_detail_view.dart';
import 'package:shimmer/shimmer.dart';

// In PostsList widget
class PostsList extends StatelessWidget {
  final PostController postController = Get.put(PostController());
  final FavoriteController favoriteController = Get.put(FavoriteController());

  PostsList({super.key});

  Widget _buildFilterTabs() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildFilterTab(PostFilter.recent, 'Recent', Icons.access_time),
          _buildFilterTab(PostFilter.popular, 'Popular', Icons.trending_up),
          _buildMoreFiltersButton(),
        ],
      ),
    );
  }

  Widget _buildFilterTab(PostFilter filter, String label, IconData icon) {
    return Obx(() {
      final isSelected = postController.currentFilter.value == filter;
      final isDisabled = postController.hasActiveDialogFilters;
      
      return InkWell(
        onTap: isDisabled ? null : () => postController.changeFilter(filter),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected && !isDisabled 
                ? Colors.blue 
                : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDisabled 
                  ? Colors.grey 
                  : isSelected ? Colors.white : Colors.black,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: isDisabled 
                    ? Colors.grey
                    : isSelected ? Colors.white : Colors.blueGrey,
              ),
              SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: isDisabled 
                      ? Colors.grey
                      : isSelected ? Colors.white : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildMoreFiltersButton() {
    return Obx(() {
      final hasActiveFilters =
          postController.dialogFilters.values.any((v) => v) ||
              postController.priceSort.value.isNotEmpty;
      return InkWell(
        onTap: () => _showFilterDialog(Get.context!),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: hasActiveFilters ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasActiveFilters ? Colors.white : Colors.black,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune,
                size: 16,
                color: hasActiveFilters ? Colors.white : Colors.blueGrey,
              ),
              SizedBox(width: 4),
              Text(
                'Filters',
                style: TextStyle(
                  color: hasActiveFilters ? Colors.white : Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showFilterDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        titlePadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              topRight: Radius.circular(15),
            ),
          ),
          child: Text(
            'Filter Options',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFilterSection(
                  context,
                  'Price Sort',
                  Obx(() => Column(
                        children: [
                          RadioListTile<String>(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            title: Text('Low to High',
                                style: TextStyle(fontSize: 14)),
                            value: 'asc',
                            groupValue: postController.priceSort.value,
                            onChanged: (val) =>
                                postController.priceSort.value = val!,
                          ),
                          RadioListTile<String>(
                            dense: true,
                            contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            title: Text('High to Low',
                                style: TextStyle(fontSize: 14)),
                            value: 'desc',
                            groupValue: postController.priceSort.value,
                            onChanged: (val) =>
                                postController.priceSort.value = val!,
                          ),
                        ],
                      )),
                ),
                SizedBox(height: 12),
                _buildFilterSection(
                  context,
                  'Facilities',
                  Column(
                    children: postController.dialogFilters.entries
                        .map(
                          (e) => Obx(() => CheckboxListTile(
                                dense: true,
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                title: Text(
                                  e.key.capitalizeFirst!,
                                  style: TextStyle(fontSize: 14),
                                ),
                                value: postController.dialogFilters[e.key],
                                onChanged: (val) =>
                                    postController.dialogFilters[e.key] = val!,
                              )),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  postController.dialogFilters.updateAll((key, value) => false);
                  postController.priceSort.value = '';
                  Get.back();
                  postController.refreshPosts();
                },
                child: Text('Clear All'),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Clear tab filters when applying dialog filters
                      postController.currentFilter.value = PostFilter.recent;
                      Get.back();
                      postController.refreshPosts();
                    },
                    child: Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
      BuildContext context, String title, Widget content) {
    return Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8, bottom: 4),
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            content,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Posts'),
        actions: [
          Obx(() => GestureDetector(
                onTap: () {
                  if (postController.currentCity.value == 'Location Unavailable') {
                    Get.snackbar(
                      'Location Disabled',
                      'Please enable location services.',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    // Handle location tap - implement map view later
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Row(
                    children: [
                      Icon(Icons.location_on, size: 16),
                      Text(
                        postController.currentCity.value,
                        style: TextStyle(
                          fontSize: 16,
                          // color: Colors.white,
                          // decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Divider(height: 6),
          Expanded(
            child: RefreshIndicator(
              onRefresh: postController.refreshPosts,
              child: Obx(() {
                if (postController.isLoading.value &&
                    postController.allPosts.isEmpty) {
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
                    if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent &&
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
          ),
        ],
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