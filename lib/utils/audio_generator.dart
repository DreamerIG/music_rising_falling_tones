import 'dart:io';
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:path_provider/path_provider.dart';

class AudioGenerator {
  static const int sampleRate = 44100;
  static const int channels = 1;
  static const int bitsPerSample = 16;

  /// 生成一个简单的正弦波测试音频文件
  static Future<String> generateTestAudio({
    double frequency = 440.0, // A4
    double duration = 5.0, // 5秒
    double amplitude = 0.5,
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/audio');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    final filePath = '${audioDir.path}/test_tone_${frequency.toInt()}hz.wav';
    final file = File(filePath);
    
    // 生成音频数据
    final samples = (sampleRate * duration).toInt();
    final audioData = Float32List(samples);
    
    for (int i = 0; i < samples; i++) {
      final time = i / sampleRate;
      audioData[i] = amplitude * math.sin(2 * math.pi * frequency * time);
    }
    
    // 创建WAV文件
    await _writeWavFile(file, audioData, sampleRate, channels, bitsPerSample);
    
    return filePath;
  }
  
  /// 生成一个简单的节拍器音频文件
  static Future<String> generateMetronomeAudio({
    int bpm = 120,
    double duration = 60.0, // 1分钟
  }) async {
    final directory = await getApplicationDocumentsDirectory();
    final audioDir = Directory('${directory.path}/audio');
    
    if (!await audioDir.exists()) {
      await audioDir.create(recursive: true);
    }
    
    final filePath = '${audioDir.path}/metronome_${bpm}bpm.wav';
    final file = File(filePath);
    
    // 计算节拍间隔
    final beatInterval = 60.0 / bpm; // 每拍的秒数
    final samples = (sampleRate * duration).toInt();
    final audioData = Float32List(samples);
    
    // 生成节拍声音
    for (int i = 0; i < samples; i++) {
      final time = i / sampleRate;
      final beatTime = time % beatInterval;
      
      // 在每拍开始时产生一个短的哔声
      if (beatTime < 0.1) {
        final frequency = 1000.0; // 1kHz
        final amplitude = 0.5 * math.exp(-beatTime * 20); // 衰减
        audioData[i] = amplitude * math.sin(2 * math.pi * frequency * time);
      } else {
        audioData[i] = 0.0;
      }
    }
    
    // 创建WAV文件
    await _writeWavFile(file, audioData, sampleRate, channels, bitsPerSample);
    
    return filePath;
  }
  
  /// 写入WAV文件
  static Future<void> _writeWavFile(
    File file,
    Float32List audioData,
    int sampleRate,
    int channels,
    int bitsPerSample,
  ) async {
    final bytesPerSample = bitsPerSample ~/ 8;
    final blockAlign = channels * bytesPerSample;
    final byteRate = sampleRate * blockAlign;
    final dataSize = audioData.length * bytesPerSample;
    final chunkSize = 36 + dataSize;
    
    final buffer = BytesBuilder();
    
    // WAV文件头
    buffer.add('RIFF'.codeUnits);
    buffer.add(_int32ToBytes(chunkSize));
    buffer.add('WAVE'.codeUnits);
    
    // fmt chunk
    buffer.add('fmt '.codeUnits);
    buffer.add(_int32ToBytes(16)); // PCM格式的chunk大小
    buffer.add(_int16ToBytes(1)); // PCM格式
    buffer.add(_int16ToBytes(channels));
    buffer.add(_int32ToBytes(sampleRate));
    buffer.add(_int32ToBytes(byteRate));
    buffer.add(_int16ToBytes(blockAlign));
    buffer.add(_int16ToBytes(bitsPerSample));
    
    // data chunk
    buffer.add('data'.codeUnits);
    buffer.add(_int32ToBytes(dataSize));
    
    // 音频数据
    for (final sample in audioData) {
      final intSample = (sample * 32767).round().clamp(-32768, 32767);
      buffer.add(_int16ToBytes(intSample));
    }
    
    await file.writeAsBytes(buffer.toBytes());
  }
  
  static List<int> _int16ToBytes(int value) {
    return [value & 0xFF, (value >> 8) & 0xFF];
  }
  
  static List<int> _int32ToBytes(int value) {
    return [
      value & 0xFF,
      (value >> 8) & 0xFF,
      (value >> 16) & 0xFF,
      (value >> 24) & 0xFF,
    ];
  }
} 