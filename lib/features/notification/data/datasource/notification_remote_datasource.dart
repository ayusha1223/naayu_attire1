import 'package:dio/dio.dart';
import 'package:naayu_attire1/features/notification/domain/models/app_notification.dart';

class NotificationRemoteDatasource {
  final Dio dio;

  NotificationRemoteDatasource(this.dio);

   Future<List<AppNotification>> fetchNotifications() async {
  final response = await dio.get("/notifications/my");

  print("RAW NOTIFICATION RESPONSE: ${response.data}");

  final List data =
      response.data is List
          ? response.data
          : response.data["data"] ?? [];

  return data
      .map((e) => AppNotification.fromJson(e))
      .toList();
}

  Future<void> markAsRead(String id) async {
    await dio.put("/notifications/read/$id");
  }
}