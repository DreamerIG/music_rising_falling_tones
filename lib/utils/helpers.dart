import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'constants.dart';

class AppHelpers {
  // 格式化文件大小
  static String formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }

  // 格式化时间
  static String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    
    if (duration.inHours > 0) {
      return '$hours:$minutes:$seconds';
    } else {
      return '$minutes:$seconds';
    }
  }

  // 检查文件是否为音频文件
  static bool isAudioFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return AppConstants.supportedAudioFormats.contains(extension);
  }

  // 获取文件扩展名
  static String getFileExtension(String path) {
    return path.split('.').last.toLowerCase();
  }

  // 获取文件名（不含扩展名）
  static String getFileNameWithoutExtension(String path) {
    final fileName = path.split('/').last;
    final lastDotIndex = fileName.lastIndexOf('.');
    if (lastDotIndex == -1) return fileName;
    return fileName.substring(0, lastDotIndex);
  }

  // 检查存储权限
  static Future<bool> checkStoragePermission() async {
    final status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }
    
    final result = await Permission.storage.request();
    return result.isGranted;
  }

  // 获取应用文档目录
  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  // 获取临时目录
  static Future<Directory> getTemporaryDirectory() async {
    return await getTemporaryDirectory();
  }

  // 创建目录（如果不存在）
  static Future<Directory> createDirectoryIfNotExists(String path) async {
    final directory = Directory(path);
    if (!await directory.exists()) {
      await directory.create(recursive: true);
    }
    return directory;
  }

  // 删除文件（如果存在）
  static Future<void> deleteFileIfExists(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  // 验证文件大小
  static bool isValidFileSize(int bytes) {
    final maxSizeInBytes = AppConstants.maxFileSize * 1024 * 1024;
    return bytes <= maxSizeInBytes;
  }

  // 生成唯一文件名
  static String generateUniqueFileName(String originalName) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final extension = getFileExtension(originalName);
    final nameWithoutExt = getFileNameWithoutExtension(originalName);
    return '${nameWithoutExt}_$timestamp.$extension';
  }

  // 清理临时文件
  static Future<void> cleanupTempFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final files = tempDir.listSync();
      
      for (final file in files) {
        if (file is File) {
          final stat = await file.stat();
          final age = DateTime.now().difference(stat.modified);
          
          // 删除超过1小时的临时文件
          if (age.inHours > 1) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      // 忽略清理错误
    }
  }
} 