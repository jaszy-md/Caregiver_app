import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/core/firestore/services/user_link_service.dart';

final userLinkServiceProvider = Provider<UserLinkService>((ref) {
  return UserLinkService();
});
