import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class GraphSection extends StatefulWidget {
  const GraphSection({super.key});

  @override
  State<GraphSection> createState() => _GraphSectionState();
}

class _GraphSectionState extends State<GraphSection> {
  Color? _activeColor;

  void _toggleGlow(Color color) {
    setState(() {
      _activeColor = _activeColor == color ? null : color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final scale = width / 400;

        final eetlust = const Color(0xFF00AEEF);
        final energie = const Color(0xFF00B050);
        final stemming = const Color(0xFFFF3EA5);
        final slaapritme = const Color(0xFFFFA500);

        final lineColors = [eetlust, energie, stemming, slaapritme];
        final lineValues = [
          [5, 3, 3, 3, 2, 1, 1],
          [3, 6, 6, 5, 4, 3, 3],
          [1, 4, 5, 5, 5, 6, 7],
          [2, 7, 8, 8, 9, 9, 10],
        ];

        return Column(
          children: [
            SizedBox(
              height: 340 * scale,
              width: width * 0.9,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: width * 0.08,
                    right: width * 0.05,
                    top: 10 * scale,
                    bottom: 25 * scale,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15 * scale),
                        border: Border.all(
                          color: const Color(0xFF0C3337),
                          width: 3,
                        ),
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: LineChart(
                        LineChartData(
                          minY: 0.5,
                          maxY: 10.3,
                          minX: 0,
                          maxX: 6,
                          gridData: FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          clipData: const FlClipData.all(),
                          titlesData: FlTitlesData(show: false),
                          lineTouchData: LineTouchData(
                            enabled: true,
                            handleBuiltInTouches: false,
                            getTouchedSpotIndicator: (barData, indexes) => [],
                            touchCallback: (event, response) {
                              if (event is! FlTapUpEvent) return;

                              final tap = event.localPosition;
                              double bestDist = double.infinity;
                              int? bestLine;

                              for (int l = 0; l < lineValues.length; l++) {
                                final values = lineValues[l];
                                for (int i = 0; i < values.length; i++) {
                                  final p = Offset(
                                    i.toDouble(),
                                    values[i].toDouble(),
                                  );
                                  final dx = tap.dx / 40 - p.dx;
                                  final dy = tap.dy / 30 - (10 - p.dy);
                                  final dist = sqrt(dx * dx + dy * dy);
                                  if (dist < bestDist) {
                                    bestDist = dist;
                                    bestLine = l;
                                  }
                                }
                              }

                              if (bestLine != null) {
                                final color = lineColors[bestLine];
                                _toggleGlow(color);
                              }
                            },
                          ),
                          lineBarsData: [
                            for (int i = 0; i < lineColors.length; i++)
                              _buildLine(
                                lineColors[i],
                                lineValues[i].map((e) => e.toDouble()).toList(),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    top: 16,
                    bottom: 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children:
                          List.generate(
                            11,
                            (i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1),
                              child: Text(
                                i.toString(),
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 18,
                                  color: Color(0xFF0C3337),
                                ),
                              ),
                            ),
                          ).reversed.toList(),
                    ),
                  ),

                  Positioned(
                    left: width * 0.08,
                    right: width * 0.05,
                    bottom: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
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

            SizedBox(height: 15 * scale),

            Center(
              child: Padding(
                padding: EdgeInsets.only(left: 12 * scale),
                child: SizedBox(
                  width: width * 0.65,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LegendItem(
                            label: 'Eetlust',
                            color: eetlust,
                            isActive: _activeColor == eetlust,
                            onTap: () => _toggleGlow(eetlust),
                          ),
                          const SizedBox(width: 35),
                          _LegendItem(
                            label: 'Stemming',
                            color: stemming,
                            isActive: _activeColor == stemming,
                            onTap: () => _toggleGlow(stemming),
                          ),
                        ],
                      ),
                      SizedBox(height: 8 * scale),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _LegendItem(
                            label: 'Energie',
                            color: energie,
                            isActive: _activeColor == energie,
                            onTap: () => _toggleGlow(energie),
                          ),
                          const SizedBox(width: 35),
                          _LegendItem(
                            label: 'Slaapritme',
                            color: slaapritme,
                            isActive: _activeColor == slaapritme,
                            onTap: () => _toggleGlow(slaapritme),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  LineChartBarData _buildLine(Color color, List<double> values) {
    final darker =
        HSLColor.fromColor(color)
            .withLightness(
              (HSLColor.fromColor(color).lightness * 0.6).clamp(0.0, 1.0),
            )
            .toColor();

    final bool isActive = _activeColor == color;

    return LineChartBarData(
      isCurved: false,
      color: isActive ? color : color.withOpacity(0.8),
      barWidth: isActive ? 4.5 : 2.3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (spot, percent, barData, i) => FlDotCirclePainter(
              radius: isActive ? 5 : 3.5,
              color: isActive ? color : darker,
              strokeColor: isActive ? color.withOpacity(0.6) : Colors.white,
              strokeWidth: 1,
            ),
      ),
      spots: List.generate(
        values.length,
        (i) => FlSpot(i.toDouble(), values[i]),
      ),
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
        fontSize: 18,
        color: Color(0xFF0C3337),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _LegendItem({
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 15,
            height: 15,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow:
                  isActive
                      ? [
                        BoxShadow(
                          color: color.withOpacity(0.6),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ]
                      : [],
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isActive ? color : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
