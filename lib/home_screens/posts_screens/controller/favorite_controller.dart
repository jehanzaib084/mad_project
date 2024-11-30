import 'dart:convert';
import 'package:get/get.dart';
import 'package:mad_project/home_screens/posts_screens/model/post_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  final RxMap<String, Post> _favorites = <String, Post>{}.obs;

  List<Post> get favorites => _favorites.values.toList();

  bool isFavorite(String postId) => _favorites.containsKey(postId);

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  void toggleFavorite(Post post) {
    if (isFavorite(post.id)) {
      _favorites.remove(post.id);
    } else {
      _favorites[post.id] = post;
    }
    _saveFavorites();
    update();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = _favorites.values.map((post) => json.encode(post.toJson())).toList();
    await prefs.setStringList('favorites', favoriteList);
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteList = prefs.getStringList('favorites') ?? [];
    _favorites.clear();
    for (var postJson in favoriteList) {
      final post = Post.fromJson(json.decode(postJson));
      _favorites[post.id] = post;
    }
  }
}