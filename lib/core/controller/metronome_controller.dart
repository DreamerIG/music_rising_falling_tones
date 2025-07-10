import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:logger/logger.dart';

final Logger _logger = Logger();

class MetronomeController extends GetxController {
  static MetronomeController get to => Get.find();
  
  // 音频播放器
  final AudioPlayer _audioPlayer = AudioPlayer();
  
  // 播放状态
  final RxBool isPlaying = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<Duration> position = Duration.zero.obs;
  final Rx<Duration> duration = Duration.zero.obs;
  
  // 音频控制参数
  final RxDouble pitch = 0.0.obs; // 移调 (-12 到 +12)
  final RxDouble speed = 1.0.obs; // 变速 (0.5 到 1.5)
  final RxDouble volume = 1.0.obs; // 音量 (0.0 到 1.0)
  
  // 均衡器状态
  final RxBool isEqualizerEnabled = true.obs;
  final RxList<double> equalizerValues = List.filled(10, 0.0).obs;
  
  // 当前音频文件
  final RxString currentAudioPath = ''.obs;
  final RxString currentAudioName = ''.obs;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i("MetronomeController onInit");
    _setupAudioPlayer();
    _initializeEqualizer();
  }
  
  @override
  void onReady() {
    super.onReady();
    _logger.i("MetronomeController onReady");
  }
  
  @override
  void onClose() {
    _logger.i("MetronomeController onClose");
    _audioPlayer.dispose();
    super.onClose();
  }
  
  // 设置音频播放器
  void _setupAudioPlayer() {
    // 监听播放状态
    _audioPlayer.playingStream.listen((playing) {
      isPlaying.value = playing;
    });
    
    // 监听加载状态
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
  }
  
  // 初始化均衡器
  void _initializeEqualizer() {
    equalizerValues.assignAll(List.filled(10, 0.0));
  }
  
  // 加载音频文件
  Future<void> loadAudio(String filePath) async {
    try {
      isLoading.value = true;
      await _audioPlayer.setFilePath(filePath);
      currentAudioPath.value = filePath;
      currentAudioName.value = filePath.split('/').last;
      _logger.i("Audio loaded: $filePath");
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
      _logger.i("Audio playing");
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
  Future<void> setPitch(double value) async {
    try {
      pitch.value = value.clamp(-12.0, 12.0);
      await _audioPlayer.setPitch(pitch.value);
      _logger.i("Pitch set to: ${pitch.value}");
    } catch (e) {
      _logger.e("Failed to set pitch: $e");
    }
  }
  
  // 设置播放速度
  Future<void> setSpeed(double value) async {
    try {
      speed.value = value.clamp(0.5, 1.5);
      await _audioPlayer.setSpeed(speed.value);
      _logger.i("Speed set to: ${speed.value}");
    } catch (e) {
      _logger.e("Failed to set speed: $e");
    }
  }
  
  // 设置音量
  Future<void> setVolume(double value) async {
    try {
      volume.value = value.clamp(0.0, 1.0);
      await _audioPlayer.setVolume(volume.value);
      _logger.i("Volume set to: ${volume.value}");
    } catch (e) {
      _logger.e("Failed to set volume: $e");
    }
  }
  
  // 重置音调
  Future<void> resetPitch() async {
    await setPitch(0.0);
  }
  
  // 重置播放速度
  Future<void> resetSpeed() async {
    await setSpeed(1.0);
  }
  
  // 设置均衡器启用状态
  void toggleEqualizer() {
    isEqualizerEnabled.value = !isEqualizerEnabled.value;
    _logger.i("Equalizer ${isEqualizerEnabled.value ? 'enabled' : 'disabled'}");
  }
  
  // 设置均衡器频率值
  void setEqualizerValue(int index, double value) {
    if (index >= 0 && index < equalizerValues.length) {
      equalizerValues[index] = value.clamp(-12.0, 12.0);
      _logger.i("Equalizer band $index set to: ${equalizerValues[index]}");
    }
  }
  
  // 重置均衡器
  void resetEqualizer() {
    equalizerValues.assignAll(List.filled(10, 0.0));
    _logger.i("Equalizer reset");
  }
  
  // 获取当前播放进度百分比
  double get progress {
    if (duration.value.inMilliseconds == 0) return 0.0;
    return position.value.inMilliseconds / duration.value.inMilliseconds;
  }
  
  // 格式化时间显示
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes: $twoDigitSeconds';
  }
} 