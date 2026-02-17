import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? selectedLocation;
  String selectedAddress = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Location"),
      ),
      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(28.3949, 84.1240),
              zoom: 6,
            ),
            onTap: (LatLng location) async {
              setState(() {
                selectedLocation = location;
              });

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(
                location.latitude,
                location.longitude,
              );

              if (placemarks.isNotEmpty) {
                final place = placemarks.first;
                selectedAddress =
                    "${place.locality}, ${place.country}";
              }
            },
            markers: selectedLocation == null
                ? {}
                : {
                    Marker(
                      markerId:
                          const MarkerId("selected"),
                      position: selectedLocation!,
                    )
                  },
          ),

          /// CONFIRM BUTTON
          if (selectedLocation != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context, selectedAddress);
                },
                child: const Text(
                    "Confirm Location"),
              ),
            )
        ],
      ),
    );
  }
}
