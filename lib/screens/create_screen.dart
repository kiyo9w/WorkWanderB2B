import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';
import '../models/post.dart';
import '../widgets/app_color.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import '../widgets/loading_overlay.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CreateScreen extends StatefulWidget {
  const CreateScreen({super.key});

  @override
  _CreateScreenState createState() => _CreateScreenState();
}

class _CreateScreenState extends State<CreateScreen> {
  final TextEditingController _postController = TextEditingController();
  List<String> _photoUrls = [];
  String? _salaryRange;
  String? _expertise;
  DateTime? _deadline;
  String? _location;
  bool _isLoading = false;
  String _loadingStatus = '';

  void _updateLoadingStatus(String status) {
    setState(() {
      _loadingStatus = status;
    });
  }

  void _cancelPost() {
    setState(() {
      _isLoading = false;
      _loadingStatus = '';
    });
    // Add any additional cleanup or cancellation logic here
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text('Create Recruitment Post'),
            actions: [
              TextButton(
                onPressed: _createPost,
                child: Text(
                  'Post',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 2.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    elevation: 0, // Reduced elevation for a flatter look // Very light gray color
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(12), // Slightly rounded corners
                    //   side: BorderSide(color: Colors.grey[200]!, width: 1), // Subtle border
                    // ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage('https://i.pinimg.com/736x/2c/9b/d4/2c9bd4b21fb4d0e3dfda41946e7ce3b1.jpg'),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Ngo Trung',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: _postController,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'What\'s on your mind?',
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.grey[550]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),  // Increased space
                  Text(
                    'Add to Your Post',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 16),  // Increased space
                  if (_photoUrls.isEmpty)
                    _buildOptionButton(
                      icon: Icons.photo,
                      label: 'Add Photos',
                      color: Colors.green,
                      onPressed: _addPhotos,
                    ),
                  if (_photoUrls.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Column(
                        children: [
                          _buildPhotoGrid(),
                          SizedBox(height: 16),
                          _buildAddMoreImagesButton(),
                        ],
                      ),
                    ),
                  _buildOptionButton(
                    icon: Icons.attach_money,
                    label: 'Set salary range',
                    color: Colors.orange,
                    onPressed: _setSalaryRange,
                    value: _salaryRange,
                  ),
                  _buildOptionButton(
                    icon: Icons.people_alt_outlined,
                    label: 'Details on expertise',
                    color: Colors.blue,
                    onPressed: _setExpertise,
                    value: _expertise,
                  ),
                  _buildOptionButton(
                    icon: Icons.calendar_today,
                    label: 'Set deadline',
                    color: Colors.purple,
                    onPressed: _setDeadline,
                    value: _deadline != null
                        ? DateFormat('E, MMM d yyyy').format(_deadline!)
                        : null,
                  ),
                  _buildOptionButton(
                    icon: Icons.location_on,
                    label: 'Add Location',
                    color: Colors.red,
                    onPressed: _setLocation,
                    value: _location,
                  ),
                ],
              ),
            ),
          ),
        ),
        LoadingOverlay(
          status: _loadingStatus,
          isLoading: _isLoading,
          onCancel: _cancelPost,
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
    String? value,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),  // Increased vertical padding
            child: Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    value ?? label,
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
              ],
            ),
          ),
        ),
        Divider(height: 1, color: Colors.grey[300]),
      ],
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _photoUrls.length == 1 ? 1 : 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: _photoUrls.length == 1 ? 16 / 9 : 1,
      ),
      itemCount: _photoUrls.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(_photoUrls[index]),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _photoUrls.removeAt(index);
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAddMoreImagesButton() {
    return ElevatedButton.icon(
      onPressed: _addPhotos,
      icon: Icon(Icons.add, size: 24),
      label: Text('Add more images'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Future<void> _addPhotos() async {
    final ImagePicker _picker = ImagePicker();
    final List<XFile>? images = await _picker.pickMultiImage();

    setState(() {
      if (images != null && images.isNotEmpty) {
        _photoUrls.addAll(images.map((image) => image.path));
      }
    });
  }

  void _setSalaryRange() {
    final TextEditingController minController = TextEditingController();
    final TextEditingController maxController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set Salary Range'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: minController,
                      decoration: InputDecoration(labelText: 'Min'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                  SizedBox(width: 16),
                  Text('-'),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: maxController,
                      decoration: InputDecoration(labelText: 'Max'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Set'),
              onPressed: () {
                int? min = int.tryParse(minController.text);
                int? max = int.tryParse(maxController.text);
                if (min != null && max != null && min < max) {
                  setState(() {
                    _salaryRange = '\$${min.toStringAsFixed(0)} - \$${max.toStringAsFixed(0)}';
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Invalid range. Max should be greater than Min.')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _setExpertise() {
    // Implement expertise selection logic
    setState(() {
      _expertise = 'Software Development, Flutter';
    });
  }

  void _setDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _deadline = picked;
      });
    }
  }

  void _setLocation() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PlacePicker(
          apiKey: dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '',
          onPlacePicked: (result) {
            setState(() {
              _location = result.formattedAddress;
            });
            Navigator.of(context).pop();
          },
          initialPosition: LatLng(37.7749, -122.4194), // Default to San Francisco
          useCurrentLocation: true,
        ),
      ),
    );
  }

  void _createPost() async {
    if (_postController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter some text for your post.')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _loadingStatus = 'Initializing...';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to create a post.');
      }

      _updateLoadingStatus('Uploading images...');
      List<String> uploadedPhotoUrls = [];
      for (String photoUrl in _photoUrls) {
        if (!_isLoading) return; // Check if cancelled
        String? uploadedUrl = await FirebaseService.uploadImage(File(photoUrl));
        if (uploadedUrl != null) {
          uploadedPhotoUrls.add(uploadedUrl);
        } else {
          throw Exception('Failed to upload one or more images.');
        }
      }

      if (!_isLoading) return; // Check if cancelled
      _updateLoadingStatus('Creating post...');
      final post = Post(
        id: '', // This will be set by Firebase
        userId: user.uid,
        content: _postController.text,
        photoUrls: uploadedPhotoUrls,
        salaryRange: _salaryRange,
        expertise: _expertise,
        deadline: _deadline,
        location: _location,
        timestamp: DateTime.now(),
      );

      if (!_isLoading) return; // Check if cancelled
      _updateLoadingStatus('Saving post to database...');
      await FirebaseService.createPost(post);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear the form
      _postController.clear();
      setState(() {
        _photoUrls = [];
        _salaryRange = null;
        _expertise = null;
        _deadline = null;
        _location = null;
      });

      // Navigate back to the home screen
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      if (_isLoading) { // Only show error if not cancelled
        setState(() {
          _isLoading = false;
        });

        print('Error creating post: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create post. Please try again. Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
