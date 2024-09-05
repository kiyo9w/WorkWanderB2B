import 'package:flutter/material.dart';
import '../models/post.dart';

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: _buildPhotoGrid(),
              ),
            if (post.salaryRange != null)
              Text('Salary Range: ${post.salaryRange}'),
            if (post.expertise != null)
              Text('Expertise: ${post.expertise}'),
            if (post.deadline != null)
              Text('Deadline: ${post.deadline!.toLocal()}'),
            if (post.location != null)
              Text('Location: ${post.location}'),
            SizedBox(height: 8),
            Text(
              'Posted on ${post.timestamp.toLocal()}',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: post.photoUrls.length == 1 ? 1 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: post.photoUrls.length == 1 ? 16 / 9 : 1,
      ),
      itemCount: post.photoUrls.length,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            post.photoUrls[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}