import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<Post> posts = await FirebaseService.getPosts();
      setState(() {
        _posts = posts;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching posts: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchPosts,
              child: ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: _posts[index]);
                },
              ),
            ),
    );
  }
}
