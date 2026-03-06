import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:naayu_attire1/features/category/data/product_repository.dart';
import 'package:naayu_attire1/features/category/data/models/product_model.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final ImagePicker _picker = ImagePicker();

  final nameController = TextEditingController();
  final priceController = TextEditingController();
  final oldPriceController = TextEditingController();
  final descriptionController = TextEditingController();
  final searchController = TextEditingController();

  String? selectedCategory;
  String selectedColor = "red";
  File? selectedImage;

  late Future<List<ProductModel>> productsFuture;

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  void refreshProducts({String? search}) {
    setState(() {
      productsFuture = ProductRepository.getProducts(
        selectedCategory,
        search: search,
      );
    });
  }

  // ================= ADD PRODUCT =================

  Future<void> addProduct() async {
    if (selectedImage == null ||
        nameController.text.isEmpty ||
        priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fill all required fields")),
      );
      return;
    }

    final product = ProductModel(
      id: "",
      image: "",
      name: nameController.text,
      price: double.parse(priceController.text),
      description: descriptionController.text,
      rating: 4,
      sizes: ["S", "M", "L"],
      color: selectedColor,
      isNew: true,
      oldPrice: oldPriceController.text.isNotEmpty
          ? double.parse(oldPriceController.text)
          : null,
      quantity: 1,
      category: selectedCategory ?? "casual",
    );

    await ProductRepository.createProduct(product, selectedImage);

    Navigator.pop(context);
refreshProducts();

ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("✏️ Product Updated Successfully"),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  ),
);

   ScaffoldMessenger.of(context).showSnackBar(
  const SnackBar(
    content: Text("✅ Product Created Successfully"),
    behavior: SnackBarBehavior.floating,
    duration: Duration(seconds: 2),
  ),
);
  }

  void clearFields() {
    nameController.clear();
    priceController.clear();
    oldPriceController.clear();
    descriptionController.clear();
    selectedImage = null;
  }

  // ================= ADD PRODUCT DIALOG =================

  Future<void> addProductDialog() async {
    clearFields();
    selectedColor = "red";
    selectedCategory = null;

    await showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Add Product"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: "Name"),
                    ),
                    TextField(
                      controller: priceController,
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: oldPriceController,
                      decoration:
                          const InputDecoration(labelText: "Old Price"),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: descriptionController,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 10),

                    // CATEGORY
                    DropdownButton<String?>(
                      value: selectedCategory,
                      isExpanded: true,
                      hint: const Text("Select Category"),
                      items: const [
                        DropdownMenuItem(value: null, child: Text("All")),
                        DropdownMenuItem(
                            value: "casual", child: Text("Casual")),
                        DropdownMenuItem(
                            value: "wedding", child: Text("Wedding")),
                        DropdownMenuItem(
                            value: "party", child: Text("Party")),
                        DropdownMenuItem(
                            value: "winter", child: Text("Winter")),
                        DropdownMenuItem(
                            value: "onepiece", child: Text("One Piece")),
                        DropdownMenuItem(
                            value: "coord", child: Text("Coord")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedCategory = value;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    // COLOR
                    DropdownButton<String>(
                      value: selectedColor,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                            value: "red", child: Text("Red")),
                        DropdownMenuItem(
                            value: "blue", child: Text("Blue")),
                        DropdownMenuItem(
                            value: "black", child: Text("Black")),
                        DropdownMenuItem(
                            value: "white", child: Text("White")),
                        DropdownMenuItem(
                            value: "green", child: Text("Green")),
                        DropdownMenuItem(
                            value: "maroon", child: Text("Maroon")),
                        DropdownMenuItem(
                            value: "yellow", child: Text("Yellow")),
                        DropdownMenuItem(
                            value: "brown", child: Text("Brown")),
                      ],
                      onChanged: (value) {
                        setDialogState(() {
                          selectedColor = value!;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () async {
                        final picked = await _picker.pickImage(
                            source: ImageSource.gallery);
                        if (picked != null) {
                          setDialogState(() {
                            selectedImage = File(picked.path);
                          });
                        }
                      },
                      child: const Text("Pick Image"),
                    ),

                    if (selectedImage != null)
                      Image.file(selectedImage!, height: 80),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: addProduct,
                  child: const Text("Add"),
                )
              ],
            );
          },
        );
      },
    );
  }
  void showEditDialog(ProductModel product) {
  nameController.text = product.name;
  priceController.text = product.price.toString();
  oldPriceController.text = product.oldPrice?.toString() ?? "";
  descriptionController.text = product.description;
  selectedCategory = product.category;
  selectedColor = product.color;

  showDialog(
    context: context,
    builder: (_) {
      return AlertDialog(
        title: const Text("Edit Product"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: oldPriceController,
                decoration: const InputDecoration(labelText: "Old Price"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final updatedProduct = ProductModel(
                id: product.id,
                image: product.image,
                name: nameController.text,
                price: double.parse(priceController.text),
                description: descriptionController.text,
                rating: product.rating,
                sizes: product.sizes,
                color: selectedColor,
                isNew: product.isNew,
                oldPrice: oldPriceController.text.isNotEmpty
                    ? double.parse(oldPriceController.text)
                    : null,
                quantity: 1,
                category: selectedCategory ?? "casual",
              );

              await ProductRepository.updateProduct(
                  product.id, updatedProduct);

              Navigator.pop(context);
              refreshProducts();
            },
            child: const Text("Update"),
          )
        ],
      );
    },
  );
}

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Products")),
      floatingActionButton: FloatingActionButton(
        onPressed: addProductDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: "Search products...",
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => refreshProducts(search: value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: DropdownButton<String?>(
              value: selectedCategory,
              isExpanded: true,
              hint: const Text("Filter by Category"),
              items: const [
                DropdownMenuItem(value: null, child: Text("All")),
                DropdownMenuItem(
                    value: "casual", child: Text("Casual")),
                DropdownMenuItem(
                    value: "wedding", child: Text("Wedding")),
                DropdownMenuItem(
                    value: "party", child: Text("Party")),
                DropdownMenuItem(
                    value: "winter", child: Text("Winter")),
                DropdownMenuItem(
                    value: "onepiece", child: Text("One Piece")),
                DropdownMenuItem(
                    value: "coord", child: Text("Coord")),
              ],
              onChanged: (value) {
                setState(() {
                  selectedCategory = value;
                  refreshProducts();
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<List<ProductModel>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final products = snapshot.data!;

                if (products.isEmpty) {
                  return const Center(
                      child: Text("No products found"));
                }

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
                        errorBuilder: (_, __, ___) =>
                            const Icon(Icons.image),
                      ),
                      title: Text(product.name),
                      subtitle: Text("Rs ${product.price}"),
                     trailing: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    IconButton(
      icon: const Icon(Icons.edit, color: Colors.blue),
      onPressed: () => showEditDialog(product),
    ),
   IconButton(
  icon: const Icon(Icons.delete, color: Colors.red),
  onPressed: () async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text(
            "Are you sure you want to delete this product?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await ProductRepository.deleteProduct(product.id);
      refreshProducts();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("🗑 Product Deleted Successfully"),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  },
),
  ],
),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}