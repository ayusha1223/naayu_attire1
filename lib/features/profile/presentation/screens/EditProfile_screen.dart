import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
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
  bool isSaving = false;
  String? savedEmail;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    savedEmail = prefs.getString('user_email');

    if (savedEmail == null) return;

    setState(() {
      profileImageUrl =
          prefs.getString('profile_image_$savedEmail');
      nameController.text =
          prefs.getString('user_name') ?? '';
      emailController.text = savedEmail!;
      phoneController.text =
          prefs.getString('user_phone_$savedEmail') ?? '';
    });
  }

  Future<void> saveProfileData() async {
    FocusScope.of(context).unfocus();

    if (savedEmail == null) return;

    setState(() => isSaving = true);

    try {
      final tokenService =
          Provider.of<TokenService>(context, listen: false);

      final token = await tokenService.getToken();

      final dio = Dio();

      await dio.put(
        "http://192.168.1.74:3000/api/v1/students/update-profile",
        data: {
          "name": nameController.text,
          if (passwordController.text.isNotEmpty)
            "password": passwordController.text,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("user_name", nameController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile Updated Successfully"),
        ),
      );

      passwordController.clear();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Update Failed")),
      );
    }

    if (mounted) {
      setState(() => isSaving = false);
    }
  }

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
      await prefs.setString(
          'profile_image_$savedEmail', imageUrl);

      setState(() {
        profileImageUrl = imageUrl;
      });

    } catch (e) {}

    if (mounted) {
      setState(() => isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              const SizedBox(height: 20),

              /// PROFILE IMAGE SECTION
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : null,
                      child: profileImageUrl == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed:
                          isUploading ? null : pickAndUploadProfileImage,
                      child: const Text(
                        "Change Picture",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              /// NAME
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// EMAIL
              TextField(
                controller: emailController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// PHONE
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),

              /// PASSWORD
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Change Password ",
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 30),

              /// UPDATE BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff7c5cff),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed:
                      isSaving ? null : saveProfileData,
                  child: isSaving
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          "Update Profile",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
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