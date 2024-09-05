import 'package:flutter/material.dart';

class UserInfo extends ChangeNotifier {
  String _uid = '';
  String _firstname = '';
  String _lastname = '';
  String _email = '';
  String _avatarLink = '';

  String get uid => _uid;
  String get firstname => _firstname;
  String get lastname => _lastname;
  String get email => _email;
  String get avatarLink => _avatarLink;
  
  void setUserData(String uid, String firstname, String lastname, String email, String avatarLink) {
    _uid = uid;
    firstname = _firstname;
    lastname = _lastname;
    _email = email;
    _avatarLink = avatarLink;
    notifyListeners();
  }
}