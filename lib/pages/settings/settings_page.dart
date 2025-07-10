import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/text_styles.dart';
import '../../core/controller/app_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 主题设置
          _buildSettingSection(
            title: '外观',
            children: [
              Obx(() => SwitchListTile(
                title: const Text('深色模式'),
                subtitle: const Text('切换应用主题'),
                value: appController.isDarkMode.value,
                onChanged: (value) => appController.toggleTheme(),
              )),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 音频设置
          _buildSettingSection(
            title: '音频',
            children: [
              Obx(() => ListTile(
                title: const Text('音量'),
                subtitle: Text('${(appController.volume.value * 100).toInt()}%'),
                trailing: SizedBox(
                  width: 100,
                  child: Slider(
                    value: appController.volume.value,
                    onChanged: (value) => appController.setVolume(value),
                  ),
                ),
              )),
              Obx(() => SwitchListTile(
                title: const Text('自动播放'),
                subtitle: const Text('加载音频后自动播放'),
                value: appController.autoPlay.value,
                onChanged: (value) => appController.setAutoPlay(value),
              )),
              Obx(() => SwitchListTile(
                title: const Text('显示波形'),
                subtitle: const Text('播放时显示音频波形'),
                value: appController.showWaveform.value,
                onChanged: (value) => appController.setShowWaveform(value),
              )),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // 关于
          _buildSettingSection(
            title: '关于',
            children: [
              ListTile(
                title: const Text('版本信息'),
                subtitle: const Text('1.0.0'),
                leading: const Icon(Icons.info),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildSettingSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: AppTextStyles.headline2,
            ),
          ),
          ...children,
        ],
      ),
    );
  }
} 