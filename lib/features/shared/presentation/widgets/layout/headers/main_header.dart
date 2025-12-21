import 'package:care_link/gen/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:care_link/features/shared/presentation/widgets/dialogs/logout_confirm_dialog.dart';
import 'package:care_link/features/auth/data/services/auth_service.dart';
import 'package:go_router/go_router.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader({super.key});

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

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: const Color.fromARGB(255, 0, 25, 28),
        child: SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF00282C),
                  Color(0xFF90A8AA),
                  Color(0xFFFFFFFF),
                ],
                stops: [0.0, 0.55, 1.0],
              ),
            ),
            child: SizedBox(
              height: preferredSize.height,
              child: Stack(
                children: [
                  Center(
                    child: Assets.images.logoWit.image(
                      height: 70,
                      width: 150,
                      fit: BoxFit.contain,
                    ),
                  ),

                  Positioned(
                    right: 8,
                    top: 8,
                    child: PopupMenuButton<_HeaderAction>(
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      color: const Color(0xFFD9F1F2),
                      position: PopupMenuPosition.under,
                      offset: const Offset(-15, -5),
                      constraints: const BoxConstraints(maxWidth: 80),
                      onSelected: (value) {
                        if (value == _HeaderAction.logout) {
                          _logout(context);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            PopupMenuItem<_HeaderAction>(
                              value: _HeaderAction.logout,
                              height: 15,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    'Logout',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF004E52),
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(
                                    Icons.logout,
                                    size: 14,
                                    color: Color(0xFF004E52),
                                  ),
                                ],
                              ),
                            ),
                          ],
                      child: IconButton(
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        splashRadius: 1,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        enableFeedback: false,
                        onPressed: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(110);
}

enum _HeaderAction { logout }
