import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:care_link/features/shared/presentation/widgets/buttons/small_btn.dart';
import 'package:care_link/features/shared/presentation/widgets/dialogs/logout_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:care_link/features/auth/data/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CaregiverProfileScreen extends StatelessWidget {
  const CaregiverProfileScreen({super.key});

  String _mapUserRole(String? role) {
    switch (role) {
      case 'caregiver':
        return 'Mantelzorger';
      case 'patient':
        return 'Zorgbehoevende';
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

      if (context.mounted) {
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.8;
    final containerHeight = size.height * 0.43;

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
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomRight: Radius.circular(12),
                              ),
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

                                      final name = data?['name'] ?? '';
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

                            SizedBox(height: containerHeight * 0.04),

                            SmallBtn(
                              text: 'Licenties',
                              onTap: () {
                                showLicensePage(
                                  context: context,
                                  applicationName: 'CareLink',
                                  applicationVersion: '1.0.0',
                                  applicationLegalese:
                                      '© ${DateTime.now().year} CareLink Team',
                                );
                              },
                            ),

                            const SmallBtn(text: 'Verander rol'),
                            const SmallBtn(
                              text: 'Verwijder account',
                              icon: Icons.delete_outline,
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        bottom: 15,
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
