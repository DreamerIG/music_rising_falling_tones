import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'app.dart';

void main() {
  // 初始化日志
  Logger.level = Level.debug;
  
  runApp(const MusicApp());
}
