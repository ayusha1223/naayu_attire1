import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/EditProfile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/services/storage/token_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  String? profileImage;
  String name = "Guest User";

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      profileImage = prefs.getString('profile_image');
      name = prefs.getString('profile_name') ?? "Guest User";
    });
  }

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
      (route) => false,
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          const SizedBox(height: 30),

          // 🔥 PROFILE IMAGE
          CircleAvatar(
            radius: 50,
            backgroundImage:
                profileImage != null ? NetworkImage(profileImage!) : null,
            child: profileImage == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),

          const SizedBox(height: 12),

          // 🔥 NAME
          Text(
            name,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          // 🔥 EDIT PROFILE BUTTON
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
           onPressed: () async {
  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const EditprofileScreen(),
    ),
  );

  // 🔥 Reload profile after returning
  loadProfile();
},

            child: const Text("Edit Profile"),
          ),

          const SizedBox(height: 30),

          const Divider(),

          // 🔥 MENU OPTIONS
          buildMenuItem(
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            onTap: () {},
          ),

          buildMenuItem(
            icon: Icons.support_agent_outlined,
            title: "Contact Us",
            onTap: () {},
          ),

          buildMenuItem(
            icon: Icons.info_outline,
            title: "About Us",
            onTap: () {},
          ),

          buildMenuItem(
            icon: Icons.description_outlined,
            title: "Terms & Conditions",
            onTap: () {},
          ),

          buildMenuItem(
            icon: Icons.logout,
            title: "Logout",
            onTap: logout,
          ),
        ],
      ),
    );
  }
}
