import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/core/firestore/services/caregiver_connect_service.dart';
import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/features/patient/presentation/widgets/dialogs/confirm_remove_caregiver_dialog.dart';
import 'package:care_link/core/riverpod_providers/active_patient_provider.dart';
import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';

class LinkedCaregiversSection extends ConsumerStatefulWidget {
  final ValueChanged<bool>? onExpandedChanged;

  const LinkedCaregiversSection({super.key, this.onExpandedChanged});

  @override
  ConsumerState<LinkedCaregiversSection> createState() =>
      _LinkedCaregiversSectionState();
}

class _LinkedCaregiversSectionState
    extends ConsumerState<LinkedCaregiversSection> {
  bool expanded = false;
  bool _autoSelected = false;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final service = CaregiverConnectService();
    final userService = UserService();
    final size = MediaQuery.of(context).size;

    final activeUid = ref.watch(activePatientProvider);

    if (user == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            setState(() => expanded = !expanded);
            widget.onExpandedChanged?.call(expanded);
          },
          child: Container(
            height: 42,
            color: const Color(0xFFCBDDD9),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                const Icon(Icons.people, size: 22, color: Color(0xFF00282C)),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Gekoppelde mantelzorgers',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF00282C),
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.0 : 0.5,
                  duration: const Duration(milliseconds: 200),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    size: 32,
                    color: Color(0xFF00282C),
                  ),
                ),
              ],
            ),
          ),
        ),

        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            heightFactor: expanded ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: Container(
              height: size.height * 0.22,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F6),
                border: Border.all(color: const Color(0xFFCBDDD9)),
              ),
              child: StreamBuilder(
                stream: service.watchLinkedUsers(user.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 1.8),
                    );
                  }

                  final caregivers =
                      snapshot.data as List<Map<String, dynamic>>;

                  if (caregivers.isEmpty) {
                    return const Center(
                      child: Text(
                        'Nog geen mantelzorgers gekoppeld',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  }

                  // ✅ AUTO SELECT (ZONDER NAVIGATIE)
                  if (!_autoSelected && activeUid == null) {
                    final first = caregivers.first;
                    _autoSelected = true;

                    final firstName =
                        (first['name'] as String?)?.trim().split(' ').first ??
                        'Onbekend';

                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                      ref
                          .read(activePatientProvider.notifier)
                          .setActivePatient(first['uid']);

                      ref
                          .read(statsContextProvider.notifier)
                          .setContext(
                            targetUid: first['uid'],
                            displayName: firstName,
                          );

                      await userService.setActivePatientForCaregiver(
                        caregiverUid: user.uid,
                        patientUid: first['uid'],
                      );
                    });
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Selecteer een persoon om de grafiekgegevens te bekijken',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 14,
                                  color: Color(0xFF3A8188),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.bar_chart_rounded,
                              size: 22,
                              color: Color(0xFF3A8188),
                            ),
                          ],
                        ),
                      ),

                      const Divider(height: 1),

                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: caregivers.length,
                          itemBuilder: (context, index) {
                            final c = caregivers[index];
                            final uid = c['uid'];
                            final fullName = c['name'] ?? 'Onbekend';
                            final firstName = fullName.trim().split(' ').first;
                            final isActive = uid == activeUid;

                            return InkWell(
                              onTap: () async {
                                ref
                                    .read(activePatientProvider.notifier)
                                    .setActivePatient(uid);

                                ref
                                    .read(statsContextProvider.notifier)
                                    .setContext(
                                      targetUid: uid,
                                      displayName: firstName,
                                    );

                                await userService.setActivePatientForCaregiver(
                                  caregiverUid: user.uid,
                                  patientUid: uid,
                                );

                                if (!mounted) return;

                                // 🚀 DIRECT NAAR STATS
                                context.go('/stats');
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      isActive
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_unchecked,
                                      size: 22,
                                      color:
                                          isActive
                                              ? const Color(0xFF3A8188)
                                              : Colors.black45,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        firstName,
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 17,
                                          color: const Color(0xFF00282C),
                                          fontWeight:
                                              isActive
                                                  ? FontWeight.w600
                                                  : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (_) =>
                                                  ConfirmRemoveCaregiverDialog(
                                                    name: firstName,
                                                    onConfirm: () async {
                                                      await service
                                                          .disconnectCaregiver(
                                                            patientUid:
                                                                user.uid,
                                                            caregiverUid: uid,
                                                          );
                                                    },
                                                  ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        size: 28,
                                        color: Color(0xFF8A1F1F),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
