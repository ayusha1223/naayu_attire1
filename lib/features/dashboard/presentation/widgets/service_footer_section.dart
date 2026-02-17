import 'package:flutter/material.dart';

class ServiceFooterSection extends StatelessWidget {
  const ServiceFooterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// ===== SERVICES GRID =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1,
            children: const [

              ServiceBox(
                color: Color(0xffF8DDE4),
                icon: Icons.local_shipping_outlined,
                title: "Free Shipping",
                subtitle: "For VIP Customers Only",
              ),

              ServiceBox(
                color: Color(0xffDDEFF6),
                icon: Icons.swap_horiz,
                title: "Free Replacement",
                subtitle: "All orders freely replaced",
              ),

              ServiceBox(
                color: Color(0xffE6F0DC),
                icon: Icons.payments_outlined,
                title: "Cash on Delivery",
                subtitle: "Pay after you get product",
              ),

              ServiceBox(
                color: Color(0xffEADFF2),
                icon: Icons.shield_outlined,
                title: "100 % Privacy",
                subtitle: "Your privacy is concerned",
              ),
            ],
          ),
        ),

        const SizedBox(height: 25),

        /// ===== BUTTONS =====
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [

              /// Call Us
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Have Enquiries? Call us",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// Email
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.pink),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Email your Queries",
                    style: TextStyle(
                        color: Colors.pink,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        /// ===== FOLLOW US =====
        Column(
          children: [

            const Text(
              "Follow Us on:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [

                Icon(Icons.camera_alt, size: 30, color: Colors.purple),
                SizedBox(width: 20),

                Icon(Icons.play_circle_fill, size: 30, color: Colors.red),
                SizedBox(width: 20),

                Icon(Icons.facebook, size: 30, color: Colors.blue),
              ],
            ),
          ],
        ),

        const SizedBox(height: 25),

        /// ===== COPYRIGHT =====
        const Text(
          "© 2023 foreveryng.com | All Rights Reserved",
          style: TextStyle(
              fontSize: 12,
              color: Colors.grey),
        ),

        const SizedBox(height: 40),
      ],
    );
  }
}

class ServiceBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const ServiceBox({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 28,
            child: Icon(icon, size: 28),
          ),

          const SizedBox(height: 14),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
