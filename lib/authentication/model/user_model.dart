class UserModel {
  String uid;
  String firstName;
  String lastName;
  int age;
  String phoneNumber;
  String email;
  String profilePicUrl;

  UserModel({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.phoneNumber,
    required this.email,
    required this.profilePicUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'phoneNumber': phoneNumber,
      'email': email,
      'profilePicUrl': profilePicUrl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      age: map['age'],
      phoneNumber: map['phoneNumber'],
      email: map['email'],
      profilePicUrl: map['profilePicUrl'],
    );
  }
}