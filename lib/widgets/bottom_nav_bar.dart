import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 10.0,
      unselectedFontSize: 10.0,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled, size: 24.0),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications, size: 24.0),
          label: 'Notifications',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_rounded, size: 24.0),
          label: 'Create',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu, size: 24.0),
          label: 'Following',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 24.0),
          label: 'Profile',
        ),
      ],
    );
  }
}