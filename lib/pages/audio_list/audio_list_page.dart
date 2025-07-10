import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/colors.dart';
import '../../common/text_styles.dart';
import '../../routes/app_routes.dart';

class AudioListPage extends StatelessWidget {
  const AudioListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音频列表'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: const Center(
        child: Text('音频列表页面 - 开发中'),
      ),
    );
  }
} 