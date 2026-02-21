import 'package:flutter/material.dart';
import 'package:naayu_attire1/core/providers/theme_provider.dart';
import 'package:naayu_attire1/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
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
  String name = "Naayu User";
  String? email;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  /// ================================
  /// LOAD USER PROFILE
  /// ================================
Future<void> loadProfile() async {
  final prefs = await SharedPreferences.getInstance();

  final savedEmail = prefs.getString('user_email');

  if (savedEmail == null) return;

  setState(() {
    email = savedEmail;
    name = prefs.getString('user_name') ?? "Naayu User";
    profileImage =
        prefs.getString('profile_image_$savedEmail');
  });
}

  /// ================================
  /// LOGOUT
  /// ================================
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My Profile",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 20),

            /// ===============================
            /// MAIN CARD
            /// ===============================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: Column(
                children: [

                  /// ===============================
                  /// PROFILE HEADER (NEW UI)
                  /// ===============================
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.center,
                      children: [

                        /// PROFILE IMAGE
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: profileImage != null
                              ? NetworkImage(profileImage!)
                              : const AssetImage(
                                      "assets/images/profile.png")
                                  as ImageProvider,
                        ),

                        const SizedBox(width: 20),

                        /// NAME + EDIT
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const EditprofileScreen(),
                                    ),
                                  );
                                  loadProfile();
                                },
                                child: const Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight:
                                        FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),
                  const Divider(),

                  /// ===============================
                  /// MENU ITEMS
                  /// ===============================
                 buildMenuItem(
  icon: Icons.favorite_border,
  title: "Favorites",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const FavoritesScreen(),
      ),
    );
  },
),

                  buildMenuItem(
                    icon: Icons.shopping_bag_outlined,
                    title: "My Orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const MyOrdersScreen(),
                        ),
                      );
                    },
                  ),

                  buildMenuItem(
                    icon: Icons.support_agent_outlined,
                    title: "Contact Us",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ContactScreen(),
                        ),
                      );
                    },
                  ),

                  buildMenuItem(
                    icon: Icons.info_outline,
                    title: "About Us",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const AboutScreen(),
                        ),
                      );
                    },
                  ),

                  buildMenuItem(
                    icon: Icons.description_outlined,
                    title: "Terms & Conditions",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const TermsScreen(),
                        ),
                      );
                    },
                  ),

                  /// ===============================
                  /// DARK MODE
                  /// ===============================
                  Consumer<ThemeProvider>(
                    builder: (context, themeProvider, _) {
                      return SwitchListTile(
                        secondary:
                            const Icon(Icons.dark_mode),
                        title:
                            const Text("Dark Mode"),
                        value: themeProvider.isDark,
                        onChanged: (value) {
                          themeProvider
                              .toggleTheme(value);
                        },
                      );
                    },
                  ),

                  /// ===============================
                  /// LOGOUT
                  /// ===============================
                  buildMenuItem(
                    icon: Icons.logout,
                    title: "Logout",
                    isLogout: true,
                    onTap: logout,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color:
            isLogout ? Colors.red : Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          color: isLogout
              ? Colors.red
              : Colors.black87,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}