import '../models/app_notification.dart';
import '../repositories/notification_repository.dart';

class GetNotificationsUsecase {

  final NotificationRepository repository;

  GetNotificationsUsecase(this.repository);

  Future<List<AppNotification>> call() {
    return repository.getNotifications();
  }
}