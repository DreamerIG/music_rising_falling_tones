import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

final Logger _logger = Logger();

class AudioController extends GetxController {
  static AudioController get to => Get.find();
  
  // 音频播放器
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // 音频状态
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  final RxDouble pitch = 0.0.obs;
  final RxDouble speed = 1.0.obs;
  
  // 当前音频文件
  final RxString currentAudioPath = ''.obs;
  final RxString currentAudioName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i("AudioController onInit");
    _setupAudioPlayer();
  }
  
  @override
  void onReady() {
    super.onReady();
    _logger.i("AudioController onReady");
  }
  
  @override
  void onClose() {
    _logger.i("AudioController onClose");
    _audioPlayer.dispose();
    super.onClose();
  }
  
  // 设置音频播放器
  void _setupAudioPlayer() {
    // 监听播放状态
    _audioPlayer.playingStream.listen((playing) {
      isPlaying.value = playing;
    });
    
    // 监听加载状态 - 使用playerStateStream来检测加载状态
    _audioPlayer.playerStateStream.listen((state) {
      isLoading.value = state.processingState == ProcessingState.loading;
    });
    
    // 监听播放位置
    _audioPlayer.positionStream.listen((pos) {
      position.value = pos;
    });
    
    // 监听音频时长
    _audioPlayer.durationStream.listen((dur) {
      if (dur != null) {
        duration.value = dur;
      }
    });
    
    // 监听播放错误
    _audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.idle) {
        _logger.e("Audio playback error: ${state.processingState}");
      }
    });
  }
  
  // 加载音频文件
  Future<void> loadAudio(String filePath) async {
    try {
      isLoading.value = true;
      
      final file = File(filePath);
      if (!await file.exists()) {
        throw Exception('Audio file not found: $filePath');
      }
      
      await _audioPlayer.setFilePath(filePath);
      currentAudioPath.value = filePath;
      currentAudioName.value = file.path.split('/').last;
      
      _logger.i("Audio loaded successfully: $filePath");
    } catch (e) {
      _logger.e("Failed to load audio: $e");
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }
  
  // 播放音频
  Future<void> play() async {
    try {
      await _audioPlayer.play();
      _logger.i("Audio started playing");
    } catch (e) {
      _logger.e("Failed to play audio: $e");
    }
  }
  
  // 暂停音频
  Future<void> pause() async {
    try {
      await _audioPlayer.pause();
      _logger.i("Audio paused");
    } catch (e) {
      _logger.e("Failed to pause audio: $e");
    }
  }
  
  // 停止音频
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      _logger.i("Audio stopped");
    } catch (e) {
      _logger.e("Failed to stop audio: $e");
    }
  }
  
  // 跳转到指定位置
  Future<void> seekTo(Duration position) async {
    try {
      await _audioPlayer.seek(position);
      _logger.i("Audio seeked to: $position");
    } catch (e) {
      _logger.e("Failed to seek audio: $e");
    }
  }
  
  // 设置音调
  Future<void> setPitch(double pitch) async {
    try {
      this.pitch.value = pitch;
      await _audioPlayer.setPitch(pitch);
      _logger.i("Pitch set to: $pitch");
    } catch (e) {
      _logger.e("Failed to set pitch: $e");
    }
  }
  
  // 设置播放速度
  Future<void> setSpeed(double speed) async {
    try {
      this.speed.value = speed;
      await _audioPlayer.setSpeed(speed);
      _logger.i("Speed set to: $speed");
    } catch (e) {
      _logger.e("Failed to set speed: $e");
    }
  }
  
  // 获取音频文件列表
  Future<List<File>> getAudioFiles() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/audio');
      
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
        return [];
      }
      
      final files = await audioDir.list().toList();
      final audioFiles = files.whereType<File>().where((file) {
        final extension = file.path.split('.').last.toLowerCase();
        return ['mp3', 'wav', 'm4a', 'aac'].contains(extension);
      }).toList();
      
      _logger.i("Found ${audioFiles.length} audio files");
      return audioFiles;
    } catch (e) {
      _logger.e("Failed to get audio files: $e");
      return [];
    }
  }
  
  // 获取当前播放进度百分比
  double get progress {
    if (duration.value.inMilliseconds == 0) return 0.0;
    return position.value.inMilliseconds / duration.value.inMilliseconds;
  }
} 