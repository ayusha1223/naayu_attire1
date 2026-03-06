import '../../domain/models/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';

class NotificationRepositoryImpl
    implements NotificationRepository {

  final NotificationRemoteDatasource remoteDatasource;

  NotificationRepositoryImpl(this.remoteDatasource);

  @override
  Future<List<AppNotification>> getNotifications() {
    return remoteDatasource.fetchNotifications();
  }

  @override
  Future<void> markAsRead(String id) {
    return remoteDatasource.markAsRead(id);
  }
}