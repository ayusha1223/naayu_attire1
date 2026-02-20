import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() =>
      _AdminProductsPageState();
}

class _AdminProductsPageState
    extends State<AdminProductsPage> {
  final ImagePicker _picker = ImagePicker();

  List<Map<String, dynamic>> products = [
    {
      "name": "Red Kurtha",
      "price": 2500,
      "stock": 10,
      "image": null,
    },
    {
      "name": "Blue Kurtha",
      "price": 1800,
      "stock": 5,
      "image": null,
    },
  ];

  Future<void> addProductDialog() async {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final stockController = TextEditingController();

    File? selectedImage;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Add Product"),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration:
                        const InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: priceController,
                    decoration:
                        const InputDecoration(labelText: "Price"),
                    keyboardType:
                        TextInputType.number,
                  ),
                  TextField(
                    controller: stockController,
                    decoration:
                        const InputDecoration(labelText: "Stock"),
                    keyboardType:
                        TextInputType.number,
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final picked =
                          await _picker.pickImage(
                              source: ImageSource.gallery);

                      if (picked != null) {
                        setStateDialog(() {
                          selectedImage =
                              File(picked.path);
                        });
                      }
                    },
                    child: const Text("Pick Image"),
                  ),
                  if (selectedImage != null)
                    Image.file(
                      selectedImage!,
                      height: 80,
                    )
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    products.add({
                      "name": nameController.text,
                      "price": double.parse(
                          priceController.text),
                      "stock": int.parse(
                          stockController.text),
                      "image": selectedImage,
                    });
                  });

                  Navigator.pop(context);
                },
                child: const Text("Add"),
              )
            ],
          );
        },
      ),
    );
  }

  void deleteProduct(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Products")),
      floatingActionButton:
          FloatingActionButton(
        onPressed: addProductDialog,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];

          return Card(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: product["image"] != null
                  ? Image.file(
                      product["image"],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.shopping_bag),
              title: Text(product["name"]),
              subtitle: Text(
                  "Stock: ${product["stock"]}"),
              trailing: Row(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  Text(
                      "Rs ${product["price"]}"),
                  IconButton(
                    icon: const Icon(
                        Icons.delete,
                        color: Colors.red),
                    onPressed: () =>
                        deleteProduct(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}