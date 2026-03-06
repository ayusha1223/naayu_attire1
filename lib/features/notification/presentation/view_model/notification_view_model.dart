import 'package:flutter/material.dart';
import 'package:naayu_attire1/features/notification/domain/usecases/get_notification_usecase.dart';
import '../../domain/models/app_notification.dart';

import '../../domain/usecases/mark_notification_read_usecase.dart';

class NotificationViewModel extends ChangeNotifier {

  final GetNotificationsUsecase getNotificationsUsecase;
  final MarkNotificationReadUsecase markNotificationReadUsecase;

  NotificationViewModel(
    this.getNotificationsUsecase,
    this.markNotificationReadUsecase,
  );

  List<AppNotification> notifications = [];

  bool isLoading = false;

  Future<void> fetchNotifications() async {

    try {

      isLoading = true;
      notifyListeners();

      notifications = await getNotificationsUsecase();

    } catch (e) {

      debugPrint("Notification fetch error: $e");

    } finally {

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String id) async {

    try {

      await markNotificationReadUsecase(id);

      final index = notifications.indexWhere((n) => n.id == id);

      if (index != -1) {

        notifications[index] = AppNotification(
          id: notifications[index].id,
          message: notifications[index].message,
          isRead: true,
          createdAt: notifications[index].createdAt,
        );
      }

      notifyListeners();

    } catch (e) {

      debugPrint("Mark read error: $e");
    }
  }
}