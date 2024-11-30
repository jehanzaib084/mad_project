class Post {
  final String id;
  final String propertyName;
  final String propertyType;
  final String description;
  final String image;
  final String beds;
  final String washrooms;
  final String garage;
  final String gas;
  final String light;
  final String water;
  final String dateRange;
  final String price;
  final String rating;

  Post({
    required this.id,
    required this.propertyName,
    required this.propertyType,
    required this.description,
    required this.image,
    required this.beds,
    required this.washrooms,
    required this.garage,
    required this.gas,
    required this.light,
    required this.water,
    required this.dateRange,
    required this.price,
    required this.rating,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      propertyName: json['propertyName'],
      propertyType: json['propertyType'],
      description: json['description'],
      image: json['image'],
      beds: json['beds'],
      washrooms: json['washrooms'],
      garage: json['garage'],
      gas: json['gas'],
      light: json['light'],
      water: json['water'],
      dateRange: json['dateRange'],
      price: json['price'],
      rating: json['rating'],
    );
  }
}