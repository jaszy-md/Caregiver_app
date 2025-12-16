import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:care_link/features/shared/presentation/widgets/buttons/small_btn.dart';
import 'package:care_link/features/shared/presentation/widgets/dialogs/logout_confirm_dialog.dart';
import 'package:care_link/features/shared/presentation/widgets/dialogs/emergency_contact_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/patient/presentation/widgets/toggles/joystick_toggle.dart';
import 'package:care_link/features/patient/state/joystick_controller.dart';
import 'package:care_link/features/auth/data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PatientProfileScreen extends StatelessWidget {
  const PatientProfileScreen({super.key});

  String _mapUserRole(String? role) {
    switch (role) {
      case 'patient':
        return 'Zorgbehoevende';
      case 'caregiver':
        return 'Mantelzorger';
      default:
        return 'Gebruiker';
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (_) => const LogoutConfirmDialog(),
    );

    if (confirmed == true) {
      await AuthService().signOut();
      if (context.mounted) context.go('/login');
    }
  }

  Future<void> _openEmergencyDialog(
    BuildContext context,
    String uid,
    String? currentValue,
  ) async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder:
          (_) => EmergencyContactDialog(
            initialValue: currentValue,
            onSave: (value) async {
              await UserService().updateEmergencyContact(uid, value);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.8;
    final containerHeight = size.height * 0.46;
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              const LineDotTitle(title: 'Profiel'),
              const SizedBox(height: 25),

              Transform.translate(
                offset: const Offset(-2, 0),
                child: Container(
                  width: containerWidth,
                  height: containerHeight,
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF00282C), width: 2),
                      right: BorderSide(color: Color(0xFF00282C), width: 2),
                      bottom: BorderSide(color: Color(0xFF00282C), width: 2),
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Stack(
                    children: [
                      IgnorePointer(
                        child: Opacity(
                          opacity: 0.2,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 1, 161, 175),
                                  Color.fromARGB(255, 178, 247, 255),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ),

                      Positioned(
                        bottom: 6,
                        left: 0,
                        right: 0,
                        child: IgnorePointer(
                          child: Opacity(
                            opacity: 0.5,
                            child: Assets.images.profileImg.image(
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: containerHeight * 0.05),

                            // NAAM + ROL
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(198, 0, 82, 89),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream:
                                        FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(uid)
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      final data =
                                          snapshot.data?.data()
                                              as Map<String, dynamic>?;

                                      final name = data?['name'] ?? ' ';
                                      final role = _mapUserRole(data?['role']);

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            role,
                                            style: const TextStyle(
                                              color: Colors.white70,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                  GestureDetector(
                                    onTap: () => _logout(context),
                                    child: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 22,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 15),

                            // JOYSTICK
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: ValueListenableBuilder<bool>(
                                valueListenable:
                                    JoystickController().activeNotifier,
                                builder: (context, active, _) {
                                  return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Assets.images.joystick.image(
                                            width: 45,
                                            height: 45,
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Joystick besturing',
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 15,
                                              color: Color(0xFF004E52),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                      JoystickToggle(
                                        initialValue: active,
                                        onChanged: (value) async {
                                          JoystickController().setActive(value);
                                          await Future.delayed(
                                            const Duration(milliseconds: 500),
                                          );
                                          if (context.mounted) {
                                            context.go('/patienthome');
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),

                            SizedBox(height: containerHeight * 0.015),

                            // VERANDER ROL
                            const SmallBtn(text: 'Verander rol'),

                            // UW NOODNUMMER (NU ONDER VERANDER ROL)
                            StreamBuilder<DocumentSnapshot>(
                              stream:
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .snapshots(),
                              builder: (context, snapshot) {
                                final data =
                                    snapshot.data?.data()
                                        as Map<String, dynamic>?;
                                final emergencyContact =
                                    data?['emergencyContact'];

                                return SmallBtn(
                                  text: 'Uw noodnummer',
                                  icon: Icons.phone_in_talk,
                                  onTap:
                                      () => _openEmergencyDialog(
                                        context,
                                        uid,
                                        emergencyContact,
                                      ),
                                );
                              },
                            ),

                            const SmallBtn(
                              text: 'Verwijder account',
                              icon: Icons.delete_outline,
                            ),

                            const Spacer(),

                            // LICENTIES ONDERSTREEPT RECHTSONDER
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 20,
                                bottom: 8,
                              ),
                              child: Align(
                                alignment: Alignment.bottomRight,
                                child: GestureDetector(
                                  onTap: () {
                                    showLicensePage(
                                      context: context,
                                      applicationName: 'CareLink',
                                      applicationVersion: '1.0.0',
                                      applicationLegalese:
                                          '© ${DateTime.now().year} CareLink Team',
                                    );
                                  },
                                  child: const Text(
                                    'Licenties',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF004E52),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
