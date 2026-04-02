import 'package:finova_ai/widgets/elevated_button.dart';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:crop/crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserProfile extends ConsumerStatefulWidget {
  const UserProfile({super.key});

  @override
  ConsumerState<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends ConsumerState<UserProfile> {
  Future<void> loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final doc =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    final data = doc.data();

    if (data != null) {
      nameController.text = data['name'] ?? '';
      emailController.text = data['email'] ?? '';
      phoneController.text = data['phone'] ?? '';
      imageUrl = data['profileImage'];
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (picked != null) {
      if (!mounted) return;
      
      final croppedImage = await Navigator.push<ui.Image>(
        context,
        MaterialPageRoute(
          builder: (context) => _CropImageScreen(
            imageFile: File(picked.path),
          ),
        ),
      );

      if (croppedImage != null) {
        // Convert ui.Image to File
        final bytes = await croppedImage.toByteData(format: ui.ImageByteFormat.png);
        if (bytes != null) {
          final tempDir = Directory.systemTemp;
          final file = File(
            '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.png',
          );
          await file.writeAsBytes(bytes.buffer.asUint8List());
          setState(() {
            imageFile = file;
          });
        }
      }
    }
  }

  bool isSaving = false;

  Future<void> updateProfile() async {
    if (nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Name cannot be empty")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      String? uploadedImage = await uploadImage();

      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "profileImage": uploadedImage ?? imageUrl,
      });

      if (!mounted) return;

      setState(() {
        imageUrl = uploadedImage ?? imageUrl;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not update profile")),
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  Future<String?> uploadImage() async {
    if (imageFile == null) return null;

    final supabase = Supabase.instance.client;

    final user = FirebaseAuth.instance.currentUser;

    final fileName =
        '${user!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';

    await supabase.storage.from('profile-images').upload(fileName, imageFile!);

    final imageUrl = supabase.storage
        .from('profile-images')
        .getPublicUrl(fileName);

    return imageUrl;
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  File? imageFile;
  String? imageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.blue)),
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: Colors.black,
        ),
        elevation: 2,
        shadowColor: Colors.black12,
        surfaceTintColor: Colors.white,
        toolbarHeight: 58,
        title: const Text(
          "User Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w500,
            fontFamily: 'SFProText',
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          /// SCROLLABLE AREA
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 30),

                  /// PROFILE IMAGE
                  GestureDetector(
                    onTap: pickImage,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey.shade200,
                        ),

                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey.shade300,
                          backgroundImage:
                              imageFile != null
                                  ? FileImage(imageFile!)
                                  : (imageUrl != null && imageUrl!.isNotEmpty
                                      ? NetworkImage(imageUrl!)
                                      : null),
                          child:
                              imageFile == null &&
                                      (imageUrl == null || imageUrl!.isEmpty)
                                  ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xFF3B82F6),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  /// FIRST NAME
                  _label("First Name"),
                  const SizedBox(height: 8),
                  _inputField(nameController, 'Enter your First Name'),

                  const SizedBox(height: 20),

                  /// EMAIL
                  _label("Email Address"),
                  const SizedBox(height: 8),
                  _inputField(
                    emailController,
                    'Enter your Email Address',
                    readOnly: true,
                  ),

                  const SizedBox(height: 20),

                  /// PHONE
                  _label("Phone Number"),
                  const SizedBox(height: 8),
                  _inputField(phoneController, 'Enter your Phone No'),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          /// FIXED SUBMIT BUTTON
          Container(
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 30),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.05), blurRadius: 10),
              ],
            ),
            child:
                isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButtonCust('Submit', updateProfile),
          ),
        ],
      ),
    );
  }
}

Widget _label(String text) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFProText',
        color: Colors.black,
      ),
    ),
  );
}

Widget _inputField(
  TextEditingController controller,
  String hintText, {
  bool readOnly = false,
}) {
  return SizedBox(
    width: double.infinity,
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    ),
  );
}

class _CropImageScreen extends StatefulWidget {
  final File imageFile;

  const _CropImageScreen({required this.imageFile});

  @override
  State<_CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<_CropImageScreen> {
  late final controller = CropController(
    aspectRatio: 1,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close),
        ),
        title: const Text(
          'Crop Image',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Crop(
              controller: controller,
              child: Image.file(widget.imageFile),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () async {
                      final croppedImage = await controller.crop();
                      if (croppedImage != null) {
                        if (mounted) {
                          Navigator.pop(context, croppedImage);
                        }
                      }
                    },
                    child: const Text(
                      'Done',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
