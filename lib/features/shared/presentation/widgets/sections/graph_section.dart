import 'package:care_link/core/firestore/services/user_service.dart';
import 'package:care_link/features/shared/presentation/widgets/tiles/legenda_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GraphSection extends StatefulWidget {
  final String userId;

  const GraphSection({super.key, required this.userId});

  @override
  State<GraphSection> createState() => _GraphSectionState();
}

class _GraphSectionState extends State<GraphSection> {
  Color? _activeColor;
  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _activeColor = const Color(0xFF00AEEF);
  }

  // ✅ ENIGE TOEVOEGING – verder NIETS aangepast
  @override
  void didUpdateWidget(covariant GraphSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userId != widget.userId) {
      // reset alleen interne state zodat de nieuwe userId echt pakt
      setState(() {
        _activeColor = const Color(0xFF00AEEF);
      });
    }
  }

  void _toggleGlow(Color color) {
    setState(() {
      _activeColor = _activeColor == color ? null : color;
    });
  }

  DateTime _startOfWeekMonday(DateTime d) {
    final date = DateTime(d.year, d.month, d.day);
    final diff = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: diff));
  }

  int _dayIndexFromMonday(DateTime day) {
    return day.weekday - DateTime.monday; // ma=0 .. zo=6
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final scale = width / 450;

    double chartHeight;
    if (width < 400) {
      chartHeight = 310;
    } else if (width < 450) {
      chartHeight = 360;
    } else {
      chartHeight = 420;
    }

    final eetlustColor = const Color(0xFF00AEEF);
    final energieColor = const Color(0xFF00B050);
    final stemmingColor = const Color(0xFFFF3EA5);
    final slaapritmeColor = const Color(0xFFFFA500);

    final lineColors = [
      eetlustColor,
      energieColor,
      stemmingColor,
      slaapritmeColor,
    ];

    final weekStart = _startOfWeekMonday(DateTime.now());

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _userService.watchWeekHealthStats(widget.userId, weekStart),
      builder: (context, snapshot) {
        print('--- [GraphSection] snapshot ---');
        print('hasData = ${snapshot.hasData}');
        print('hasError = ${snapshot.hasError}');
        print('error = ${snapshot.error}');
        print('connectionState = ${snapshot.connectionState}');
        print('docs length = ${snapshot.data?.docs.length}');

        final Map<int, double> eetlust = {};
        final Map<int, double> energie = {};
        final Map<int, double> stemming = {};
        final Map<int, double> slaapritme = {};

        if (snapshot.hasData) {
          for (final doc in snapshot.data!.docs) {
            final data = doc.data();
            final ts = data['date'];
            if (ts is! Timestamp) continue;

            final day = ts.toDate();
            final idx = _dayIndexFromMonday(day);
            if (idx < 0 || idx > 6) continue;

            eetlust[idx] = (data['eetlust'] ?? 0).toDouble();
            energie[idx] = (data['energie'] ?? 0).toDouble();
            stemming[idx] = (data['stemming'] ?? 0).toDouble();
            slaapritme[idx] = (data['slaapritme'] ?? 0).toDouble();
          }
        }

        List<FlSpot> _spotsFromMap(Map<int, double> values) {
          final entries =
              values.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

          return entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();
        }

        LineChartBarData _buildLine(Color color, Map<int, double> values) {
          final darker =
              HSLColor.fromColor(color)
                  .withLightness(
                    (HSLColor.fromColor(color).lightness * 0.6).clamp(0.0, 1.0),
                  )
                  .toColor();

          final isActive = _activeColor == color;

          return LineChartBarData(
            isCurved: false,
            color: isActive ? color : color.withOpacity(0.8),
            barWidth: isActive ? 4 : 2,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(show: false),
            dotData: FlDotData(
              show: true,
              getDotPainter:
                  (spot, percent, barData, i) => FlDotCirclePainter(
                    radius: isActive ? 4.8 : 3.2,
                    color: isActive ? color : darker,
                    strokeColor:
                        isActive ? color.withOpacity(0.6) : Colors.white,
                    strokeWidth: 1,
                  ),
            ),
            spots: _spotsFromMap(values),
          );
        }

        return Column(
          children: [
            SizedBox(
              height: chartHeight,
              width: width * 0.88,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: width * 0.1,
                    right: width * 0.05,
                    top: 4 * scale,
                    bottom: 40 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14 * scale),
                        border: Border.all(
                          color: const Color(0xFF0C3337),
                          width: 2.5,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: LineChart(
                        LineChartData(
                          minY: 0,
                          maxY: 10,
                          minX: 0,
                          maxX: 6,
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: true,
                            horizontalInterval: 1,
                            verticalInterval: 1,
                            getDrawingHorizontalLine:
                                (_) => FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                ),
                            getDrawingVerticalLine:
                                (_) => FlLine(
                                  color: Colors.grey.withOpacity(0.3),
                                  strokeWidth: 1,
                                ),
                          ),
                          borderData: FlBorderData(show: false),
                          clipData: const FlClipData.all(),
                          titlesData: FlTitlesData(show: false),
                          lineBarsData: [
                            _buildLine(eetlustColor, eetlust),
                            _buildLine(energieColor, energie),
                            _buildLine(stemmingColor, stemming),
                            _buildLine(slaapritmeColor, slaapritme),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 33 * scale,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        11,
                        (i) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            (10 - i).toString(),
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 17,
                              color: Color(0xFF0C3337),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: width * 0.1,
                    right: width * 0.05,
                    bottom: 5,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DayLabel('Ma'),
                        _DayLabel('Di'),
                        _DayLabel('Wo'),
                        _DayLabel('Do'),
                        _DayLabel('Vr'),
                        _DayLabel('Za'),
                        _DayLabel('Zo'),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 2),

            Container(
              margin: const EdgeInsets.only(left: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LegendaTile(
                        label: 'Eetlust',
                        color: eetlustColor,
                        isActive: _activeColor == eetlustColor,
                        onTap: () => _toggleGlow(eetlustColor),
                      ),
                      const SizedBox(width: 20),
                      LegendaTile(
                        label: 'Energie',
                        color: energieColor,
                        isActive: _activeColor == energieColor,
                        onTap: () => _toggleGlow(energieColor),
                      ),
                    ],
                  ),
                  SizedBox(height: 10 * scale),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LegendaTile(
                        label: 'Stemming',
                        color: stemmingColor,
                        isActive: _activeColor == stemmingColor,
                        onTap: () => _toggleGlow(stemmingColor),
                      ),
                      const SizedBox(width: 20),
                      LegendaTile(
                        label: 'Slaapritme',
                        color: slaapritmeColor,
                        isActive: _activeColor == slaapritmeColor,
                        onTap: () => _toggleGlow(slaapritmeColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _DayLabel extends StatelessWidget {
  final String text;
  const _DayLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: Color(0xFF0C3337),
      ),
    );
  }
}
