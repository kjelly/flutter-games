import 'package:flutter/material.dart';

class EmojiWidget extends StatelessWidget {
  final String emoji;
  final double size;

  const EmojiWidget({
    Key? key,
    required this.emoji,
    this.size = 50.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      emoji,
      style: TextStyle(
        fontSize: size,
      ),
    );
  }
}
