import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/admin_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/services/storage/token_service.dart';
import '../../../auth/presentation/pages/login_page.dart';

class AdminProfilePage extends StatefulWidget {
  const AdminProfilePage({super.key});

  @override
  State<AdminProfilePage> createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final AdminProfileService _service = AdminProfileService();

  bool isLoading = true;
  bool notificationsEnabled = true;

  String adminName = "";
  String adminEmail = "";
  String role = "";
  String? profileImagePath;

  int totalOrders = 0;
  int totalProducts = 0;
  double totalRevenue = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ✅ Load saved image
      final savedImage =
          prefs.getString("admin_profile_image");

      // ✅ Load saved notification setting
      final savedNotification =
          prefs.getBool("admin_notifications");

      final profileResponse = await _service.getProfile();
      final dashboardResponse =
          await _service.getDashboardStats();

      final user =
          profileResponse["data"] ?? profileResponse;
      final dashboard =
          dashboardResponse["data"] ??
              dashboardResponse;

      setState(() {
        adminName = user["name"] ?? "";
        adminEmail = user["email"] ?? "";
        role = user["role"] ?? "";

        totalOrders =
            dashboard["totalOrders"] ?? 0;
        totalProducts =
            dashboard["totalProducts"] ?? 0;
        totalRevenue =
            (dashboard["totalRevenue"] ?? 0)
                .toDouble();

        profileImagePath = savedImage;
        notificationsEnabled =
            savedNotification ?? true;

        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// =============================
  /// IMAGE PICKER + SAVE
  /// =============================
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked =
        await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
          "admin_profile_image", picked.path);

      setState(() {
        profileImagePath = picked.path;
      });
    }
  }

  /// =============================
  /// EDIT PROFILE
  /// =============================
  void showEditProfileDialog() {
    final nameController =
        TextEditingController(text: adminName);
    final emailController =
        TextEditingController(text: adminEmail);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration:
                  const InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: emailController,
              decoration:
                  const InputDecoration(labelText: "Email"),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () =>
                Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Save"),
            onPressed: () {
              setState(() {
                adminName =
                    nameController.text;
                adminEmail =
                    emailController.text;
              });
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// =============================
  /// CHANGE PASSWORD
  /// =============================
  void showChangePasswordDialog() {
    final passwordController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text("Change Password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration:
              const InputDecoration(
                  labelText: "New Password"),
        ),
        actions: [
          TextButton(
            child: const Text("Cancel"),
            onPressed: () =>
                Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text("Update"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  /// =============================
  /// SAVE NOTIFICATION SETTING
  /// =============================
  Future<void> toggleNotification(bool value) async {
    final prefs =
        await SharedPreferences.getInstance();

    await prefs.setBool(
        "admin_notifications", value);

    setState(() {
      notificationsEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body:
            Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("Admin Profile"),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            /// PROFILE CARD
            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage:
                            profileImagePath != null
                                ? FileImage(
                                    File(profileImagePath!))
                                : null,
                        child: profileImagePath ==
                                null
                            ? const Icon(
                                Icons.camera_alt,
                                size: 30,
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            adminName,
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                          Text(adminEmail),
                          const SizedBox(
                              height: 5),
                          Chip(
                            label:
                                Text(role),
                            backgroundColor:
                                Colors.black,
                            labelStyle:
                                const TextStyle(
                                    color: Colors
                                        .white),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.edit),
                      onPressed:
                          showEditProfileDialog,
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// STATS
            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(
                        Icons.shopping_cart),
                    title: const Text(
                        "Total Orders"),
                    trailing:
                        Text("$totalOrders"),
                  ),
                  ListTile(
                    leading:
                        const Icon(
                            Icons.inventory),
                    title: const Text(
                        "Products Added"),
                    trailing:
                        Text(
                            "$totalProducts"),
                  ),
                  ListTile(
                    leading: const Icon(
                        Icons.attach_money),
                    title: const Text(
                        "Total Revenue"),
                    trailing: Text(
                        "₹ $totalRevenue"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SETTINGS
            Card(
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading:
                        const Icon(Icons.lock),
                    title: const Text(
                        "Change Password"),
                    trailing:
                        const Icon(Icons
                            .arrow_forward_ios,
                            size: 16),
                    onTap:
                        showChangePasswordDialog,
                  ),
                  SwitchListTile(
                    secondary:
                        const Icon(Icons.notifications),
                    title:
                        const Text("Notifications"),
                    value:
                        notificationsEnabled,
                    onChanged:
                        toggleNotification,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// LOGOUT
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style:
                    ElevatedButton
                        .styleFrom(
                  backgroundColor:
                      const Color
                          .fromARGB(
                          255,
                          182,
                          197,
                          237),
                ),
                icon: const Icon(
                    Icons.logout),
                label:
                    const Text("Logout"),
                onPressed: logout,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    final prefs =
        await SharedPreferences
            .getInstance();
    final tokenService =
        TokenService(prefs);
    await tokenService.removeToken();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (_) =>
              const LoginPage()),
      (route) => false,
    );
  }
}