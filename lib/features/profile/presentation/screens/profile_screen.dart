import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/profile/presentation/widgets/profile_menu_title.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/editprofile_screen.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/about_screen.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/contact_screen.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/terms_screen.dart';
import 'package:naayu_attire1/features/profile/presentation/screens/my_orders_screen.dart';
import 'package:naayu_attire1/features/auth/presentation/pages/login_page.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile"),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // 🔥 HEADER WIDGET
            ProfileHeaderWidget(
              name: name,
              imageUrl: profileImage,
              onEdit: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditprofileScreen(),
                  ),
                );
                loadProfile(); // refresh after edit
              },
            ),

            const Divider(),

            // 🔥 MENU OPTIONS

            ProfileMenuTile(
              icon: Icons.shopping_bag_outlined,
              title: "My Orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const MyOrdersScreen(),
                  ),
                );
              },
            ),

            ProfileMenuTile(
              icon: Icons.support_agent_outlined,
              title: "Contact Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ContactScreen(),
                  ),
                );
              },
            ),

            ProfileMenuTile(
              icon: Icons.info_outline,
              title: "About Us",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutScreen(),
                  ),
                );
              },
            ),

            ProfileMenuTile(
              icon: Icons.description_outlined,
              title: "Terms & Conditions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TermsScreen(),
                  ),
                );
              },
            ),

            ProfileMenuTile(
              icon: Icons.logout,
              title: "Logout",
              onTap: logout,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
