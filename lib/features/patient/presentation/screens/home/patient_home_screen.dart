import 'dart:async';

import 'package:care_link/core/riverpod_providers/notifications_providers.dart';
import 'package:care_link/features/patient/presentation/widgets/dialogs/concerned_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/patient/presentation/widgets/sections/patient_notifications_section.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientHomeScreen extends ConsumerStatefulWidget {
  const PatientHomeScreen({super.key});

  @override
  ConsumerState<PatientHomeScreen> createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends ConsumerState<PatientHomeScreen>
    with AutomaticKeepAliveClientMixin {
  String _selectedText = '';
  String? _tempText;
  Timer? _resetTimer;

  final List<DateTime> _sentTimestamps = [];
  static const int _threshold = 7;
  static const Duration _window = Duration(seconds: 3);

  bool _dialogShown = false;

  @override
  bool get wantKeepAlive => true;

  void _onTileSelected(String text) {
    _resetTimer?.cancel();
    setState(() {
      _tempText = null;
      _selectedText = text;
    });
  }

  /// 👉 Haal noodnummer op uit user-tabel (fallback = 112)
  Future<String> _getEmergencyPhoneNumber() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    final data = doc.data();
    final emergencyContact = data?['emergencyContact'];

    if (emergencyContact == null ||
        emergencyContact is! String ||
        emergencyContact.trim().isEmpty) {
      return '112';
    }

    return emergencyContact.trim();
  }

  void _onNotificationSent() async {
    final now = DateTime.now();

    _sentTimestamps.removeWhere((t) => now.difference(t) > _window);

    if (_sentTimestamps.length >= _threshold - 1 && !_dialogShown) {
      _dialogShown = true;

      final phoneNumber = await _getEmergencyPhoneNumber();

      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => ConcernedNotificationDialog(phoneNumber: phoneNumber),
      ).then((_) {
        _sentTimestamps.clear();
        _dialogShown = false;
      });
    }

    _sentTimestamps.add(now);

    _resetTimer?.cancel();

    setState(() {
      _tempText = 'Verzonden! ✓';
    });

    _resetTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _tempText = null;
      });
    });
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
      error: (e, st) => Center(child: Text('Fout bij laden: $e')),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Assets.images.noteCloud.image(
                      width: 280,
                      fit: BoxFit.contain,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        displayText.isNotEmpty ? '“$displayText”' : '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF005159),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              Expanded(
                child: Center(
                  child: PatientNotificationsSection(
                    blocks: blocks,
                    onTileSelected: _onTileSelected,
                    onNotificationSent: _onNotificationSent,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
