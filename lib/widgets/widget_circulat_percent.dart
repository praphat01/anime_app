import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WidgetCirculatPercentIndicator extends StatelessWidget {
  const WidgetCirculatPercentIndicator({
    Key? key,
    required this.percentNumber,
  }) : super(key: key);

  final double percentNumber;

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 60.0,
      lineWidth: 13.0,
      animation: true,
      percent: percentNumber / 100,
      center: Text(
        percentNumber.toString(),
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
      ),
      footer: const Text(
        "Downloading...",
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 17.0, color: Colors.white),
      ),
      circularStrokeCap: CircularStrokeCap.round,
      progressColor: Colors.purple,
    );
  }
}
