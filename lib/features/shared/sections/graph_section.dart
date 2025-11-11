import 'package:care_link/features/shared/presentation/widgets/tiles/legenda_tile.dart';
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

  @override
  void initState() {
    super.initState();
    _activeColor = const Color(0xFF00AEEF);
  }

  void _toggleGlow(Color color) {
    setState(() {
      _activeColor = _activeColor == color ? null : color;
    });
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

    final eetlust = const Color(0xFF00AEEF);
    final energie = const Color(0xFF00B050);
    final stemming = const Color(0xFFFF3EA5);
    final slaapritme = const Color(0xFFFFA500);

    final lineColors = [eetlust, energie, stemming, slaapritme];
    final List<List<double>> lineValues = [
      [5, 3, 3, 3, 2, 1, 0],
      [3, 6, 6, 5, 4, 3, 3],
      [1, 4, 5, 5, 5, 6, 7],
      [2, 7, 8, 8, 9, 9, 10],
    ];

    return Column(
      children: [
        SizedBox(
          height: chartHeight,
          width: width * 0.88,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              //Graph
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
                            (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                        getDrawingVerticalLine:
                            (value) => FlLine(
                              color: Colors.grey.withOpacity(0.3),
                              strokeWidth: 1,
                            ),
                      ),
                      borderData: FlBorderData(show: false),
                      clipData: const FlClipData.all(),
                      titlesData: FlTitlesData(show: false),

                      // Tab logic
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
                          _buildLine(lineColors[i], lineValues[i]),
                      ],
                    ),
                  ),
                ),
              ),

              // numbers
              Positioned(
                left: 0,
                top: 0,
                bottom: 33 * scale,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
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
                    );
                  },
                ),
              ),

              // days
              Positioned(
                left: width * 0.1,
                right: width * 0.05,
                bottom: 5,
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

        const SizedBox(height: 2),
        //legenda
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LegendaTile(
                      label: 'Eetlust',
                      color: eetlust,
                      isActive: _activeColor == eetlust,
                      onTap: () => _toggleGlow(eetlust),
                    ),
                    const SizedBox(width: 20),
                    LegendaTile(
                      label: 'Energie',
                      color: energie,
                      isActive: _activeColor == energie,
                      onTap: () => _toggleGlow(energie),
                    ),
                  ],
                ),
                SizedBox(height: 10 * scale),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LegendaTile(
                      label: 'Stemming',
                      color: stemming,
                      isActive: _activeColor == stemming,
                      onTap: () => _toggleGlow(stemming),
                    ),
                    const SizedBox(width: 20),
                    LegendaTile(
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
      ],
    );
  }

  //line in graph
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
      barWidth: isActive ? 4 : 2,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: false),
      dotData: FlDotData(
        show: true,
        getDotPainter:
            (spot, percent, barData, i) => FlDotCirclePainter(
              radius: isActive ? 4.8 : 3.2,
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
        fontSize: 16,
        color: Color(0xFF0C3337),
      ),
    );
  }
}
