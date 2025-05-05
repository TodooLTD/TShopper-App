import 'package:flutter/material.dart';

Color getGradientColor(String color) {
  switch (color) {
    case 'blue':
      return Colors.blue.shade100;
    case 'green':
      return Colors.green.shade100;
    case 'teal':
      return Colors.teal.shade100;
    case 'tealAccent':
      return Colors.tealAccent.shade100;
    case 'beige':
      return Colors.orange.shade400;
    case 'orange':
      return Colors.orange.shade100;
    case 'yellow':
      return Colors.yellow.shade100;
    case 'red':
      return Colors.red.shade100;
    case 'pink':
      return Colors.pink.shade100;
    case 'lightPink':
      return Colors.pink.shade400;
    case 'brown':
      return Colors.brown.shade100;
    case 'black':
      return Colors.grey.shade400;
    default:
      return Colors.grey;
  }
}
