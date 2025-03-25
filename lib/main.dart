import 'dart:io';
import 'package:flutter/material.dart';
import 'app.dart';
import 'core/network/http_overrides.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const App());
}
