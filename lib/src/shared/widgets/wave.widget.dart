import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

Widget waveAnimation({
  required Config config,
  Color backgroundColor = Colors.transparent,
  required BuildContext context,
  required double height,
}) {
  return RotatedBox(
    quarterTurns: 2,
    child: Container(
      height: height,
      width: double.infinity,
      child: WaveWidget(
          config: config,
          size: const Size(double.infinity, double.infinity),
          waveAmplitude: 2
      ),
    ),
  );
}
