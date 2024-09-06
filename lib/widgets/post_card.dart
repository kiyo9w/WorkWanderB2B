import 'package:flutter/material.dart';
import '../models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            if (post.photoUrls.isNotEmpty)
              Image.network(
                post.photoUrls.first,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            SizedBox(height: 8),
            if (post.salaryRange != null)
              Text('Salary: ${post.salaryRange}'),
            if (post.expertise != null)
              Text('Expertise: ${post.expertise}'),
            if (post.deadline != null)
              Text('Deadline: ${post.deadline.toString()}'),
            if (post.location != null)
              Text('Location: ${post.location}'),
          ],
        ),
      ),
    );
  }
}