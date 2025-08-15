import 'package:flutter/material.dart';
import 'memory_game_logic.dart';
import 'shape_widget.dart';

class ShapeButton extends StatelessWidget {
  final GameShape shape;
  final VoidCallback? onPressed;

  const ShapeButton({
    Key? key,
    required this.shape,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 72, // A larger size for touch targets
      icon: ShapeWidget(shape: shape, size: 72),
      onPressed: onPressed,
    );
  }
}
