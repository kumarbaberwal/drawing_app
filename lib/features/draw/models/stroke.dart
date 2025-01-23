import 'package:flutter/material.dart';

class Stroke {
  final List<Offset> points;
  final Color color;
  final double brushSize;

  Stroke({
    required this.points,
    required this.color,
    required this.brushSize,
  });
}
