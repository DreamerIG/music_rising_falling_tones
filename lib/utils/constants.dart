class AppConstants {
  // 应用信息
  static const String appName = '音乐升降调';
  static const String appVersion = '1.0.0';
  static const String appDescription = '专业的音乐升降调工具';
  
  // 音频相关常量
  static const double minPitch = -12.0;
  static const double maxPitch = 12.0;
  static const double defaultPitch = 0.0;
  
  static const double minSpeed = 0.5;
  static const double maxSpeed = 2.0;
  static const double defaultSpeed = 1.0;
  
  static const double minVolume = 0.0;
  static const double maxVolume = 1.0;
  static const double defaultVolume = 1.0;
  
  // 支持的音频格式
  static const List<String> supportedAudioFormats = [
    'mp3',
    'wav',
    'm4a',
    'aac',
    'flac',
    'ogg',
  ];
  
  // 文件大小限制 (MB)
  static const int maxFileSize = 100;
  
  // 缓存相关
  static const String audioCacheDir = 'audio_cache';
  static const String tempDir = 'temp';
  
  // 设置键名
  static const String keyIsDarkMode = 'isDarkMode';
  static const String keyLanguage = 'language';
  static const String keyVolume = 'volume';
  static const String keyAutoPlay = 'autoPlay';
  static const String keyShowWaveform = 'showWaveform';
  static const String keyPitch = 'pitch';
  static const String keySpeed = 'speed';
  
  // 错误消息
  static const String errorFileNotFound = '文件未找到';
  static const String errorFileTooLarge = '文件过大';
  static const String errorUnsupportedFormat = '不支持的音频格式';
  static const String errorLoadFailed = '加载失败';
  static const String errorPlayFailed = '播放失败';
  static const String errorSaveFailed = '保存失败';
  
  // 成功消息
  static const String successLoadAudio = '音频加载成功';
  static const String successSaveAudio = '音频保存成功';
  static const String successDeleteAudio = '音频删除成功';
} 