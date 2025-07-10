import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../model/audio_model.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final Uuid _uuid = const Uuid();

  // 获取音频文件目录
  Future<Directory> getAudioDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${appDir.path}/audio');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    return audioDir;
  }

  // 获取所有音频文件
  Future<List<AudioModel>> getAllAudioFiles() async {
    try {
      final audioDir = await getAudioDirectory();
      final files = await audioDir.list().toList();
      final audioFiles = <AudioModel>[];

      for (final file in files) {
        if (file is File && _isAudioFile(file.path)) {
          final stat = await file.stat();
          final audioModel = AudioModel(
            id: _uuid.v4(),
            name: file.path.split('/').last,
            path: file.path,
            size: stat.size.toDouble(),
            createdAt: stat.changed,
            modifiedAt: stat.modified,
          );
          audioFiles.add(audioModel);
        }
      }

      return audioFiles;
    } catch (e) {
      throw Exception('Failed to get audio files: $e');
    }
  }

  // 检查是否为音频文件
  bool _isAudioFile(String path) {
    final extension = path.split('.').last.toLowerCase();
    return ['mp3', 'wav', 'm4a', 'aac', 'flac', 'ogg'].contains(extension);
  }

  // 复制音频文件到应用目录
  Future<AudioModel> copyAudioFile(String sourcePath) async {
    try {
      final sourceFile = File(sourcePath);
      if (!await sourceFile.exists()) {
        throw Exception('Source file does not exist: $sourcePath');
      }

      final audioDir = await getAudioDirectory();
      final fileName = sourcePath.split('/').last;
      final destPath = '${audioDir.path}/$fileName';
      final destFile = File(destPath);

      // 如果目标文件已存在，添加时间戳
      if (await destFile.exists()) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final nameWithoutExt = fileName.substring(0, fileName.lastIndexOf('.'));
        final extension = fileName.substring(fileName.lastIndexOf('.'));
        final newFileName = '${nameWithoutExt}_$timestamp$extension';
        final newDestPath = '${audioDir.path}/$newFileName';
        await sourceFile.copy(newDestPath);
        
        final stat = await File(newDestPath).stat();
        return AudioModel(
          id: _uuid.v4(),
          name: newFileName,
          path: newDestPath,
          size: stat.size.toDouble(),
          createdAt: stat.changed,
          modifiedAt: stat.modified,
        );
      } else {
        await sourceFile.copy(destPath);
        final stat = await destFile.stat();
        return AudioModel(
          id: _uuid.v4(),
          name: fileName,
          path: destPath,
          size: stat.size.toDouble(),
          createdAt: stat.changed,
          modifiedAt: stat.modified,
        );
      }
    } catch (e) {
      throw Exception('Failed to copy audio file: $e');
    }
  }

  // 删除音频文件
  Future<void> deleteAudioFile(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete audio file: $e');
    }
  }

  // 获取音频文件信息
  Future<Map<String, dynamic>> getAudioFileInfo(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file does not exist: $filePath');
      }

      final stat = await file.stat();
      return {
        'size': stat.size,
        'createdAt': stat.changed,
        'modifiedAt': stat.modified,
        'path': filePath,
        'name': filePath.split('/').last,
      };
    } catch (e) {
      throw Exception('Failed to get audio file info: $e');
    }
  }
} 