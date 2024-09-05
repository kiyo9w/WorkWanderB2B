import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/post_widget.dart';
import '../widgets/utility.dart';
import '../widgets/app_color.dart';
import '../widgets/bottom_nav_bar.dart';
import '../models/post.dart';
import '../models/contact.dart';
import '../services/firebase_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _unreadMessages = 12;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  List<Contact> _contacts = [];
  List<Post> _posts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _fetchPosts();
  }

  Future<void> _loadContacts() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      final contacts = await FirebaseService.getContacts(userId);
      setState(() {
        _contacts = contacts;
      });
    }
  }

  Future<void> _fetchPosts() async {
    try {
      final posts = await FirebaseService.getPosts();
      setState(() {
        _posts = posts;
      });
      print('Fetched ${posts.length} posts');
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  Future<void> _refreshData() async {
    try {
      await Future.wait([
        _loadContacts(),
        _fetchPosts(),
      ]).timeout(Duration(seconds: 10)); // Add a 10-second timeout
    } catch (e) {
      print('Error refreshing data: $e');
      // Optionally, you can show an error message to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Image.asset('assets/images/logo.jpeg', height: 50, width: 50),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: 32),
            onPressed: () => setState(() => _showSearchBar = !_showSearchBar),
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.messenger_outlined, size: 32),
                onPressed: () {},
              ),
              if (_unreadMessages > 0)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      _unreadMessages.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            if (_showSearchBar)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () => setState(() => _showSearchBar = false),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ),
            SliverToBoxAdapter(
              child: Container(
                height: 100.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _contacts.length,
                  itemBuilder: (context, index) {
                    final contact = _contacts[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: Utils.buildProfilePicture(
                        sourceimage: contact.imageUrl,
                        name: contact.name,
                        radius: 30,
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  if (index < _posts.length) {
                    return PostWidget(post: _posts[index]);
                  } else {
                    return null;
                  }
                },
                childCount: _posts.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
