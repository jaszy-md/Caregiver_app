import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivePatientNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setActivePatient(String uid) {
    print('[ActivePatient] setActivePatient uid=$uid');
    state = uid;
  }

  void clear() {
    print('[ActivePatient] clear');
    state = null;
  }
}

final activePatientProvider = NotifierProvider<ActivePatientNotifier, String?>(
  ActivePatientNotifier.new,
);
