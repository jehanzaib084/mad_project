// post_model.dart
import 'package:mad_project/home_screens/posts_screens/model/review_model.dart';

class Post {
  final String id;
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

  Post({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.description,
    required this.images,
    required this.garage,
    required this.light,
    required this.water,
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      propertyName: json['propertyName']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
    };
  }
}