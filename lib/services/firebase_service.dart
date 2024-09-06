import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../models/notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FirebaseService {
  static final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  static final DatabaseReference _database = FirebaseDatabase.instance.ref();
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<void> createPost(Post post) async {
    try {
      await _firestore.collection('posts').add(post.toMap());
      print('Post created successfully');
    } catch (e) {
      print('Error creating post: $e');
      rethrow;
    }
  }

  static Future<List<Post>> getPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('posts')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Post.fromMap(doc.data(), doc.id);
      }).toList();
    } catch (e) {
      print('Error fetching posts: $e');
      return [];
    }
  }

  static Future<User?> getCurrentUser() async {
    final auth.User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) {
      print('FirebaseService: No current user found');
      return null;
    }

    print('FirebaseService: Current user UID: ${firebaseUser.uid}');
    print('FirebaseService: Current user email: ${firebaseUser.email}');

    try {
      final snapshot = await _database.child('users').child(firebaseUser.uid).get();
      print('FirebaseService: Snapshot value: ${snapshot.value}');
      if (snapshot.exists) {
        print('FirebaseService: User data found in database');
        return User.fromSnapshot(snapshot);
      } else {
        print('FirebaseService: No user data found in database for UID: ${firebaseUser.uid}');
        return null;
      }
    } catch (e) {
      print('FirebaseService: Error fetching user data: $e');
      return null;
    }
  }

  static Future<User?> signIn(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return await getCurrentUser();
    } catch (e) {
      print('Error signing in: $e');
      return null;
    }
  }

  static Future<User?> signUp(String email, String password, String firstName, String lastName, String companyName) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      final newUser = User(
        uid: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        avatarLink: '',
        companyName: companyName,
      );

      await _database.child('users').child(newUser.uid).set(newUser.toMap());
      return newUser;
    } catch (e) {
      print('Error signing up: $e');
      return null;
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static Future<List<Contact>> getContacts(String userId) async {
    final snapshot = await _database.child('contacts').child(userId).get();
    if (snapshot.exists) {
      final Map<dynamic, dynamic> contactsData = snapshot.value as Map<dynamic, dynamic>;
      return contactsData.entries.map((e) => Contact.fromMap(e.value)).toList();
    }
    return [];
  }

  static Stream<List<Notification>> getNotifications(String userId) {
    return _database.child('notifications').child(userId).onValue.map((event) {
      final Map<dynamic, dynamic>? value = event.snapshot.value as Map?;
      if (value == null) return [];
      return value.entries.map((e) => Notification.fromMap(e.value)).toList()
        ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  static Future<String?> uploadImage(File image) async {
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageRef = FirebaseStorage.instance.ref().child('post_images/$fileName');
      final UploadTask uploadTask = storageRef.putFile(image);
      final TaskSnapshot taskSnapshot = await uploadTask;
      final String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }
}