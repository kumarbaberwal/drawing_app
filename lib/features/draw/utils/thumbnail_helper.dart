import 'dart:typed_data';
import 'dart:ui';

import 'package:drawing_app/features/draw/models/stroke.dart';
import 'package:flutter/material.dart';

Future<Uint8List> generateThumbnail(
    List<Stroke> strokes, double width, double height) async {
  final recoder = PictureRecorder();
  final canvas = Canvas(recoder, Rect.fromLTWH(0, 0, width, height));
  final paint = Paint()
    ..color = Colors.white
    ..style = PaintingStyle.fill;

  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), paint);

  for (final stroke in strokes) {
    final strokePaint = Paint()
      ..color = stroke.strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke.brushSize;

    final point = stroke.offsetPoints;

    for (int i = 0; i < point.length - 1; i++) {
      if (point[i] != Offset.zero && point[i + 1] != Offset.zero) {
        canvas.drawLine(point[i], point[i + 1], strokePaint);
      }
    }
  }

  final picture = recoder.endRecording();
  final image = await picture.toImage(width.toInt(), height.toInt());
  final byteData = await image.toByteData(format: ImageByteFormat.png);
  return byteData!.buffer.asUint8List();
}
