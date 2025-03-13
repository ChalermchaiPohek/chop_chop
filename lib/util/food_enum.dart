import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';

enum Food {
  red,
  green,
  blue,
  yellow,
  pink,
  purple,
  orange;

  static List<Food> get pairFoodPromotion => [
    Food.orange,
    Food.pink,
    Food.green,
  ];

  Decimal get price {
    switch (this) {
      case Food.red:
      case Food.yellow:
        return Decimal.fromInt(50);
      case Food.green:
        return Decimal.fromInt(40);
      case Food.blue:
        return Decimal.fromInt(30);
      case Food.pink:
        return Decimal.fromInt(80);
      case Food.purple:
        return Decimal.fromInt(90);
      case Food.orange:
        return Decimal.fromInt(120);
    }
  }
  
  String get name {
    switch (this) {
      case Food.red:
        return "Red set";
      case Food.green:
        return "Green set";
      case Food.blue:
        return "Blue set";
      case Food.yellow:
        return "Yellow set";
      case Food.pink:
        return "Pink set";
      case Food.purple:
        return "Purple set";
      case Food.orange:
        return "Orange set";
    }
  }

  Color get colour {
    switch (this) {
      case Food.red:
        return Colors.red;
      case Food.green:
        return Colors.green;
      case Food.blue:
        return Colors.blue;
      case Food.yellow:
        return Colors.yellow;
      case Food.pink:
        return Colors.pink;
      case Food.purple:
        return Colors.purple;
      case Food.orange:
        return Colors.orange;
    }
  }
}