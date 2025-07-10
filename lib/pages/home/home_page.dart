import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/text_styles.dart';
import '../../routes/app_routes.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音乐升降调'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Get.toNamed(AppRoutes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 欢迎标题
            Text(
              '欢迎使用音乐升降调',
              style: AppTextStyles.headline1,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            
            // 功能卡片
            _buildFeatureCard(
              icon: Icons.music_note,
              title: '音频播放',
              subtitle: '播放和调整音频文件',
              onTap: () => Get.toNamed(AppRoutes.audioList),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.tune,
              title: '音调检测',
              subtitle: '实时检测音频音调',
              onTap: () => Get.toNamed(AppRoutes.pitchDetector),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.speed,
              title: '节拍器',
              subtitle: '专业节拍器工具',
              onTap: () => Get.toNamed(AppRoutes.metronome),
            ),
            const SizedBox(height: 16),
            
            _buildFeatureCard(
              icon: Icons.tune,
              title: '调音器',
              subtitle: '乐器调音助手',
              onTap: () => Get.toNamed(AppRoutes.tuner),
            ),
            
            const Spacer(),
            
            // 关于按钮
            TextButton(
              onPressed: () => Get.toNamed(AppRoutes.about),
              child: const Text('关于应用'),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.headline2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 