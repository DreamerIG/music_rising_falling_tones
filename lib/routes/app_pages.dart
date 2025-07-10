import 'package:get/get.dart';
import '../pages/home/home_page.dart';
import '../pages/audio_player/audio_player_page.dart';
import '../pages/audio_list/audio_list_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/about/about_page.dart';
import '../pages/metronome/metronome_page.dart';
import '../core/controller/metronome_controller.dart';
import 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.audioPlayer,
      page: () => const AudioPlayerPage(),
      binding: AudioPlayerBinding(),
    ),
    GetPage(
      name: AppRoutes.audioList,
      page: () => const AudioListPage(),
      binding: AudioListBinding(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsPage(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => const AboutPage(),
      binding: AboutBinding(),
    ),
    GetPage(
      name: AppRoutes.metronome,
      page: () => const MetronomePage(),
      binding: MetronomeBinding(),
    ),
  ];
}

// 页面绑定类
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // 主页不需要额外的依赖注入
  }
}

class AudioPlayerBinding extends Bindings {
  @override
  void dependencies() {
    // 音频播放页面依赖已在全局注入
  }
}

class AudioListBinding extends Bindings {
  @override
  void dependencies() {
    // 音频列表页面依赖已在全局注入
  }
}

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    // 设置页面依赖已在全局注入
  }
}

class AboutBinding extends Bindings {
  @override
  void dependencies() {
    // 关于页面依赖已在全局注入
  }
}

class MetronomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MetronomeController>(() => MetronomeController());
  }
} 