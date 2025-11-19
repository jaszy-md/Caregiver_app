import 'package:care_link/core/riverpod_providers/notifications_providers.dart';
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
  bool joystickActive = true;

  @override
  bool get wantKeepAlive => true;

  void _onTileSelected(String text) {
    setState(() => _selectedText = text);
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
                      gaplessPlayback: true,
                      filterQuality: FilterQuality.high,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        _selectedText.isNotEmpty ? '“$_selectedText”' : '',
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
