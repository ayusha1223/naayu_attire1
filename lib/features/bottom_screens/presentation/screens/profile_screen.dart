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

  Future<void> pickAndUploadProfileImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    setState(() {
      isUploading = true;
    });

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
      setState(() {
        isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
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
                      : const AssetImage(
                          "assets/images/default_avatar.png",
                        ) as ImageProvider,
                ),
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.camera_alt, size: 18),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          if (isUploading)
            const CircularProgressIndicator(),

          const SizedBox(height: 30),

          const Text(
            "Tap image to update profile picture",
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
