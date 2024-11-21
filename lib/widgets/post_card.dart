import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/create_screen.dart';
import '../services/firebase_service.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onDelete;

  const PostCard({Key? key, required this.post, required this.onDelete}) : super(key: key);

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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CreateScreen(
                          isEditing: true,
                          post: post,
                        ),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deletePost(context, post.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
  void _deletePost(BuildContext context, String postId) {
    FirebaseService.deletePost(postId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully!')),
      );
      onDelete(); // Call the refresh callback here
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post.')),
      );
    });
  }
}