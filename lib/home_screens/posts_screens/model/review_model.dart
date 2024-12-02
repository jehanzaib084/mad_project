// lib/home_screens/posts_screens/model/review_model.dart

class Review {
  final String userId;
  final String userName;
  final String userEmail;
  final String comment;
  final double rating;
  final String date;

  Review({
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.comment,
    required this.rating,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      userId: json['userId'],
      userName: json['userName'],
      userEmail: json['userEmail'],
      comment: json['comment'],
      rating: json['rating'].toDouble(),
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'comment': comment,
      'rating': rating,
      'date': date,
    };
  }
}