import 'package:flutter/material.dart';
import '../models/post.dart';
import '../screens/create_screen.dart';
import '../services/firebase_service.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback onDelete;

  const PostCard({Key? key, required this.post, required this.onDelete}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section: Profile Picture, Name, and Edit/Delete Buttons
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    'https://i.pinimg.com/736x/2c/9b/d4/2c9bd4b21fb4d0e3dfda41946e7ce3b1.jpg',
                  ),
                  radius: 20,
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ngo Trung', // Placeholder for the user name
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        DateFormat('yMMMd').format(post.timestamp),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Edit and Delete Buttons
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
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
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _deletePost(context, post.id);
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            // Content Section: Post Content
            if (post.content.isNotEmpty)
              Text(
                post.content,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  color: Colors.black87,
                ),
              ),
            if (post.content.isNotEmpty) SizedBox(height: 12),

            // Inline Photo Display
            if (post.photoUrls.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  post.photoUrls.first,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (post.photoUrls.isNotEmpty) SizedBox(height: 12),

            // Additional Info Section: Salary, Expertise, Location
            if (post.salaryRange != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.attach_money, size: 18, color: Colors.orange),
                    SizedBox(width: 4),
                    Text(
                      'Salary: ${post.salaryRange}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            if (post.expertise != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.work_outline, size: 18, color: Colors.blue),
                    SizedBox(width: 4),
                    Text(
                      'Expertise: ${post.expertise}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            if (post.location != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.location_on, size: 18, color: Colors.red),
                    SizedBox(width: 4),
                    Text(
                      'Location: ${post.location}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

            SizedBox(height: 20),

            // Deadline Section: Displaying the deadline field separately
            if (post.deadline != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 18, color: Colors.purple),
                    SizedBox(width: 4),
                    Text(
                      'Deadline: ${DateFormat('E, MMM d yyyy').format(post.deadline!)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
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
