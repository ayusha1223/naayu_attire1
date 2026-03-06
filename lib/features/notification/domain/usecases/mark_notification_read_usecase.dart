import '../repositories/notification_repository.dart';

class MarkNotificationReadUsecase {

  final NotificationRepository repository;

  MarkNotificationReadUsecase(this.repository);

  Future<void> call(String id) {
    return repository.markAsRead(id);
  }
}