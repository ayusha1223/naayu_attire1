import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/payment/presentation/payment_method_screen.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:naayu_attire1/features/address/domain/models/address_model.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  // ===== ONLY BUTTONS/HIGHLIGHTS PINK =====
  static const Color kPrimaryPink = const Color.fromARGB(255, 100, 111, 186);

  // neutral base UI
  static const Color kBg = Color(0xFFF5F6FA);
  static const Color kCard = Colors.white;
  static const Color kFieldFill = Color.fromARGB(255, 221, 219, 219);

  // ================= GPS (SAVE DIRECTLY IN PROVIDER) =================
  Future<void> _useCurrentLocation(BuildContext context) async {
    final shop = context.read<ShopProvider>();

    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Location permission denied")),
        );
      }
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks.first;

      String address =
          "${place.street ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}, ${place.country ?? ""}"
              .replaceAll(RegExp(r',\s*,+'), ', ')
              .trim();

      shop.setAddress(
        AddressModel(
          fullAddress: address,
          name: shop.address?.name ?? "",
          phone: shop.address?.phone ?? "",
          email: shop.address?.email ?? "",
        ),
      );
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to fetch location")),
        );
      }
    }
  }

  // ================= ADDRESS FORM (GOOD UI/UX) =================
  void _openAddressForm(BuildContext context) {
    final shop = context.read<ShopProvider>();
    final formKey = GlobalKey<FormState>();

    final nameController = TextEditingController(text: shop.address?.name ?? "");
    final phoneController =
        TextEditingController(text: shop.address?.phone ?? "");
    final emailController =
        TextEditingController(text: shop.address?.email ?? "");
    final addressController =
        TextEditingController(text: shop.address?.fullAddress ?? "");

    Future<void> fillFromGps() async {
      LocationPermission permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location permission denied")),
          );
        }
        return;
      }

      try {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        Placemark place = placemarks.first;

        String full =
            "${place.street ?? ""}, ${place.locality ?? ""}, ${place.administrativeArea ?? ""}, ${place.country ?? ""}"
                .replaceAll(RegExp(r',\s*,+'), ', ')
                .trim();

        addressController.text = full;
      } catch (_) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to get location")),
          );
        }
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.55,
          maxChildSize: 0.95,
          builder: (ctx, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 18,
                  right: 18,
                  top: 12,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 18,
                ),
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Drag handle
                      Center(
                        child: Container(
                          width: 44,
                          height: 5,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Delivery Details",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Please fill correct info for smooth delivery.",
                        style: TextStyle(color: const Color.fromARGB(255, 8, 8, 8)),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.my_location),
                          label: const Text("Use Current Location"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color.fromARGB(255, 153, 140, 228),
                            side: BorderSide(color: const Color.fromARGB(255, 11, 11, 11).withOpacity(0.4)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: fillFromGps,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _niceField(
                        label: "Full Name",
                        icon: Icons.person_outline,
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter your name";
                          if (v.trim().length < 2) return "Name too short";
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      _niceField(
                        label: "Phone Number",
                        icon: Icons.phone_outlined,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter phone number";
                          if (v.trim().length < 8) return "Enter valid phone number";
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      _niceField(
                        label: "Email",
                        icon: Icons.email_outlined,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter email";
                          final ok =
                              RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim());
                          if (!ok) return "Enter valid email";
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      _niceField(
                        label: "Delivery Address",
                        icon: Icons.location_on_outlined,
                        controller: addressController,
                        keyboardType: TextInputType.streetAddress,
                        maxLines: 2,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return "Enter address";
                          if (v.trim().length < 6) return "Address too short";
                          return null;
                        },
                      ),

                      const SizedBox(height: 18),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 100, 111, 186),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: () {
                            if (!formKey.currentState!.validate()) return;

                            shop.setAddress(
                              AddressModel(
                                fullAddress: addressController.text.trim(),
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                email: emailController.text.trim(),
                              ),
                            );

                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Save Address",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color.fromARGB(255, 254, 254, 254),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

    double shipping = shop.shippingCharge;
    double totalPayment = shop.finalTotal;

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Delivery Address",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            if (shop.address == null)
              GestureDetector(
                onTap: () => _openAddressForm(context),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: kCard,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add, color: kPrimaryPink),
                      SizedBox(width: 10),
                      Text(
                        "Add Delivery Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            if (shop.address != null)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => _useCurrentLocation(context),
                          child: const Text(
                            "Use Current Location",
                            style: TextStyle(color: kPrimaryPink),
                          ),
                        ),
                        TextButton(
                          onPressed: () => _openAddressForm(context),
                          child: const Text(
                            "Change",
                            style: TextStyle(color: kPrimaryPink),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: kCard,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: kPrimaryPink),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shop.address!.fullAddress,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 10),
                        infoRow(Icons.person, shop.address!.name),
                        infoRow(Icons.phone, shop.address!.phone),
                        infoRow(Icons.email, shop.address!.email),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 25),

            // DELIVERY OPTIONS
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Radio(
                  value: "standard",
                  groupValue: shop.deliveryType,
                  activeColor: kPrimaryPink,
                  onChanged: (value) {
                    context.read<ShopProvider>().setDeliveryType(value!);
                  },
                ),
                const Text("Standard Delivery"),
                Radio(
                  value: "express",
                  groupValue: shop.deliveryType,
                  activeColor: kPrimaryPink,
                  onChanged: (value) {
                    context.read<ShopProvider>().setDeliveryType(value!);
                  },
                ),
                const Text("Express Delivery"),
              ],
            ),

            const SizedBox(height: 20),

            // ORDER DETAILS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCard,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                children: [
                  rowItem("Total Amount", shop.totalPrice),
                  rowItem("Shipping", shipping),
                  const Divider(),
                  rowItem("Total Payment", totalPayment, isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 15),

            bannerCard(
              const Color(0xFFFFEEF3),
              Icons.star,
              kPrimaryPink,
              "Get ${totalPayment.toInt()} Reward Points on this purchase",
            ),

            const SizedBox(height: 10),

            bannerCard(
              const Color(0xFFEFFAF3),
              Icons.local_offer,
              const Color(0xFF2E7D32),
              "You are saving Rs.${(shop.totalPrice * 0.05).toInt()} on this purchase",
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.grey,
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rs.${totalPayment.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 100, 111, 186),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final shop = context.read<ShopProvider>();

                if (shop.address == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please add delivery address first"),
                    ),
                  );
                  return;
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentMethodScreen(
                      totalAmount: totalPayment,
                    ),
                  ),
                );
              },
              child: const Text(
                "Proceed",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  // ================= SMALL WIDGETS =================

  Widget _niceField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color.fromARGB(255, 10, 10, 10)),
        filled: true,
        fillColor: kFieldFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color.fromARGB(255, 121, 118, 119), width: 1.5),
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget bannerCard(Color bg, IconData icon, Color iconColor, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowItem(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
          Text(
            "Rs.${amount.toStringAsFixed(0)}",
            style: TextStyle(fontWeight: isBold ? FontWeight.bold : null),
          ),
        ],
      ),
    );
  }
}