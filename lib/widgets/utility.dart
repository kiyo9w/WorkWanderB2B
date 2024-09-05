import 'package:flutter/material.dart';
import 'app_color.dart';

class Utils {
  static Widget buildTextField({
      required IconData icon,
      required String label,
      required TextEditingController controller,
      bool obscureText = false,
      double radius = 30.0,
    }) {
      return TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          labelText: label,
          hintText: 'Enter your $label',
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(radius), // Adjust the radius here for roundness
    ),
          filled: true,
          fillColor: AppColors.darkWhiteColor,
        ),
      );
    }

  static Widget buildProfilePicture({
      required String sourceimage,
      required String name,
      required double radius,
    })
    {
      return Padding (
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6.0, vertical: 8.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: radius,
                          backgroundImage: NetworkImage(sourceimage),
                        ),
                        SizedBox(height: 4.0),
                        Flexible(
                            child: Text(name,
                                style: TextStyle(fontSize: 16.0)))
                      ],
                    ),
                  );
    }

  static Widget buildCoverImage({
      required String imagesource,
      required double coverHeight,
    }) {
      return Container(
        color: Colors.grey,
        child: Image.asset(
          imagesource,
          width: double.infinity,
          height: coverHeight,
          fit: BoxFit.cover 
        ),
    );
  }

  static Widget buildNotificationItem({
    required avatarUrl,
    required userName,
    required notificationText,
    required time,
    required isRead,
    required onTap,
    required onMoreOptionsPressed,
  }) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(
        '$userName $notificationText',
        style: TextStyle(
          fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
          color: isRead ? Colors.grey : Colors.black,
        ),
      ),
      subtitle: Text(
        time,
        style: TextStyle(
          color: isRead ? Colors.grey : Colors.black,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.more_horiz),
        onPressed: onMoreOptionsPressed,
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      dense: true,
      visualDensity: VisualDensity(vertical: -1),
      tileColor: isRead ? Colors.transparent : Colors.blue.withOpacity(0.05),
    );
  }
}