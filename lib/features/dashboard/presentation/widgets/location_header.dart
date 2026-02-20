import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/features/favorites/presentation/screens/favorites_screen.dart';
import '../screens/map_screen.dart';

class LocationHeader extends StatefulWidget {
  const LocationHeader({super.key});

  @override
  State<LocationHeader> createState() => _LocationHeaderState();
}

class _LocationHeaderState extends State<LocationHeader> {
  bool _isLoading = false;

  Future<void> _useCurrentLocation() async {
    if (!mounted) return;

    final shop = context.read<ShopProvider>();

    setState(() => _isLoading = true);

    try {
      // Check if location service is enabled
      bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoading = false);
        return;
      }

      // Request permission
      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();
      }

      if (permission ==
              LocationPermission.denied ||
          permission ==
              LocationPermission.deniedForever) {
        setState(() => _isLoading = false);
        return;
      }

      // Get position
      Position position =
          await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Convert to readable address
      List<Placemark> placemarks =
          await placemarkFromCoordinates(
              position.latitude,
              position.longitude);

      Placemark place = placemarks.first;

      String address =
          "${place.locality ?? ""}, ${place.country ?? ""}";

      shop.setLocation(address);

    } catch (e) {
      debugPrint("Header GPS Error: $e");
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _openLocationOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
                top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding:
              const EdgeInsets.all(20),
          child: Column(
            mainAxisSize:
                MainAxisSize.min,
            children: [

              const Text(
                "Choose Location",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              ListTile(
                leading: const Icon(
                  Icons.my_location,
                  color: Colors.brown,
                ),
                title: const Text(
                    "Use Current Location"),
                onTap: () {
                  Navigator.pop(context);
                  _useCurrentLocation();
                },
              ),

              ListTile(
                leading: const Icon(
                  Icons.map,
                  color: Colors.brown,
                ),
                title: const Text(
                    "Add Location on Map"),
                onTap: () async {
                  Navigator.pop(context);

                  final result =
                      await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          const MapScreen(),
                    ),
                  );

                  if (result != null &&
                      mounted) {
                    context
                        .read<
                            ShopProvider>()
                        .setLocation(
                            result);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final shop =
        context.watch<ShopProvider>();

    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment
                .spaceBetween,
        children: [

          GestureDetector(
            onTap:
                _openLocationOptions,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [

                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 12,
                    color:
                        Colors.grey,
                  ),
                ),

                const SizedBox(
                    height: 4),

                Row(
                  children: [

                    const Icon(
                      Icons
                          .location_on,
                      size: 16,
                      color:
                          Colors.brown,
                    ),

                    const SizedBox(
                        width: 4),

                    _isLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child:
                                CircularProgressIndicator(
                              strokeWidth:
                                  2,
                            ),
                          )
                        : Text(
                            shop
                                .selectedLocation,
                            style:
                                const TextStyle(
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                  ],
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const FavoritesScreen(),
                ),
              );
            },
            child: Stack(
              children: [

                const CircleAvatar(
                  backgroundColor:
                      Colors.white,
                  child: Icon(
                    Icons
                        .favorite_border,
                    color:
                        Colors.red,
                  ),
                ),

                if (shop.favorites
                    .isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child:
                        Container(
                      padding:
                          const EdgeInsets
                              .all(4),
                      decoration:
                          const BoxDecoration(
                        color:
                            Colors.red,
                        shape:
                            BoxShape
                                .circle,
                      ),
                      child: Text(
                        shop
                            .favorites
                            .length
                            .toString(),
                        style:
                            const TextStyle(
                          color:
                              Colors.white,
                          fontSize:
                              10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}