import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final Logger _logger = Logger();

class AppController extends GetxController {
  static AppController get to => Get.find();
  
  // 应用状态
  final RxBool isLoading = false.obs;
  final RxBool isDarkMode = false.obs;
  final RxString currentLanguage = 'zh_CN'.obs;
  
  // 用户设置
  final RxDouble volume = 1.0.obs;
  final RxBool autoPlay = false.obs;
  final RxBool showWaveform = true.obs;
  
  @override
  void onInit() {
    super.onInit();
    _logger.i("AppController onInit");
    _loadSettings();
  }
  
  @override
  void onReady() {
    super.onReady();
    _logger.i("AppController onReady");
  }
  
  @override
  void onClose() {
    _logger.i("AppController onClose");
    super.onClose();
  }
  
  // 加载用户设置
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
      currentLanguage.value = prefs.getString('language') ?? 'zh_CN';
      volume.value = prefs.getDouble('volume') ?? 1.0;
      autoPlay.value = prefs.getBool('autoPlay') ?? false;
      showWaveform.value = prefs.getBool('showWaveform') ?? true;
      
      _logger.i("Settings loaded successfully");
    } catch (e) {
      _logger.e("Failed to load settings: $e");
    }
  }
  
  // 保存用户设置
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setBool('isDarkMode', isDarkMode.value);
      await prefs.setString('language', currentLanguage.value);
      await prefs.setDouble('volume', volume.value);
      await prefs.setBool('autoPlay', autoPlay.value);
      await prefs.setBool('showWaveform', showWaveform.value);
      
      _logger.i("Settings saved successfully");
    } catch (e) {
      _logger.e("Failed to save settings: $e");
    }
  }
  
  // 切换主题
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    saveSettings();
  }
  
  // 设置语言
  void setLanguage(String language) {
    currentLanguage.value = language;
    saveSettings();
  }
  
  // 设置音量
  void setVolume(double value) {
    volume.value = value.clamp(0.0, 1.0);
    saveSettings();
  }
  
  // 设置自动播放
  void setAutoPlay(bool value) {
    autoPlay.value = value;
    saveSettings();
  }
  
  // 设置显示波形
  void setShowWaveform(bool value) {
    showWaveform.value = value;
    saveSettings();
  }
} 