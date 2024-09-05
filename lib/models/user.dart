import 'package:firebase_database/firebase_database.dart';

class User {
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String avatarLink;
  final String companyName;
  final String? coverImageUrl;
  final String? location;
  final int friendsCount;

  User({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.avatarLink,
    required this.companyName,
    this.coverImageUrl,
    this.location,
    this.friendsCount = 0,
  });

  String get fullName => '$firstName $lastName';

  factory User.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic> value = snapshot.value as Map<dynamic, dynamic>;
    return User(
      uid: snapshot.key ?? '',
      firstName: value['firstName'] ?? '',
      lastName: value['lastName'] ?? '',
      email: value['email'] ?? '',
      avatarLink: value['avatarLink'] ?? '',
      companyName: value['companyName'] ?? '',
      coverImageUrl: value['coverImageUrl'],
      location: value['location'],
      friendsCount: value['friendsCount'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'avatarLink': avatarLink,
      'companyName': companyName,
      'coverImageUrl': coverImageUrl,
      'location': location,
      'friendsCount': friendsCount,
    };
  }
}
