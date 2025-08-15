import 'package:flutter/material.dart';
import 'emoji_widget.dart';

class EmojiButton extends StatelessWidget {
  final String emoji;
  final VoidCallback? onPressed;

  const EmojiButton({
    Key? key,
    required this.emoji,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 2),
        ),
        child: EmojiWidget(emoji: emoji, size: 48),
      ),
    );
  }
}
