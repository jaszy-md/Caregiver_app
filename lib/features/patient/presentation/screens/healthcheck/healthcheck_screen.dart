import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';
import 'package:care_link/features/patient/presentation/widgets/tiles/health_stat_title.dart';
import 'package:flutter/material.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:go_router/go_router.dart';
import 'package:care_link/gen/assets.gen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HealthCheckScreen extends ConsumerStatefulWidget {
  const HealthCheckScreen({super.key});

  @override
  ConsumerState<HealthCheckScreen> createState() => _HealthCheckScreenState();
}

class _HealthCheckScreenState extends ConsumerState<HealthCheckScreen> {
  final _userService = UserService();
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  Map<String, int> _mystats = {
    'Energie': 0,
    'Eetlust': 0,
    'Stemming': 0,
    'Slaapritme': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

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

  Future<void> _loadStats() async {
    final user = await _userService.getUser(_uid);
    final stats = user?['healthStats'] as Map<String, dynamic>?;

    if (!mounted || stats == null) return;

    setState(() {
      _mystats = {
        'Energie': stats['energie'] ?? 0,
        'Eetlust': stats['eetlust'] ?? 0,
        'Stemming': stats['stemming'] ?? 0,
        'Slaapritme': stats['slaapritme'] ?? 0,
      };
    });
  }

  Future<void> _saveAndGoToStats() async {
    await _userService.saveTodayHealthStats(_uid, _mystats);
    final user = await _userService.getUser(_uid);

    // ✅ context zetten via notifier
    ref
        .read(statsContextProvider.notifier)
        .setContext(targetUid: _uid, displayName: user?['name']);

    if (mounted) context.go('/stats');
  }

  Future<void> _goToStatsDirect() async {
    final user = await _userService.getUser(_uid);

    ref
        .read(statsContextProvider.notifier)
        .setContext(targetUid: _uid, displayName: user?['name']);

    if (mounted) context.go('/stats');
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
                const LineDotTitle(title: 'Health state'),
                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      onTap: _saveAndGoToStats,
                      child: Container(
                        width: 118,
                        height: 35,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFF04454B),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(0xFF008F9D),
                            width: 2,
                          ),
                        ),
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
                onTap: _goToStatsDirect,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        right: size.width * 0.04,
                        top: size.height * 0.01,
                      ),
                      child: Assets.images.arrowHealthCheck.image(
                        width: arrowW,
                      ),
                    ),
                    Transform.translate(
                      offset: Offset(0, -size.height * 0.025),
                      child: Assets.images.graphUp.image(width: graphW),
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
