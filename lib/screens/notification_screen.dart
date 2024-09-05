import 'package:flutter/material.dart';
import '../widgets/utility.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _selectedIndex = 1; // Set the initial index to 1 (Notification)

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Notifications'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search action
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Handle settings action
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: 10, // Number of notifications, adjust as needed
        itemBuilder: (context, index) {
          return Utils.buildNotificationItem(
            avatarUrl: 'https://picsum.photos/id/137/2000/300', // Profile picture URL
            userName: 'John Doe',
            notificationText: 'Liked your post',
            time: '2h ago',
            isRead: index.isEven ? true : false, // Simulating read and unread notifications
            onTap: () {
              // Handle notification tap
            },
            onMoreOptionsPressed: () {
              // Handle more options press
            },
          );
        },
      ),
    );
  }
}