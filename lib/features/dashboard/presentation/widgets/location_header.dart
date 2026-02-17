import 'package:flutter/material.dart';

class LocationHeader extends StatelessWidget {
  const LocationHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Location",
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey)),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on,
                      size: 16,
                      color: Colors.brown),
                  SizedBox(width: 4),
                  Text("New York, USA",
                      style: TextStyle(
                          fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),

          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.notifications_none),
              ),
              SizedBox(width: 10),
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.favorite_border),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
