import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naayu_attire1/features/category/data/product_repository.dart';
import 'package:naayu_attire1/features/category/domain/models/product_model.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() =>
      _AdminProductsPageState();
}

class _AdminProductsPageState
    extends State<AdminProductsPage> {

  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final priceController = TextEditingController();

  String selectedCategory = "casual";
  String selectedColor = "red";
  File? selectedImage;

  late Future<List<ProductModel>> productsFuture;

  @override
  void initState() {
    super.initState();
    productsFuture =
        ProductRepository.getProducts(selectedCategory);
  }

  void refreshProducts() {
    setState(() {
      productsFuture =
          ProductRepository.getProducts(selectedCategory);
    });
  }

  // ================= ADD PRODUCT =================
  Future<void> addProduct() async {
    if (selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please select image")),
      );
      return;
    }

    final product = ProductModel(
      id: "",
      image: "",
      name: nameController.text,
      price: double.parse(priceController.text),
      description: "Admin added product",
      rating: 4,
      sizes: ["S", "M", "L"],
      color: selectedColor,
      isNew: true,
      oldPrice: null,
      quantity: 1,
      category: selectedCategory,
    );

    await ProductRepository.createProduct(
      product,
      selectedImage,
    );

    Navigator.pop(context);

    nameController.clear();
    priceController.clear();
    selectedImage = null;

    refreshProducts();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text("Product Added Successfully")),
    );
  }

  // ================= EDIT PRODUCT =================
  void showEditDialog(ProductModel product) {
    nameController.text = product.name;
    priceController.text = product.price.toString();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Product"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedProduct = ProductModel(
                id: product.id,
                image: product.image,
                name: nameController.text,
                price: double.parse(priceController.text),
                description: product.description,
                rating: product.rating,
                sizes: product.sizes,
                color: product.color,
                isNew: product.isNew,
                oldPrice: product.oldPrice,
                quantity: 1,
                category: product.category,
              );

              await ProductRepository.updateProduct(
                  product.id, updatedProduct);

              Navigator.pop(context);
              refreshProducts();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // ================= ADD PRODUCT DIALOG =================
  Future<void> addProductDialog() async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
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
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedCategory,
                isExpanded: true,
                items: const [
                  DropdownMenuItem(
                      value: "casual",
                      child: Text("Casual")),
                  DropdownMenuItem(
                      value: "wedding",
                      child: Text("Wedding")),
                  DropdownMenuItem(
                      value: "party",
                      child: Text("Party")),
                  DropdownMenuItem(
                      value: "winter",
                      child: Text("Winter")),
                  DropdownMenuItem(
                      value: "onepiece",
                      child: Text("One Piece")),
                  DropdownMenuItem(
                      value: "coord",
                      child: Text("Coord")),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final picked =
                      await _picker.pickImage(
                          source:
                              ImageSource.gallery);

                  if (picked != null) {
                    setState(() {
                      selectedImage =
                          File(picked.path);
                    });
                  }
                },
                child:
                    const Text("Pick Image"),
              ),
              if (selectedImage != null)
                Image.file(
                  selectedImage!,
                  height: 80,
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: addProduct,
            child: const Text("Add"),
          )
        ],
      ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text("Admin Products")),
      floatingActionButton:
          FloatingActionButton(
        onPressed: addProductDialog,
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: productsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              return ListTile(
                leading: Image.network(
                  product.image,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) =>
                          const Icon(Icons.image),
                ),
                title: Text(product.name),
                subtitle:
                    Text("Rs ${product.price}"),
                trailing: Row(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                          Icons.edit,
                          color: Colors.blue),
                      onPressed: () =>
                          showEditDialog(product),
                    ),
                    IconButton(
                      icon: const Icon(
                          Icons.delete,
                          color: Colors.red),
                      onPressed: () async {
                        await ProductRepository
                            .deleteProduct(
                                product.id);
                        refreshProducts();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}