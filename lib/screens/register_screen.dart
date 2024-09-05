import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:a_business_app/widgets/utility.dart';
import '../widgets/round_button.dart';
import '../widgets/app_color.dart';
import '../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  String _errorMessage = '';

  void _showErrorMessage(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  Future<UserCredential?> signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Save additional user info to the database
      final String userID = userCredential.user!.uid;
      final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      final userRef = databaseReference.child('users').child(userID);
      await userRef.set({
        'firstName': googleUser.displayName?.split(' ').first ?? '',
        'lastName': googleUser.displayName?.split(' ').last ?? '',
        'email': googleUser.email,
        'avatarLink': googleUser.photoUrl ?? '',
        'companyName': '',
      });

      return userCredential;
    } catch (e) {
      _showErrorMessage('Failed to sign up with Google. Please try again.');
      return null;
    }
  }

  Future<void> _register() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String company = _companyController.text.trim();

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty || 
        firstName.isEmpty || lastName.isEmpty) {
      _showErrorMessage('Please fill in all required fields.');
      return;
    }

    if (password != confirmPassword) {
      _showErrorMessage('Passwords do not match. Please try again.');
      return;
    }

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save additional user info to the database
      final String userID = userCredential.user!.uid;
      final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      final userRef = databaseReference.child('users').child(userID);
      await userRef.set({
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'companyName': company,
        'avatarLink': '', // Add a default empty string for avatarLink
      });

      print('User registered successfully with UID: $userID');

      // Navigate to the main screen after successful registration
      Navigator.pushReplacementNamed(context, '/main');
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'Please enter a valid email address.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Registration is currently disabled. Please try again later.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak. Please use a stronger password.';
          break;
        default:
          errorMessage = 'An error occurred during registration. Please try again later.';
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      _showErrorMessage('An unexpected error occurred. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/logo.jpeg'),
                const SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _firstNameController,
                        hintText: 'First Name',
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: CustomTextField(
                        controller: _lastNameController,
                        hintText: 'Last Name',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 8.0),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Password',
                  isPassword: true,
                ),
                const SizedBox(height: 8.0),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirm Password',
                  isPassword: true,
                ),
                const SizedBox(height: 8.0),
                CustomTextField(
                  controller: _companyController,
                  hintText: 'Company Name',
                ),
                const SizedBox(height: 24.0),
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red, fontSize: 16.0),
                ),
                const SizedBox(height: 24.0),
                RoundButton(
                  label: 'Register',
                  onPressed: _register,
                ),
                const SizedBox(height: 16.0),
                RoundButton(
                  label: 'Sign up with Google',
                  onPressed: () async {
                    UserCredential? result = await signUpWithGoogle();
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
                    Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                      child: Text(
                        'Login',
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
