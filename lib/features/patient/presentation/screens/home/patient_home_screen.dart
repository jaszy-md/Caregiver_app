import 'dart:async';

import 'package:care_link/core/riverpod_providers/notifications_providers.dart';
import 'package:care_link/features/patient/presentation/widgets/dialogs/concerned_notification_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/patient/presentation/widgets/sections/patient_notifications_section.dart';

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

  void _onNotificationSent() {
    final now = DateTime.now();

    // 🔹 Opschonen eerst
    _sentTimestamps.removeWhere((t) => now.difference(t) > _window);

    // 🔴 Check vóór toevoegen → exact op tijd
    if (_sentTimestamps.length >= _threshold - 1 && !_dialogShown) {
      _dialogShown = true;

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const ConcernedNotificationDialog(phoneNumber: '112'),
      ).then((_) {
        // reset na dialoog
        _sentTimestamps.clear();
        _dialogShown = false;
      });
    }

    // ➕ pas NU toevoegen
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
