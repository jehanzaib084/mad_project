import 'package:mad_project/home_screens/posts_screens/model/review_model.dart';

class Post {
  final String id;
  final String propertyName;
  final String propertyType;
  final String description;
  final String image;
  final List<String> images;
  final String garage;
  final String light;
  final String water;
  final String kitchen;
  final String gyser;
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

  Post({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.description,
    required this.image,
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
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id']?.toString() ?? '',
      propertyName: json['propertyName']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
      images: (json['images'] as List?)?.map((e) => e.toString()).toList() ?? 
             [json['image']?.toString() ?? ''],
      garage: json['garage']?.toString() ?? 'No',
      light: json['light']?.toString() ?? 'No',
      water: json['water']?.toString() ?? 'No',
      kitchen: json['kitchen']?.toString() ?? 'No',
      gyser: json['gyser']?.toString() ?? 'No',
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
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyName': propertyName,
      'propertyType': propertyType,
      'description': description,
      'image': image,
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
    };
  }
}