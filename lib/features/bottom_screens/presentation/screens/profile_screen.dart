import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:naayu_attire1/core/services/storage/image_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();

  String? profileImageUrl;
  bool isUploading = false;

  // 👇 Controllers for profile fields
  final TextEditingController nameController =
      TextEditingController(text: "Your Name");
  final TextEditingController emailController =
      TextEditingController(text: "your@email.com");
  final TextEditingController phoneController =
      TextEditingController(text: "");

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

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 30),

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

            // ---------------- PROFILE DETAILS ----------------

            // NAME
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 16),

            // EMAIL (read-only)
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

            // PHONE NUMBER
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone_outlined),
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 24),

            // 🔒 CHANGE PASSWORD
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // later navigate to change password screen
                },
                child: const Text("Change Password"),
              ),
            ),

            const SizedBox(height: 12),

            // 📜 TERMS & CONDITIONS
            TextButton(
              onPressed: () {
                // later open terms page
              },
              child: const Text("Terms & Conditions"),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
