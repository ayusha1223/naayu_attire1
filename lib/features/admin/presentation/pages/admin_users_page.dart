import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/admin/data/services/admin_service.dart';


class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  final AdminService _adminService = AdminService();

  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    try {
      final data = await _adminService.getUsers();

      setState(() {
        users = data;
        isLoading = false;
      });
    } catch (e) {
      print("User Load Error: $e");
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load users")),
      );
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _adminService.deleteUser(userId);
      loadUsers();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to delete user")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateUserDialog,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("No users found"))
              : RefreshIndicator(
                  onRefresh: loadUsers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// NAME
                              Text(
                                user["name"] ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 6),

                              /// EMAIL
                              Text("Email: ${user["email"] ?? ""}"),

                              const SizedBox(height: 4),

                              /// ROLE
                              Text("Role: ${user["role"] ?? ""}"),

                              const SizedBox(height: 4),

                              /// ORDER COUNT
                              Text(
                                  "Orders: ${user["orderCount"] ?? 0}"),

                              const SizedBox(height: 4),

                              /// TOTAL SPENT
                              Text(
                                  "Total Spent: Rs ${user["totalSpent"] ?? 0}"),

                              const SizedBox(height: 10),

                              /// ACTION BUTTONS
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () =>
                                        showEditUserDialog(
                                            user["_id"], user),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                    onPressed: () =>
                                        deleteUser(user["_id"]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  /// CREATE USER
  void showCreateUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Create User"),
        content: SingleChildScrollView(
          child: Column(
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
              TextField(
                controller: passwordController,
                decoration:
                    const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _adminService.createUser(
                nameController.text,
                emailController.text,
                passwordController.text,
              );
              Navigator.pop(context);
              loadUsers();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  /// EDIT USER
  void showEditUserDialog(String userId, dynamic user) {
    final nameController =
        TextEditingController(text: user["name"]);
    final emailController =
        TextEditingController(text: user["email"]);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit User"),
        content: SingleChildScrollView(
          child: Column(
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
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await _adminService.updateUser(
                userId,
                nameController.text,
                emailController.text,
              );
              Navigator.pop(context);
              loadUsers();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }
}