import 'package:drawing_app/features/draw/models/stroke.dart';
import 'package:flutter/material.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Draw Your Dream"),
      ),
      body: Column(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                _currentPoints.add(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                _currentPoints.add(details.localPosition);
              });
            },
            onPanEnd: (details) {
              setState(() {
                _strokes.add(Stroke(
                  points: List.from(_currentPoints),
                  color: _selectedColor,
                  brushSize: _brushSize,
                ));
                _currentPoints = [];
                _redoStrokes = [];
              });
            },
            child: CustomPaint(
              painter: DrawPainter(
                strokes: _strokes,
                currentPoints: _currentPoints,
                selectedColor: _selectedColor,
                currentBrushSize: _brushSize,
              ),
              size: Size.infinite,
            ),
          )
        ],
      ),
    );
  }
}

class DrawPainter extends CustomPainter {
  final List<Stroke> strokes;
  final List<Offset> currentPoints;
  final Color selectedColor;
  final double currentBrushSize;

  DrawPainter({
    super.repaint,
    required this.strokes,
    required this.currentPoints,
    required this.selectedColor,
    required this.currentBrushSize,
  });
  @override
  void paint(Canvas canvas, Size size) {
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.color
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.brushSize;

        for (int i = 0, i < stroke.)
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw UnimplementedError();
  }
}
