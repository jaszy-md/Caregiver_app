import 'package:care_link/widgets/tiles/line_dot_title.dart';
import 'package:care_link/widgets/buttons/small_btn.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CaregiverProfilePage extends StatelessWidget {
  const CaregiverProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final containerWidth = size.width * 0.8;
    final containerHeight = size.height * 0.43;
    final topOffset = size.height * 0.12;

    return Stack(
      children: [
        const Positioned(
          top: 20,
          left: 0,
          child: LineDotTitle(title: 'Profiel'),
        ),

        Positioned(
          top: topOffset,
          left: -2,
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
                Opacity(
                  opacity: 0.2,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00A9BA), Color(0xFF63B2BA)],
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

                Padding(
                  padding: const EdgeInsets.only(left: 0, right: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: containerHeight * 0.07),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jasmin',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Mantelzorger',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () => context.go('/login'),
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
                      const SmallBtn(text: 'Licenties'),
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
                  child: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/images/profile-img.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
