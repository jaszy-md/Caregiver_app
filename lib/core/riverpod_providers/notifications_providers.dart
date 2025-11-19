import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/core/firestore/services/notifications_service.dart';
import 'package:care_link/core/firestore/models/notification_item.dart';

/// Service provider
final notificationsServiceProvider = Provider<NotificationsService>((ref) {
  return NotificationsService();
});

/// FutureProvider → haalt alle notificatieblokken uit Firestore
final notificationBlocksProvider = FutureProvider<List<NotificationItem>>((
  ref,
) async {
  final service = ref.read(notificationsServiceProvider);
  return service.fetchNotificationBlocks();
});
