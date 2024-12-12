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

  String get formattedDate {
    final dateTime = DateTime.parse(date);
    final time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}${dateTime.hour >= 12 ? 'pm' : 'am'}';
    final day = '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    return '$time - $day';
  }
}