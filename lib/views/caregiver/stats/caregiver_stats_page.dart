import 'package:care_link/widgets/tiles/line_dot_title.dart';
import 'package:care_link/widgets/tiles/week_tile.dart';
import 'package:flutter/material.dart';
import 'package:care_link/widgets/sections/graph_section.dart';

class CaregiverStatsPage extends StatelessWidget {
  const CaregiverStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: const [
                Padding(
                  padding: EdgeInsets.only(left: 0),
                  child: LineDotTitle(title: 'Status Check'),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0, bottom: 2),
                  child: WeekTile(),
                ),
              ],
            ),

            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: const GraphSection(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
