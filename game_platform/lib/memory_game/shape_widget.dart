import 'package:flutter/material.dart';
import 'memory_game_logic.dart';
import 'shape_icons.dart';

class ShapeWidget extends StatelessWidget {
  final GameShape shape;
  final double size;

  const ShapeWidget({
    Key? key,
    required this.shape,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      shapeIcons[shape],
      size: size,
      color: Colors.blue, // Default color, can be customized later
    );
  }
}
