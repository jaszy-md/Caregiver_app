import 'dart:async';
import 'package:care_link/core/riverpod_providers/notifications_providers.dart';
import 'package:care_link/features/patient/data/notification_rate_limiter.dart';
import 'package:care_link/features/patient/presentation/widgets/dialogs/concerned_notification_dialog.dart';
import 'package:care_link/features/patient/presentation/widgets/sections/notification_timeout_section.dart';
import 'package:care_link/features/patient/presentation/widgets/sections/patient_notifications_section.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen>
    with AutomaticKeepAliveClientMixin {
  final NotificationRateLimiter _limiter = NotificationRateLimiter();

  String _selectedText = '';
  String? _tempText;
  bool _lastWasSent = false;

  Timer? _resetTimer;
  bool _isSending = false;

  bool get _isTimeoutActive => _limiter.isTimeoutActive;

  @override
  bool get wantKeepAlive => true;

  void _onTileSelected(String text) {
    _resetTimer?.cancel();
    setState(() {
      _selectedText = text;
      _tempText = null;
      _lastWasSent = false;
    });
  }

  Future<String> _getEmergencyPhoneNumber() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final emergencyContact = doc.data()?['emergencyContact'];
    if (emergencyContact is String && emergencyContact.trim().isNotEmpty) {
      return emergencyContact.trim();
    }
    return '112';
  }

  Future<bool> _onNotificationAttempt() async {
    if (_isSending) return false;
    _isSending = true;

    final result = _limiter.trySend();

    switch (result) {
      case NotificationBlockResult.allowed:
        _resetTimer?.cancel();
        setState(() {
          _tempText = 'Verzonden! ✓';
          _lastWasSent = true;
        });

        _resetTimer = Timer(const Duration(seconds: 2), () {
          if (!mounted) return;
          setState(() {
            _tempText = null;
            _lastWasSent = false;
          });
        });

        _isSending = false;
        return true;

      case NotificationBlockResult.showConcerned:
        final phoneNumber = await _getEmergencyPhoneNumber();
        if (mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder:
                (_) => ConcernedNotificationDialog(phoneNumber: phoneNumber),
          );
        }
        _isSending = false;
        return false;

      case NotificationBlockResult.startTimeout:
        setState(() {});
        _isSending = false;
        return false;
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final asyncBlocks = ref.watch(notificationBlocksProvider);

    return asyncBlocks.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Fout bij laden: $e')),
      data: (blocks) {
        if (_selectedText.isEmpty && blocks.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _selectedText = blocks.first.label);
            }
          });
        }

        final displayText = _tempText ?? _selectedText;

        return SafeArea(
          child: Column(
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Assets.images.noteCloud.image(width: 280),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        displayText.isNotEmpty ? '“$displayText”' : '',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color:
                              _lastWasSent
                                  ? const Color(0xFFB45309)
                                  : const Color(0xFF005159),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: _isTimeoutActive,
                      child: Center(
                        child: PatientNotificationsSection(
                          blocks: blocks,
                          onTileSelected: _onTileSelected,
                          onNotificationAttempt: _onNotificationAttempt,
                          isTimeoutActive: _isTimeoutActive,
                        ),
                      ),
                    ),
                    if (_isTimeoutActive && _limiter.timeoutUntil != null)
                      Align(
                        alignment: Alignment.topCenter,
                        child: NotificationTimeoutSection(
                          timeoutUntil: _limiter.timeoutUntil!,
                          onFinished: () {
                            setState(() {
                              _limiter.onTimeoutFinished();
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
