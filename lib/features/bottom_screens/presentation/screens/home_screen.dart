import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';

import 'package:naayu_attire1/widgets/category_item.dart';
import 'package:naayu_attire1/widgets/product_card.dart';
import 'package:naayu_attire1/widgets/section_title.dart';
import 'package:naayu_attire1/core/services/storage/image_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ---------------- IMAGE UPLOAD STATE ----------------
  final ImagePicker _picker = ImagePicker();
  String? uploadedImageUrl;
  bool isUploading = false;

  // ---------------- IMAGE PICK & UPLOAD ----------------
  Future<void> pickAndUploadImage(BuildContext context) async {
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
        uploadedImageUrl = imageUrl;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image upload failed")),
      );
    } finally {
      setState(() {
        isUploading = false;
      });
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // 🔍 Search bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xffD9D9D9),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, size: 18),
                            SizedBox(width: 8),
                            Text(
                              "Search",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xffA19C9C),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.notifications_none),
                    const SizedBox(width: 12),
                    const Icon(Icons.favorite_border),
                  ],
                ),
              ),

              // 🎉 Top banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image1.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.black.withOpacity(0.35),
                    ),
                    child: const Center(
                      child: Text(
                        "Get 50% off\non your first order",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 📤 UPLOAD IMAGE BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: isUploading
                        ? null
                        : () => pickAndUploadImage(context),
                    child: isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Upload Image"),
                  ),
                ),
              ),

              // 🖼️ DISPLAY IMAGE FROM SERVER
              if (uploadedImageUrl != null)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      uploadedImageUrl!,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

              const SizedBox(height: 30),

              // 🧥 Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    CategoryItem(
                      title: "Best Selling",
                      image: "assets/images/image2.jpeg",
                    ),
                    CategoryItem(
                      title: "Party Wear",
                      image: "assets/images/image3.jpeg",
                    ),
                    CategoryItem(
                      title: "Casual Wear",
                      image: "assets/images/image4.jpeg",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🆕 New collection banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 190,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image5.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              sectionTitle("New Collection"),
              productList(),

              sectionTitle("Best Red Selling"),
              productList(),

              sectionTitle("Winter Collection"),
              productList(),

              const SizedBox(height: 20),

              // 🔻 Final banner
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/image12.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
