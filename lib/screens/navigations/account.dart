import 'package:crohn/utils/firebase_services.dart';
import 'package:crohn/utils/sp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'usermodel.dart';

class AccountScreen extends StatefulWidget {
  final UserModel user;

  const AccountScreen({super.key, required this.user});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>
    with SingleTickerProviderStateMixin {
  File? _profileImage;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _specialityController = TextEditingController();
  final TextEditingController _patentsController = TextEditingController();
  final TextEditingController _experienceController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  late AnimationController _buttonController;
  late Animation<double> _scaleAnimation;

  bool _isAnimated = false;

  final sp = Sp();
  final firebaseservices = FirebaseServices();

  void fillController() {
    _fullNameController.text = widget.user.fullName;
    _bioController.text = widget.user.bio ?? '';
    _specialityController.text = widget.user.isDoctor ? "Doctor" : "Patient";
    _addressController.text = widget.user.address ?? '';
    _experienceController.text = widget.user.proexp ?? '';
  }

  @override
  void initState() {
    super.initState();
    fillController();
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
      lowerBound: 0.0,
      upperBound: 0.1,
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_buttonController);

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _isAnimated = true;
      });
    });
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final fields = [
      _buildAnimatedCard(Icons.person, "Full Name", _fullNameController, 0),
      _buildAnimatedCard(Icons.info, "Bio", _bioController, 1),
      _buildAnimatedCard(
          Icons.medical_services, "Speciality", _specialityController, 2),
      _buildAnimatedCard(
          Icons.lightbulb, "Number of Patents", _patentsController, 3),
      _buildAnimatedCard(
          Icons.work, "Professional Experience", _experienceController, 4),
      _buildAnimatedCard(Icons.location_on, "Address", _addressController, 5),
    ];

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : const Color(0xFFF2F2F7),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                TweenAnimationBuilder(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween<double>(begin: 0, end: _isAnimated ? 1 : 0),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, (1 - value) * 20),
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: _profileImage != null
                              ? FileImage(_profileImage!)
                              : const AssetImage('assets/img/doctor1.webp')
                                  as ImageProvider,
                        ),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.blue[300],
                          child: const Icon(Icons.edit,
                              size: 18, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _fullNameController.text,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[300],
                  ),
                ),
                const SizedBox(height: 24),
                ...fields,
                const SizedBox(height: 20),
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: _isAnimated ? 1 : 0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.scale(
                        scale: value,
                        child: child,
                      ),
                    );
                  },
                  child: GestureDetector(
                    onTapDown: (_) => _buttonController.forward(),
                    onTapUp: (_) {
                      _buttonController.reverse();

                      final updatedModel = UserModel(
                          uid: widget.user.uid,
                          fullName: _fullNameController.text,
                          email: widget.user.email,
                          isDoctor: widget.user.isDoctor,
                          proexp: _experienceController.text,
                          address: _addressController.text);

                      firebaseservices.storeData(updatedModel, widget.user.uid);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Profile information saved.")),
                      );
                    },
                    child: AnimatedBuilder(
                      animation: _buttonController,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _scaleAnimation.value,
                          child: child,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.blue[300],
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 52, 140, 212)
                                  // ignore: deprecated_member_use
                                  .withOpacity(0.4),
                              offset: const Offset(0, 6),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: const Text(
                          "Save Changes",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedCard(IconData icon, String label,
      TextEditingController controller, int index) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: _isAnimated ? 1 : 0),
      duration: Duration(milliseconds: 400 + index * 150),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * 30),
            child: child,
          ),
        );
      },
      child: Card(
        elevation: 6,
        // ignore: deprecated_member_use
        shadowColor: Colors.grey.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue[300]),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  style: const TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    labelText: label,
                    labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
