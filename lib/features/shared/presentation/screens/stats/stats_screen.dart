import 'package:care_link/core/riverpod_providers/stats_context_provider.dart';
import 'package:care_link/features/shared/presentation/widgets/sections/graph_section.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/line_dot_title.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/week_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsContext = ref.watch(statsContextProvider);

    // ✅ alleen eerste naam pakken
    final String? firstName =
        statsContext?.displayName != null &&
                statsContext!.displayName!.trim().isNotEmpty
            ? statsContext.displayName!.trim().split(' ').first
            : null;

    final String title = firstName != null ? "$firstName's grafiek" : 'Grafiek';

    final String? targetUid = statsContext?.targetUid;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LineDotTitle(title: title),
                Transform.translate(
                  offset: const Offset(0, -5),
                  child: const WeekTile(),
                ),
              ],
            ),

            const SizedBox(height: 10),

            if (targetUid == null)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Selecteer een patiënt of vul eerst gegevens in om statistieken te zien.',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Color(0xFF005159),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: GraphSection(
                  key: ValueKey(targetUid),
                  userId: targetUid ?? '__empty__',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
