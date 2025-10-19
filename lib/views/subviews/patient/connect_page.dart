import 'package:flutter/material.dart';
import 'package:care_link/widgets/tiles/line_dot_title.dart';
import 'package:care_link/widgets/tiles/connect_step_tile.dart';
import 'package:care_link/widgets/sections/caregiver_connect_section.dart';
import 'package:care_link/gen/assets.gen.dart';

class ConnectPage extends StatelessWidget {
  const ConnectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double flyerW = size.width * 0.18;
    flyerW = flyerW.clamp(80.0, 130.0);
    final double flyerH = flyerW * 1.12;

    return SafeArea(
      top: false,
      bottom: true,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            Stack(
              clipBehavior: Clip.none,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: LineDotTitle(title: 'Connect Ketting'),
                ),
                Positioned(
                  top: -size.height * 0.08,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: SizedBox(
                        width: size.width,
                        child: Align(
                          alignment: Alignment.topRight,
                          child: Assets.images.kettingHeel.image(
                            width: size.width * 0.37,
                            height: size.height * 0.28,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ConnectStepTile(
                      number: '1',
                      text: 'Pak de bijbehorende folder',
                    ),
                    ConnectStepTile(
                      number: '2',
                      text: 'Klik hier op dit icoon',
                    ),
                    ConnectStepTile(
                      number: '3',
                      text: 'Scan de QR-code hier',
                      icon: Icons.qr_code_scanner,
                      showArrow: true,
                    ),
                    ConnectStepTile(
                      number: '4',
                      text: 'De ketting is verbonden!',
                    ),
                  ],
                ),
                Positioned(
                  top: size.height * 0.146,
                  right: 20,
                  child: Assets.images.flyer.image(
                    width: flyerW,
                    height: flyerH,
                    fit: BoxFit.contain,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            const LineDotTitle(title: 'Connect Mantelzorger'),
            const SizedBox(height: 25),
            const CaregiverConnectSection(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
