import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/text_styles.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            
            // 应用图标
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.music_note,
                size: 50,
                color: Colors.white,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // 应用名称
            Text(
              '音乐升降调',
              style: AppTextStyles.headline1,
            ),
            
            const SizedBox(height: 8),
            
            // 版本信息
            Text(
              '版本 1.0.0',
              style: AppTextStyles.body2,
            ),
            
            const SizedBox(height: 32),
            
            // 应用描述
            Text(
              '专业的音乐升降调工具，支持音频播放、音调调整、节拍器等功能。',
              style: AppTextStyles.body1,
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 32),
            
            // 功能列表
            _buildFeatureItem('音频播放和调整'),
            _buildFeatureItem('实时音调检测'),
            _buildFeatureItem('专业节拍器'),
            _buildFeatureItem('乐器调音器'),
            
            const Spacer(),
            
            // 版权信息
            Text(
              '© 2024 音乐升降调. All rights reserved.',
              style: AppTextStyles.body2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: AppColors.success,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.body1,
          ),
        ],
      ),
    );
  }
} 