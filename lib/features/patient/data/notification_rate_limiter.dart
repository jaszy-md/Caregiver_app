enum NotificationBlockResult { allowed, showConcerned, startTimeout }

class NotificationRateLimiter {
  static const int maxPerCycle = 4;
  static const int maxConcernedDialogs = 2;
  static const Duration timeoutDuration = Duration(minutes: 5);

  int _sentInCycle = 0;
  int _concernedCount = 0;
  DateTime? timeoutUntil;

  bool get isTimeoutActive =>
      timeoutUntil != null && DateTime.now().isBefore(timeoutUntil!);

  NotificationBlockResult trySend() {
    if (isTimeoutActive) {
      return NotificationBlockResult.startTimeout;
    }

    if (_sentInCycle < maxPerCycle) {
      _sentInCycle++;
      return NotificationBlockResult.allowed;
    }

    if (_concernedCount < maxConcernedDialogs) {
      _concernedCount++;

      _sentInCycle = 0;

      return NotificationBlockResult.showConcerned;
    }

    timeoutUntil = DateTime.now().add(timeoutDuration);
    return NotificationBlockResult.startTimeout;
  }

  void onTimeoutFinished() {
    _sentInCycle = 0;
    timeoutUntil = null;
  }

  void resetAll() {
    _sentInCycle = 0;
    _concernedCount = 0;
    timeoutUntil = null;
  }
}
