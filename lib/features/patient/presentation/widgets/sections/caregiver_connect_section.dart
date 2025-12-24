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

  String _placeholderText = 'Voer mantelzorger-ID in';
  Color _placeholderColor = Colors.white70;

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
              padding: const EdgeInsets.symmetric(horizontal: 37),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: size.height * 0.010),

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
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Poppins',
                      ),
                      onChanged: (_) {
                        setState(() {
                          _placeholderText = 'Voer mantelzorger-ID in';
                          _placeholderColor = Colors.white70;
                        });
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.fromLTRB(
                          28,
                          14,
                          20,
                          14,
                        ),
                        hintText: _placeholderText,
                        hintMaxLines: 2,
                        hintStyle: TextStyle(
                          color: _placeholderColor,
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  GestureDetector(
                    onTap: () async {
                      final patient = FirebaseAuth.instance.currentUser;
                      if (patient == null) return;

                      final error = await _service.connectCaregiverByCode(
                        patient.uid,
                        _codeController.text,
                      );

                      if (error != null) {
                        setState(() {
                          _placeholderText = error;
                          _placeholderColor = const Color.fromARGB(
                            184,
                            160,
                            55,
                            55,
                          );
                          _codeController.clear();
                        });
                        return;
                      }

                      setState(() {
                        _placeholderText = 'Mantelzorger gekoppeld';
                        _placeholderColor = const Color(0xFF6EDC8C);
                        _codeController.clear();
                      });
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

                  const SizedBox(height: 10),

                  Container(
                    height: size.height * 0.17,
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
                              'Nog geen mantelzorgers gekoppeld',
                              textAlign: TextAlign.center,
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
                            final firstName =
                                (c['name'] ?? '').split(' ').first;
                            final displayName =
                                firstName.length > 7
                                    ? firstName.substring(0, 7)
                                    : firstName;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 6,
                                horizontal: 12,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayName,
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
                                              name: displayName,
                                              title: 'Mantelzorger verwijderen',
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
                                      size: 30,
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
