import 'package:flutter/material.dart';

class ProfileHeaderWidget extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final VoidCallback onEdit;

  const ProfileHeaderWidget({
    super.key,
    required this.name,
    required this.onEdit,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        // Profile Image
        CircleAvatar(
          radius: 50,
          backgroundImage:
              imageUrl != null ? NetworkImage(imageUrl!) : null,
          child: imageUrl == null
              ? const Icon(Icons.person, size: 50)
              : null,
        ),

        const SizedBox(height: 12),

        // Name
        Text(
          name.isEmpty ? "Your Name" : name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 12),

        // Edit Button
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: onEdit,
          child: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
