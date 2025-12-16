import 'package:care_link/core/firestore/services/caregiver_connect_service.dart';
import 'package:care_link/features/patient/presentation/widgets/dialogs/confirm_remove_caregiver_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:care_link/gen/assets.gen.dart';

class CaregiverConnectSection extends StatefulWidget {
  const CaregiverConnectSection({super.key});

  @override
  State<CaregiverConnectSection> createState() =>
      _CaregiverConnectSectionState();
}

class _CaregiverConnectSectionState extends State<CaregiverConnectSection> {
  final TextEditingController _codeController = TextEditingController();
  final _service = CaregiverConnectService();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final user = FirebaseAuth.instance.currentUser;

    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        child: Stack(
          alignment: Alignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Assets.images.connectMantelzorger.image(
                width: size.width * 0.8,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.020),
                  Container(
                    height: 57,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        center: Alignment(0.0, -0.6),
                        radius: 2.0,
                        colors: [Color(0xFF63A5A3), Color(0xFF4E908C)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: TextField(
                      controller: _codeController,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Voer mantelzorger-ID in',
                        hintStyle: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // BUTTON
                  GestureDetector(
                    onTap: () async {
                      final code = _codeController.text.trim();
                      if (code.isEmpty) return;

                      final patient = FirebaseAuth.instance.currentUser;
                      if (patient == null) return;

                      final error = await _service.connectCaregiverByCode(
                        patient.uid,
                        code,
                      );

                      if (error != null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(error)));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Mantelzorger gekoppeld!"),
                          ),
                        );
                        _codeController.clear();
                      }
                    },
                    child: Container(
                      width: 120,
                      height: 35,
                      decoration: BoxDecoration(
                        gradient: const RadialGradient(
                          center: Alignment(0.1, -0.4),
                          radius: 2.0,
                          colors: [Color(0xFF55BCC6), Color(0xFF3A8188)],
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Opslaan',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // CONNECTED USERS LIST
                  Container(
                    height: size.height * 0.18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00282C),
                      border: Border.all(color: Colors.white, width: 0.8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: StreamBuilder(
                      stream: _service.watchLinkedUsers(user!.uid),
                      builder: (context, snap) {
                        if (!snap.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 1.8,
                            ),
                          );
                        }

                        final caregivers =
                            snap.data as List<Map<String, dynamic>>;

                        if (caregivers.isEmpty) {
                          return const Center(
                            child: Text(
                              "Nog geen mantelzorgers gekoppeld",
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Poppins',
                                fontSize: 13,
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: caregivers.length,
                          itemBuilder: (context, i) {
                            final c = caregivers[i];
                            final name = c['name'] ?? 'Onbekend';

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder:
                                            (_) => ConfirmRemoveCaregiverDialog(
                                              name: name,
                                              onConfirm: () async {
                                                await _service
                                                    .disconnectCaregiver(
                                                      patientUid: user.uid,
                                                      caregiverUid: c['uid'],
                                                    );
                                              },
                                            ),
                                      );
                                    },
                                    child: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),

                  SizedBox(height: size.height * 0.045),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
