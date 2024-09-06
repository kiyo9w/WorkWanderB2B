import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String id;
  final String userId;
  final String content;
  final List<String> photoUrls;
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

  factory Post.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Post(
      id: snapshot.id,
      userId: data['userId'] ?? '',
      content: data['content'] ?? '',
      photoUrls: List<String>.from(data['photoUrls'] ?? []),
      salaryRange: data['salaryRange'],
      expertise: data['expertise'],
      deadline: data['deadline'] != null ? (data['deadline'] as Timestamp).toDate() : null,
      location: data['location'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      content: map['content'] ?? '',
      photoUrls: List<String>.from(map['photoUrls'] ?? []),
      salaryRange: map['salaryRange'],
      expertise: map['expertise'],
      deadline: map['deadline'] != null ? (map['deadline'] as Timestamp).toDate() : null,
      location: map['location'],
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'photoUrls': photoUrls,
      'salaryRange': salaryRange,
      'expertise': expertise,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'location': location,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}