import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:mad_project/home_screens/crud_post_screens/view/my_post_detail_view.dart';
import 'package:mad_project/home_screens/master_nav/controller/master_nav_controller.dart';

class MyPostsScreen extends StatelessWidget {
  const MyPostsScreen({super.key});

  int _calculateTotalViews(List<Post> posts) {
    // ignore: avoid_types_as_parameter_names
    return posts.fold(0, (sum, post) => sum + post.views);
  }

// Replace the existing Dashboard section with this new implementation
  Widget _buildDashboard(BuildContext context, List<Post> posts) {
    final totalViews = _calculateTotalViews(posts);

    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.dashboard, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            Divider(height: 24),
            GridView.count(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
              children: [
                _buildStatCard(
                  context,
                  'Total Posts',
                  '${posts.length}',
                  Icons.post_add,
                  Colors.blue,
                ),
                _buildStatCard(
                  context,
                  'Total Views',
                  '$totalViews',
                  Icons.visibility,
                  Colors.green,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value,
      IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final MasterNavController navController = Get.find();

    Widget buildPostCard(Post post) {
      return GestureDetector(
        onTap: () => Get.to(() => MyPostDetailView(post: post)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(15)),
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
                // Details Section
                Padding(
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
                          const Icon(Icons.location_on,
                              size: 16, color: Colors.grey),
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
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('My Posts'),
      ),
      body: user == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Please login to view your posts'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Get.toNamed('/login'),
                    child: Text('Login'),
                  ),
                ],
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .where('email', isEqualTo: user.email)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('No posts yet'),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => navController.goToCreatePost(),
                          child: Text('Create Post'),
                        ),
                      ],
                    ),
                  );
                }

                final posts = snapshot.data!.docs.map((doc) {
                  return Post.fromJson(doc.data() as Map<String, dynamic>);
                }).toList();

                return ListView(
                  children: [
                    _buildDashboard(context, posts),
                    ...posts.map((post) => buildPostCard(post)),
                  ],
                );
              },
            ),
      floatingActionButton: user != null
          ? FloatingActionButton(
              onPressed: () => navController.goToCreatePost(),
              child: Icon(Icons.add),
            )
          : null,
    );
  }
}
