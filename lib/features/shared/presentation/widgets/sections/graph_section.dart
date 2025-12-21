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

  @override
  void didUpdateWidget(covariant GraphSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.userId != widget.userId) {
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
    return day.weekday - DateTime.monday;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final double graphFontSize = screenWidth > 380 ? 17 : 15;
    final double chartWidth = screenWidth > 380 ? 320 : 290;
    final double chartHeight = screenWidth > 380 ? 300 : 270;

    final eetlustColor = const Color(0xFF00AEEF);
    final energieColor = const Color(0xFF00B050);
    final stemmingColor = const Color(0xFFFF3EA5);
    final slaapritmeColor = const Color(0xFFFFA500);

    final weekStart = _startOfWeekMonday(DateTime.now());

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: _userService.watchWeekHealthStats(widget.userId, weekStart),
      builder: (context, snapshot) {
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
          if (values.isEmpty) return [];
          final todayIndex = _dayIndexFromMonday(DateTime.now());
          final firstFilledDay = values.keys.reduce(min);

          double? lastValue;
          final spots = <FlSpot>[];

          for (int day = firstFilledDay; day <= todayIndex; day++) {
            if (values.containsKey(day)) {
              lastValue = values[day];
            }
            if (lastValue != null) {
              spots.add(FlSpot(day.toDouble(), lastValue));
            }
          }
          return spots;
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
              width: chartWidth,
              child: Stack(
                children: [
                  Positioned(
                    left: 36,
                    right: 18,
                    top: 0,
                    bottom: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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

                          lineTouchData: LineTouchData(enabled: false),

                          gridData: FlGridData(
                            show: true,
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
                            if (_activeColor != eetlustColor)
                              _buildLine(eetlustColor, eetlust),
                            if (_activeColor != energieColor)
                              _buildLine(energieColor, energie),
                            if (_activeColor != stemmingColor)
                              _buildLine(stemmingColor, stemming),
                            if (_activeColor != slaapritmeColor)
                              _buildLine(slaapritmeColor, slaapritme),

                            if (_activeColor == eetlustColor)
                              _buildLine(eetlustColor, eetlust),
                            if (_activeColor == energieColor)
                              _buildLine(energieColor, energie),
                            if (_activeColor == stemmingColor)
                              _buildLine(stemmingColor, stemming),
                            if (_activeColor == slaapritmeColor)
                              _buildLine(slaapritmeColor, slaapritme),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 5,
                    top: 0,
                    bottom: 36,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        11,
                        (i) => Padding(
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            (10 - i).toString(),
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: graphFontSize,
                              color: const Color(0xFF0C3337),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 36,
                    right: 18,
                    bottom: 12,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _DayLabel('Ma', graphFontSize),
                        _DayLabel('Di', graphFontSize),
                        _DayLabel('Wo', graphFontSize),
                        _DayLabel('Do', graphFontSize),
                        _DayLabel('Vr', graphFontSize),
                        _DayLabel('Za', graphFontSize),
                        _DayLabel('Zo', graphFontSize),
                      ],
                    ),
                  ),
                ],
              ),
            ),

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
                  const SizedBox(height: 7),
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
  final double fontSize;

  const _DayLabel(this.text, this.fontSize);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: fontSize,
        color: const Color(0xFF0C3337),
      ),
    );
  }
}
