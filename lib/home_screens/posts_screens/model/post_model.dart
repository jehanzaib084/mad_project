// post_model.dart
import 'package:mad_project/home_screens/posts_screens/model/review_model.dart';

class Post {
  final String id;
  final String userId;
  final String propertyName;
  final String propertyType;
  final String description;
  final List<String> images;
  final bool garage;
  final bool light;
  final bool water;
  final bool kitchen;
  final bool gyser;
  final String price;
  final String rating;
  final String ownerPhone;
  final String location;
  final bool hasWifi;
  final bool mealsIncluded;
  final int studentsPerRoom;
  final List<Review> reviews;
  final String wifiDetails;
  final String mealDetails;
  final String gender;
  final String email;
  final String createdAt;
  final int views;
  final List<String> viewedBy;

  Post({
    required this.id,
    required this.userId,
    required this.propertyName,
    required this.propertyType,
    required this.description,
    required this.images,
    required this.garage,
    required this.light,
    required this.water,
    required this.email,
    required this.kitchen,
    required this.gyser,
    required this.price,
    required this.rating,
    required this.ownerPhone,
    required this.location,
    required this.hasWifi,
    required this.mealsIncluded,
    required this.studentsPerRoom,
    required this.reviews,
    required this.wifiDetails,
    required this.mealDetails,
    required this.gender,
    required this.createdAt,
    this.views = 0,
    this.viewedBy = const [],
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      propertyName: json['propertyName']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? [],
      garage: json['garage'] ?? false,
      light: json['light'] ?? false,
      water: json['water'] ?? false,
      kitchen: json['kitchen'] ?? false,
      gyser: json['gyser'] ?? false,
      price: json['price']?.toString() ?? '',
      rating: json['rating']?.toString() ?? '0.0',
      ownerPhone: json['ownerPhone']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      hasWifi: json['hasWifi'] ?? false,
      mealsIncluded: json['mealsIncluded'] ?? false,
      studentsPerRoom: json['studentsPerRoom'] ?? 1,
      reviews: (json['reviews'] as List?)?.map((review) => Review.fromJson(review)).toList() ?? [],
      wifiDetails: json['wifiDetails']?.toString() ?? 'Not available',
      mealDetails: json['mealDetails']?.toString() ?? 'Not included',
      gender: json['gender']?.toString() ?? 'boys',
      createdAt: '',
      views: json['views'] ?? 0,
      viewedBy: List<String>.from(json['viewedBy'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'userId': userId,
      'propertyName': propertyName,
      'propertyType': propertyType,
      'description': description,
      'images': images,
      'garage': garage,
      'light': light,
      'water': water,
      'kitchen': kitchen,
      'gyser': gyser,
      'price': price,
      'rating': rating,
      'ownerPhone': ownerPhone,
      'location': location,
      'hasWifi': hasWifi,
      'mealsIncluded': mealsIncluded,
      'studentsPerRoom': studentsPerRoom,
      'reviews': reviews.map((review) => review.toJson()).toList(),
      'wifiDetails': wifiDetails,
      'mealDetails': mealDetails,
      'gender': gender,
      'createdAt': createdAt,
      'views': views,
      'viewedBy': viewedBy,
    };
  }
}