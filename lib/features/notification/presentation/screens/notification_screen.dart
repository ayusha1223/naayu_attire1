import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/providers/shop_provider.dart';


class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final shop = context.watch<ShopProvider>();

     print("NOTIFICATION COUNT IN UI: ${shop.notifications.length}");

    return Scaffold(
      appBar: AppBar(title: const Text("Notifications")),
      body: shop.isLoadingNotifications
    ? const Center(child: CircularProgressIndicator())
    : shop.notifications.isEmpty
        ? const Center(child: Text("No notifications yet"))
        : ListView.builder(
            itemCount: shop.notifications.length,
            itemBuilder: (context, index) {
              final notification = shop.notifications[index];

              return ListTile(
                leading: Icon(
                  Icons.notifications,
                  color: notification.isRead
                      ? Colors.grey
                      : Colors.red,
                ),
                title: Text(notification.message),
                subtitle: Text(
                  notification.createdAt.toString(),
                ),
                onTap: () {
                  context
                      .read<ShopProvider>()
                      .markAsRead(notification.id);
                },
              );
            },
          ),
    );
  }
}