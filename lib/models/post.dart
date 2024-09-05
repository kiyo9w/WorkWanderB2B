import 'package:firebase_database/firebase_database.dart';

class Post {
  final String id;
  final String userId;
  final String content;
  final List<String> photoUrls; // Change this from String? to List<String>
  final String? salaryRange;
  final String? expertise;
  final DateTime? deadline;
  final String? location;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.content,
    required this.photoUrls,
    this.salaryRange,
    this.expertise,
    this.deadline,
    this.location,
    required this.timestamp,
  });

  factory Post.fromSnapshot(String key, Map<dynamic, dynamic> value) {
    return Post(
      id: key,
      userId: value['userId'] ?? '',
      content: value['content'] ?? '',
      photoUrls: List<String>.from(value['photoUrls'] ?? []),
      salaryRange: value['salaryRange'],
      expertise: value['expertise'],
      deadline: value['deadline'] != null ? DateTime.parse(value['deadline']) : null,
      location: value['location'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(value['timestamp'] ?? 0),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'photoUrls': photoUrls,
      'salaryRange': salaryRange,
      'expertise': expertise,
      'deadline': deadline?.toIso8601String(),
      'location': location,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }
}