import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/text_styles.dart';

class AudioPlayerPage extends StatelessWidget {
  const AudioPlayerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音频播放'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text('音频播放页面 - 开发中'),
      ),
    );
  }
} 