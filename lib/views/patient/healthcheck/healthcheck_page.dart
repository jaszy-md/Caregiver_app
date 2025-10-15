import 'package:care_link/widgets/tiles/health_stat_title.dart';
import 'package:flutter/material.dart';
import 'package:care_link/widgets/tiles/line_dot_title.dart';
import 'package:go_router/go_router.dart';

class HealthCheckPage extends StatefulWidget {
  const HealthCheckPage({super.key});

  @override
  State<HealthCheckPage> createState() => _HealthCheckPageState();
}

class _HealthCheckPageState extends State<HealthCheckPage> {
  final Map<String, int> _mystats = {
    'Energie': 0,
    'Eetlust': 3,
    'Stemming': 6,
    'Slaapritme': 8,
  };

  void _increment(String key) {
    setState(() {
      _mystats[key] = (_mystats[key]! + 1).clamp(0, 10);
    });
  }

  void _decrement(String key) {
    setState(() {
      _mystats[key] = (_mystats[key]! - 1).clamp(0, 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final double arrowW = size.width * 0.14;
    final double graphW = size.width * 0.11;

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                const Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: LineDotTitle(title: 'Health state'),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: SizedBox(
                    width: size.width * 0.70,
                    child: const Text(
                      'Rank jouw status en bekijk hier jouw state van de week! '
                      'Mantelzorgers kunnen dit ook bekijken',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        _mystats.entries.map((entry) {
                          return HealthStatTile(
                            label: entry.key,
                            value: entry.value,
                            onIncrement: () => _increment(entry.key),
                            onDecrement: () => _decrement(entry.key),
                          );
                        }).toList(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 20, top: 2, bottom: 20),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => context.go('/stats'),
                      child: Container(
                        width: 118,
                        height: 35,
                        decoration: BoxDecoration(
                          color: const Color(0xFF04454B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF008F9D),
                            width: 2,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: const Text(
                          'Opslaan',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: size.height * 0.135,
              right: 20,
              child: GestureDetector(
                onTap: () => context.go('/stats'),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: size.width * 0.04,
                        top: size.height * 0.01,
                      ),
                      child: Image.asset(
                        'assets/images/arrow-health-check.png',
                        width: arrowW,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -size.height * 0.025),
                      child: Image.asset(
                        'assets/images/graph-up.png',
                        width: graphW,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
