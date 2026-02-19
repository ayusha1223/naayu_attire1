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

  // ================= GPS =================

  Future<void> _useCurrentLocation(BuildContext context) async {
    final shop = context.read<ShopProvider>();

    LocationPermission permission =
        await Geolocator.requestPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    Position position =
        await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(
            position.latitude, position.longitude);

    Placemark place = placemarks.first;

    String address =
        "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

    shop.setAddress(
      AddressModel(
        fullAddress: address,
        name: shop.address?.name ?? "",
        phone: shop.address?.phone ?? "",
        email: shop.address?.email ?? "",
      ),
    );
  }

  // ================= ADDRESS FORM =================

  void _openAddressForm(BuildContext context) {
    final shop = context.read<ShopProvider>();

    final nameController =
        TextEditingController(text: shop.address?.name ?? "");
    final phoneController =
        TextEditingController(text: shop.address?.phone ?? "");
    final emailController =
        TextEditingController(text: shop.address?.email ?? "");
    final addressController =
        TextEditingController(text: shop.address?.fullAddress ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [

                const Text(
                  "Enter Delivery Details",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 25),

                TextField(
                  controller: nameController,
                  decoration:
                      const InputDecoration(labelText: "Name"),
                ),

                TextField(
                  controller: phoneController,
                  decoration:
                      const InputDecoration(labelText: "Phone"),
                  keyboardType: TextInputType.phone,
                ),

                TextField(
                  controller: emailController,
                  decoration:
                      const InputDecoration(labelText: "Email"),
                  keyboardType: TextInputType.emailAddress,
                ),

                TextField(
                  controller: addressController,
                  decoration:
                      const InputDecoration(labelText: "Address"),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    shop.setAddress(
                      AddressModel(
                        fullAddress: addressController.text,
                        name: nameController.text,
                        phone: phoneController.text,
                        email: emailController.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text("Save"),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
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
      backgroundColor: Colors.grey.shade100,

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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(18),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.add,
                          color: Colors.pink),
                      SizedBox(width: 10),
                      Text(
                        "Add Delivery Details",
                        style: TextStyle(
                            fontWeight:
                                FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

            if (shop.address != null)
              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _useCurrentLocation(context),
                          child: const Text(
                              "Use Current Location"),
                        ),
                        TextButton(
                          onPressed: () =>
                              _openAddressForm(context),
                          child: const Text("Change"),
                        ),
                      ],
                    ),
                  ),

                  // FANCY ADDRESS CARD
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16),
                    padding:
                        const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey
                              .withOpacity(0.15),
                          blurRadius: 20,
                          offset:
                              const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [

                        Row(
                          children: [
                            const Icon(
                                Icons.location_on,
                                color: Colors.pink),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                shop.address!
                                    .fullAddress,
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15),
                        Divider(
                            color: Colors.grey
                                .shade300),
                        const SizedBox(height: 10),

                        infoRow(Icons.person,
                            shop.address!.name),
                        infoRow(Icons.phone,
                            shop.address!.phone),
                        infoRow(Icons.email,
                            shop.address!.email),
                      ],
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 25),

            // DELIVERY OPTIONS
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [

                Radio(
                  value: "standard",
                  groupValue:
                      shop.deliveryType,
                  activeColor: Colors.pink,
                  onChanged: (value) {
                    context
                        .read<ShopProvider>()
                        .setDeliveryType(
                            value!);
                  },
                ),
                const Text("Standard Delivery"),

                Radio(
                  value: "express",
                  groupValue:
                      shop.deliveryType,
                  activeColor: Colors.pink,
                  onChanged: (value) {
                    context
                        .read<ShopProvider>()
                        .setDeliveryType(
                            value!);
                  },
                ),
                const Text("Express Delivery"),
              ],
            ),

            const SizedBox(height: 20),

            // ORDER DETAILS
            Container(
              margin: const EdgeInsets.symmetric(
                  horizontal: 16),
              padding:
                  const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(18),
              ),
              child: Column(
                children: [

                  rowItem("Total Amount",
                      shop.totalPrice),
                  rowItem("Shipping",
                      shipping),

                  const Divider(),

                  rowItem("Total Payment",
                      totalPayment,
                      isBold: true),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // REWARD BANNER
            bannerCard(
              Colors.pink.shade50,
              Icons.star,
              Colors.pink,
              "Get ${totalPayment.toInt()} Reward Points on this purchase",
            ),

            const SizedBox(height: 10),

            bannerCard(
              Colors.green.shade50,
              Icons.local_offer,
              Colors.green,
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
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [

            Text(
              "Rs.${totalPayment.toStringAsFixed(0)}",
              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

         ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromARGB(255, 220, 136, 164),
    padding: const EdgeInsets.symmetric(
        horizontal: 30, vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  onPressed: () {

    // Optional validation
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
       builder: (context) =>
    PaymentMethodScreen(
      totalAmount: totalPayment,
    ),
      )
    );
  },
  child: const Text("Proceed"),
)
          ],
        ),
      ),
    );
  }

  Widget infoRow(IconData icon, String text) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: Colors.grey),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  Widget bannerCard(
      Color bg,
      IconData icon,
      Color iconColor,
      String text) {
    return Container(
      margin:
          const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontWeight:
                    FontWeight.w600,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget rowItem(String title, double amount,
      {bool isBold = false}) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight:
                  isBold
                      ? FontWeight.bold
                      : null,
            ),
          ),
          Text(
            "Rs.${amount.toStringAsFixed(0)}",
            style: TextStyle(
              fontWeight:
                  isBold
                      ? FontWeight.bold
                      : null,
            ),
          ),
        ],
      ),
    );
  }
}
