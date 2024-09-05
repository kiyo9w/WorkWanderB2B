class Contact {
  final String id;
  final String name;
  final String imageUrl;

  Contact({required this.id, required this.name, required this.imageUrl});

  factory Contact.fromMap(Map<dynamic, dynamic> map) {
    return Contact(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
