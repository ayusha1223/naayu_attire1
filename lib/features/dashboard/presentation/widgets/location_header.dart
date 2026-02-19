import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:naayu_attire1/core/providers/shop_provider.dart';
import 'package:naayu_attire1/features/favorites/presentation/screens/favorites_screen.dart';
import '../screens/map_screen.dart';

class LocationHeader extends StatefulWidget {
  const LocationHeader({super.key});

  @override
  State<LocationHeader> createState() =>
      _LocationHeaderState();
}

class _LocationHeaderState
    extends State<LocationHeader> {
  String userLocation = "Select Location";

  Future<void> _openMap() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const MapScreen(),
      ),
    );

    if (result != null) {
      setState(() {
        userLocation = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [

          /// LOCATION
          GestureDetector(
            onTap: _openMap,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color:
                          Colors.brown,
                    ),
                    const SizedBox(
                        width: 4),
                    Text(
                      userLocation,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          /// NOTIFICATION + FAVORITE
          Row(
            children: [

              const CircleAvatar(
                backgroundColor:
                    Colors.white,
                child: Icon(
                    Icons
                        .notifications_none),
              ),

              const SizedBox(
                  width: 10),

              /// ❤️ FAVORITES WITH BADGE
              Consumer<ShopProvider>(
                builder:
                    (context, shop, _) {
                  return GestureDetector(
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
                                    Colors
                                        .red,
                                shape: BoxShape
                                    .circle,
                              ),
                              child: Text(
                                shop.favorites
                                    .length
                                    .toString(),
                                style:
                                    const TextStyle(
                                  color: Colors
                                      .white,
                                  fontSize:
                                      10,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
