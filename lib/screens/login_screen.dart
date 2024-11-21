import 'package:a_business_app/widgets/utility.dart';
import 'package:flutter/material.dart';
import '../widgets/round_button.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/app_color.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'user_profile.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String _errorMessage = '';

  void _showErrorMessage(String message) {
    if (mounted) {
      setState(() {
        _errorMessage = message;
      });
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      if (mounted) {
        _showErrorMessage('Failed to sign in with Google. Please try again.');
      }
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: 400, // Set a maximum width for the container
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min, // Set the column to take up minimum space
              children: [
                Image.asset('assets/images/logo.jpeg'),
                const SizedBox(height: 50),
                CustomTextField(
                  controller: _usernameController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 16.0),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 24.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                RoundButton(
                  label: 'Login',
                  onPressed: () async {
                    final String email = _usernameController.text.trim();
                    final String password = _passwordController.text.trim();
                    if (email.isEmpty || password.isEmpty) {
                      _showErrorMessage('Please enter both an email and a password.');
                      return;
                    }
                    try {
                      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      Navigator.pushReplacementNamed(context, '/main');
                    } on FirebaseAuthException catch (e) {
                      switch (e.code) {
                        case 'user-not-found':
                          _showErrorMessage('No user found with this email. Please check your email or register.');
                          break;
                        case 'wrong-password':
                          _showErrorMessage('Incorrect password. Please try again.');
                          break;
                        case 'invalid-email':
                          _showErrorMessage('Invalid email format. Please enter a valid email address.');
                          break;
                        case 'user-disabled':
                          _showErrorMessage('This account has been disabled. Please contact support.');
                          break;
                        default:
                          _showErrorMessage('An error occurred. Please try again later.');
                      }
                    } catch (e) {
                      _showErrorMessage('An unexpected error occurred. Please try again later.');
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                RoundButton(
                  label: 'Sign in with Google',
                  onPressed: () async {
                    UserCredential? result = await signInWithGoogle();
                    if (result != null) {
                      Navigator.pushReplacementNamed(context, '/main');
                    }
                  },
                  color: AppColors.whiteColor,
                  icon: Image.asset('assets/images/google_logo.png', height: 24.0),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('New here? '),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the registration screen
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: AppColors.blueColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Future<UserCredential> signInWithEmailAndPassword(String email, String password) async {
//   return await auth.signInWithEmailAndPassword(email: email, password: password);
// }

// void signOut() async {
//   await auth.signOut();
// }
