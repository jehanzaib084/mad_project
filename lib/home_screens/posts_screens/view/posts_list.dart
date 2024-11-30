import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mad_project/home_screens/posts_screens/controller/posts_screen_controller.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/posts_screens/view/post_detail_view.dart';
import 'package:shimmer/shimmer.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
            onPressed: () {
              // Handle notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter
            },
          ),
        ],
      ),
      body: Obx(() {
        if (postController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (postController.pagingController.itemList == null ||
            postController.pagingController.itemList!.isEmpty) {
          return Center(
            child: Text(
              'No posts available',
              style: Theme.of(context).textTheme.titleLarge,
            ),
          );
        } else {
          return PagedListView<int, Post>(
            pagingController: postController.pagingController,
            builderDelegate: PagedChildBuilderDelegate<Post>(
              itemBuilder: (context, post, index) => GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PostDetailView(
                        post: post,
                        isLoved: false,
                        onLoveToggle: () {},
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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
                              imageBuilder: (context, imageProvider) =>
                                  Container(
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
                                child:
                                    const Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.yellow,
                                  ),
                                  onPressed: () {},
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            post.dateRange,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
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
                ),
              ),
              firstPageProgressIndicatorBuilder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
              newPageProgressIndicatorBuilder: (context) => Center(
                child: CircularProgressIndicator(),
              ),
              firstPageErrorIndicatorBuilder: (context) => Center(
                child: Text(
                  'Error loading posts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              newPageErrorIndicatorBuilder: (context) => Center(
                child: Text(
                  'Error loading more posts',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}
