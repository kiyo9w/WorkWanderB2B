import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/utility.dart';
import '../widgets/app_color.dart';
import '../widgets/round_button.dart';
import '../models/user.dart';
import '../services/firebase_service.dart';
import '../widgets/bottom_nav_bar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  int _selectedIndex = 4;
  bool _showSearchBar = false;
  final TextEditingController _searchController = TextEditingController();
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await FirebaseService.getCurrentUser();
    setState(() {
      _currentUser = user;
    });
  }

  Widget _buildProfileImage() {
    return CircleAvatar(
      radius: 70,
      backgroundImage: AssetImage('assets/images/default_profile.jpeg'),
      child: _currentUser?.avatarLink != null
          ? ClipOval(
              child: Image.network(
                _currentUser!.avatarLink!,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // If network image fails to load, return an empty container
                  // which will show the default image
                  return Container();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 28),
            onPressed: () => setState(() => _showSearchBar = !_showSearchBar),
          ),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.penToSquare, size: 28),
            onPressed: () {
              // Implement edit profile functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_showSearchBar)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    suffixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  children: [
                    Utils.buildCoverImage(
                      imagesource: _currentUser?.coverImageUrl ?? 'assets/images/default_banner.jpeg',
                      coverHeight: 220,
                    ),
                    SizedBox(height: 70), // Space for the avatar to overlap
                  ],
                ),
                Positioned(
                  top: 150,
                  child: _buildProfileImage(),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  Text(
                    _currentUser?.fullName ?? 'Loading...',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _currentUser?.companyName ?? 'Company not available',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${_currentUser?.friendsCount ?? 0} friends',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 16),
                  RoundButton(
                    onPressed: () {
                      // Implement send message functionality
                    },
                    label: 'Send Message',
                    color: Colors.black,
                    width: double.infinity,
                  ),
                ],
              ),
            ),
            // Add more profile information or sections here
          ],
        ),
      ),
    );
  }
}
