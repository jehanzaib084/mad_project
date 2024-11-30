import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';

class PostController extends GetxController {
  static const int pageSize = 10;
  final PagingController<int, Post> pagingController = PagingController(firstPageKey: 0);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initializeData();
  }

  Future<void> initializeData() async {
    try {
      await loadPosts(0);
    } catch (e) {
      print('Error initializing data: $e');
    }
  }

  Future<void> loadPosts(int pageKey) async {
    if (isLoading.value) return;
    
    try {
      isLoading.value = true;
      final String response = await rootBundle.loadString('assets/dummy_posts.json');
      final List<dynamic> data = json.decode(response);
      final List<Post> newPosts = data.map((json) => Post.fromJson(json)).toList();

      pagingController.appendPage(newPosts, pageKey + newPosts.length);
    } catch (e) {
      print('Error loading posts: $e');
      pagingController.error = e;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }
}