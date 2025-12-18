import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsContext {
  final String targetUid;
  final String? displayName;
  final int? weekPercentage;

  const StatsContext({
    required this.targetUid,
    this.displayName,
    this.weekPercentage,
  });
}

class StatsContextNotifier extends Notifier<StatsContext?> {
  @override
  StatsContext? build() => null;

  void setContext({
    required String targetUid,
    String? displayName,
    int? weekPercentage,
  }) {
    state = StatsContext(
      targetUid: targetUid,
      displayName: displayName,
      weekPercentage: weekPercentage,
    );
  }

  void clear() {
    state = null;
  }
}

final statsContextProvider =
    NotifierProvider<StatsContextNotifier, StatsContext?>(
      StatsContextNotifier.new,
    );
