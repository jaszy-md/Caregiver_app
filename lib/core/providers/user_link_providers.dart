import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/core/services/firebase/user_link_service.dart';

final userLinkServiceProvider = Provider((ref) => UserLinkService());
