import 'package:dio/dio.dart';
import 'package:naayu_attire1/features/notification/domain/models/app_notification.dart';

class NotificationRemoteDatasource {
  final Dio dio;

  NotificationRemoteDatasource(this.dio);

  Future<List<AppNotification>> fetchNotifications() async {
    final response = await dio.get("/notifications/my");

    return (response.data as List)
        .map((e) => AppNotification.fromJson(e))
        .toList();
  }

  Future<void> markAsRead(String id) async {
    await dio.put("/notifications/read/$id");
  }
}