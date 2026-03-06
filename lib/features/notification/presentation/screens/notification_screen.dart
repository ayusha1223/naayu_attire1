import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/notification_view_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState
    extends State<NotificationScreen> {

  @override
  void initState() {
    super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
  context.read<NotificationViewModel>().fetchNotifications();
});
  }

  @override
  Widget build(BuildContext context) {

    final vm = context.watch<NotificationViewModel>();

    print("NOTIFICATION COUNT IN UI: ${vm.notifications.length}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),

      body: vm.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )

         

              : ListView.builder(
                  itemCount: vm.notifications.length,
                  itemBuilder: (context, index) {

                    final notification =
                        vm.notifications[index];

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
                            .read<NotificationViewModel>()
                            .markAsRead(notification.id);
                      },
                    );
                  },
                ),
    );
  }
}