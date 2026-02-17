import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'package:naayu_attire1/core/services/storage/image_service.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class EditprofileScreen extends StatefulWidget {
  const EditprofileScreen({super.key});

  @override
  State<EditprofileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditprofileScreen> {
  final ImagePicker _picker = ImagePicker();

  String? profileImageUrl;
  bool isUploading = false;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // ---------------- INIT ----------------
  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  // ---------------- LOAD SAVED DATA ----------------
  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      profileImageUrl = prefs.getString('profile_image');
      nameController.text = prefs.getString('profile_name') ?? '';
      emailController.text = prefs.getString('profile_email') ?? '';
      phoneController.text = prefs.getString('profile_phone') ?? '';
    });
  }

  // ---------------- SAVE PROFILE DATA ----------------
  Future<void> saveProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('profile_name', nameController.text);
await prefs.setString('profile_phone', phoneController.text);
await prefs.setString('profile_image', profileImageUrl ?? '');

  }

  // ---------------- IMAGE PICK & UPLOAD ----------------
  Future<void> pickAndUploadProfileImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() => isUploading = true);

    final imageFile = File(pickedFile.path);
    final imageService = ImageService(Dio());

    try {
      final imageUrl = await imageService.uploadImage(
        context: context,
        imageFile: imageFile,
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', imageUrl);

      setState(() {
        profileImageUrl = imageUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile image upload failed")),
      );
    } finally {
      setState(() => isUploading = false);
    }
  }

  // ---------------- LOGOUT ----------------
 Future<void> logout() async {
  final tokenService =
      Provider.of<TokenService>(context, listen: false);

  await tokenService.removeToken();

  if (!mounted) return;

  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (_) => const LoginPage(),
    ),
    (route) => false, // 🔥 clears entire stack
  );
}


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 👤 PROFILE IMAGE
            GestureDetector(
              onTap: isUploading ? null : pickAndUploadProfileImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: profileImageUrl != null
                        ? NetworkImage(profileImageUrl!)
                        : null,
                    child: profileImageUrl == null
                        ? const Icon(Icons.person, size: 60)
                        : null,
                  ),
                  const CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.camera_alt, size: 18),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
            if (isUploading) const CircularProgressIndicator(),
            const SizedBox(height: 30),

            // NAME
            TextField(
              controller: nameController,
              onChanged: (_) => saveProfileData(),
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL (READ ONLY)
            TextField(
              controller: emailController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // PHONE
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              onChanged: (_) => saveProfileData(),
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // CHANGE PASSWORD (TEXT FIELD)
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Change Password",
                prefixIcon: Icon(Icons.lock_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // TERMS
            TextButton(
              onPressed: () {},
              child: const Text("Terms & Conditions"),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
