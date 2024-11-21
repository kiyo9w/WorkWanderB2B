import 'package:flutter/material.dart';
import '../services/firebase_service.dart';
import '../models/post.dart';
import '../widgets/post_card.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> _posts = [];
  bool _isLoading = false;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    _startAutoRefresh();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer to avoid calling setState after the widget is disposed.
    super.dispose();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      _isLoading = true;
    }
  );
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

  void _startAutoRefresh() {
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      _fetchPosts();
    });
  }

  Future<void> _onRefresh() async {
    await _fetchPosts();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _posts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return PostCard(post: _posts[index], onDelete: () {
                    _fetchPosts();
                  },);
                },
              ),
      ),
    );
  }
}