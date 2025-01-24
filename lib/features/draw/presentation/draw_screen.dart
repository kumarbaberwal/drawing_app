import 'package:drawing_app/features/draw/models/stroke.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DrawScreen extends StatefulWidget {
  const DrawScreen({super.key});

  @override
  State<DrawScreen> createState() => _DrawScreenState();
}

class _DrawScreenState extends State<DrawScreen> {
  final List<Stroke> _strokes = [];
  List<Stroke> _redoStrokes = [];
  List<Offset> _currentPoints = [];
  Color _selectedColor = Colors.black;
  double _brushSize = 4.0;
  late Box<List<Stroke>> _drawingBox;

  @override
  void initState() {
    _initializeHive();
    super.initState();
  }

  _initializeHive() {
    _drawingBox = Hive.box<List<Stroke>>('drawings');
  }

  // Future<void> _saveDrawing(){}

  void _showDialog() {}

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Draw Your Dream"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
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
            ),
          ),
          _buildToolBar(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        child: Icon(Icons.save),
      ),
    );
  }

  Widget _buildToolBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: _strokes.isNotEmpty
                ? () {
                    setState(() {
                      _redoStrokes.add(_strokes.removeLast());
                    });
                  }
                : null,
            icon: Icon(Icons.undo),
          ),
          IconButton(
            onPressed: _redoStrokes.isNotEmpty
                ? () {
                    setState(() {
                      _strokes.add(_redoStrokes.removeLast());
                    });
                  }
                : null,
            icon: Icon(Icons.redo),
          ),

          // brush size drop down
          DropdownButton(
            value: _brushSize,
            items: [
              DropdownMenuItem(
                value: 2.0,
                child: Text("small"),
              ),
              DropdownMenuItem(
                value: 4.0,
                child: Text("medium"),
              ),
              DropdownMenuItem(
                value: 6.0,
                child: Text("large"),
              ),
              DropdownMenuItem(
                value: 8.0,
                child: Text("larger"),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _brushSize = value!;
              });
            },
          ),

          // color picker
          Row(
            children: [
              _buildColorButton(Colors.black),
              _buildColorButton(Colors.red),
              _buildColorButton(Colors.blue),
              _buildColorButton(Colors.green),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(
          () {
            _selectedColor = color;
          },
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _selectedColor == color ? Colors.grey : Colors.transparent,
            width: 2,
          ),
        ),
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
    // draw complete stroke
    for (final stroke in strokes) {
      final paint = Paint()
        ..color = stroke.strokeColor
        ..strokeCap = StrokeCap.round
        ..strokeWidth = stroke.brushSize;

      final points = stroke.offsetPoints;

      for (int i = 0; i < stroke.points.length - 1; i++) {
        if (points[i] != Offset.zero && points[i + 1] != Offset.zero) {
          canvas.drawLine(points[i], points[i + 1], paint);
        }
      }
    }

    // draw the current active stroke
    final paint = Paint()
      ..color = selectedColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = currentBrushSize;
    for (int i = 0; i < currentPoints.length - 1; i++) {
      if (currentPoints[i] != Offset.zero &&
          currentPoints[i + 1] != Offset.zero) {
        canvas.drawLine(currentPoints[i], currentPoints[i + 1], paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
