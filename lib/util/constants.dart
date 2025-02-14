import 'package:flutter/material.dart';

abstract class AppConst {
  static String baseUrl = "http://localhost:8080";
  static String baseUrlAndroidEmu = "http://10.0.2.2:8080";
}

abstract class UIConst {
  static SizedBox hDivider = const SizedBox(height: 16,);
  static SizedBox vDivider = const SizedBox(width: 16,);
}