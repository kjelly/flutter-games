import 'package:flutter/material.dart';
import 'memory_game_logic.dart';

// This file maps our abstract GameShape enum to actual visual icons.
// This makes it easy to change the icons later without touching the game logic or UI code.

const Map<GameShape, IconData> shapeIcons = {
  GameShape.circle: Icons.circle_outlined,
  GameShape.triangle: Icons.change_history, // Placeholder, this is a triangle
  GameShape.square: Icons.square_outlined,
  GameShape.club: Icons.spa, // Placeholder, this looks a bit like a club
  GameShape.heart: Icons.favorite_border,
};
