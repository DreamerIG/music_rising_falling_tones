import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controller/metronome_controller.dart';
import '../../utils/audio_generator.dart';
import 'dart:math' as math;

class MetronomePage extends StatefulWidget {
  const MetronomePage({Key? key}) : super(key: key);

  @override
  State<MetronomePage> createState() => _MetronomePageState();
}

class _MetronomePageState extends State<MetronomePage> 
    with TickerProviderStateMixin {
  
  late AnimationController _rotationController;
  late AnimationController _needleController;
  
  // 音频控制器
  final MetronomeController _metronomeController = Get.find<MetronomeController>();
  
  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _needleController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    
    // 监听播放状态
    _metronomeController.isPlaying.listen((isPlaying) {
      if (isPlaying) {
        _rotationController.repeat();
      } else {
        _rotationController.stop();
      }
    });
  }
  
  @override
  void dispose() {
    _rotationController.dispose();
    _needleController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A5568), // 深灰蓝色背景
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.folder_open, color: Colors.white70),
          onPressed: () => _showAudioOptions(),
        ),
        title: const Text(
          'A=440',
          style: TextStyle(
            color: Colors.white70,
            fontSize: 16,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.tune, color: Colors.white70),
            onPressed: () {
              // 调音功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white70),
            onPressed: () {
              // 设置功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white70),
            onPressed: () {
              // 导出功能
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white70),
            onPressed: () {
              // 编辑功能
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // 中央黑胶唱片播放器
          Expanded(
            flex: 3,
            child: Center(
              child: _buildVinylPlayer(),
            ),
          ),
          
          // 时间显示和播放按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildTimeControls(),
          ),
          
          // 播放进度条
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildProgressBar(),
          ),
          
          const SizedBox(height: 20),
          
          // 移调控制
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildPitchControl(),
          ),
          
          const SizedBox(height: 20),
          
          // 变速控制
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildSpeedControl(),
          ),
          
          const SizedBox(height: 20),
          
          // 均衡器
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _buildEqualizer(),
          ),
          
          const SizedBox(height: 10),
          
          // 底部提示
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '温馨提示：移调请在二度之内，超之音质将无法得到保障',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildVinylPlayer() {
    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        children: [
          // 黑胶唱片
          AnimatedBuilder(
            animation: _rotationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationController.value * 2 * math.pi,
                child: Container(
                  width: 280,
                  height: 280,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                  ),
                  child: Stack(
                    children: [
                      // 外圈
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white24,
                            width: 2,
                          ),
                        ),
                      ),
                      // 内圈
                      Center(
                        child: Container(
                          width: 120,
                          height: 120,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF8B1538), // 深红色
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // 唱针
          Positioned(
            top: 20,
            right: 40,
            child: Transform.rotate(
              angle: math.pi / 8,
              child: Container(
                width: 4,
                height: 140,
                decoration: const BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ),
          ),
          // 唱针头
          Positioned(
            top: 10,
            right: 35,
            child: Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildProgressBar() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Obx(() {
          final progress = _metronomeController.progress;
          return SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
              activeTrackColor: const Color(0xFFE53E3E),
              inactiveTrackColor: Colors.white24,
              thumbColor: const Color(0xFFE53E3E),
            ),
            child: Slider(
              value: progress.clamp(0.0, 1.0),
              onChanged: (value) {
                final newPosition = Duration(
                  milliseconds: (value * _metronomeController.duration.value.inMilliseconds).toInt(),
                );
                _metronomeController.seekTo(newPosition);
              },
            ),
          );
        }),
      ],
    );
  }
  
  Widget _buildTimeControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // 当前时间
        Obx(() => Text(
          _metronomeController.formatDuration(_metronomeController.position.value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        )),
        
        // 播放按钮
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE53E3E), // 红色
          ),
          child: IconButton(
            icon: Obx(() => Icon(
              _metronomeController.isPlaying.value ? Icons.pause : Icons.play_arrow,
              color: Colors.white,
              size: 32,
            )),
            onPressed: () {
              if (_metronomeController.isPlaying.value) {
                _metronomeController.pause();
              } else {
                _metronomeController.play();
              }
            },
          ),
        ),
        
        // 总时间
        Obx(() => Text(
          _metronomeController.formatDuration(_metronomeController.duration.value),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        )),
      ],
    );
  }
  
  Widget _buildPitchControl() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '移调',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Obx(() => Text(
              '${_metronomeController.pitch.value.toInt()} (原调)',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            )),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              '- 12',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  activeTrackColor: const Color(0xFF38B2AC),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: const Color(0xFF38B2AC),
                ),
                child: Obx(() => Slider(
                  value: _metronomeController.pitch.value,
                  min: -12,
                  max: 12,
                  divisions: 24,
                  onChanged: (value) {
                    _metronomeController.setPitch(value);
                  },
                )),
              ),
            ),
            const Text(
              '+12',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                onPressed: () {
                  _metronomeController.resetPitch();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildSpeedControl() {
    return Column(
      children: [
        Obx(() => Text(
          '变速 ${_metronomeController.speed.value.toStringAsFixed(1)}X',
          style: const TextStyle(color: Colors.white, fontSize: 16),
        )),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text(
              '0.5X',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 4,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  activeTrackColor: const Color(0xFF38B2AC),
                  inactiveTrackColor: Colors.white24,
                  thumbColor: const Color(0xFF38B2AC),
                ),
                child: Obx(() => Slider(
                  value: _metronomeController.speed.value,
                  min: 0.5,
                  max: 1.5,
                  divisions: 20,
                  onChanged: (value) {
                    _metronomeController.setSpeed(value);
                  },
                )),
              ),
            ),
            const Text(
              '1.5X',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white24,
              ),
              child: IconButton(
                icon: const Icon(Icons.refresh, color: Colors.white, size: 16),
                onPressed: () {
                  _metronomeController.resetSpeed();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildEqualizer() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '均衡器',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            Obx(() => Switch(
              value: _metronomeController.isEqualizerEnabled.value,
              onChanged: (value) {
                _metronomeController.toggleEqualizer();
              },
              activeColor: const Color(0xFF48BB78),
            )),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => _metronomeController.isEqualizerEnabled.value ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '+12 dB',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                for (int i = 0; i < 5; i++) const SizedBox(),
                const Text(
                  '音量',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (int i = 0; i < 10; i++)
                  SizedBox(
                    width: 20,
                    height: 120,
                    child: RotatedBox(
                      quarterTurns: 3,
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 2,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 4),
                          activeTrackColor: i == 9 ? const Color(0xFF38B2AC) : Colors.white70,
                          inactiveTrackColor: Colors.white24,
                          thumbColor: i == 9 ? const Color(0xFF38B2AC) : Colors.white70,
                        ),
                        child: Slider(
                          value: _metronomeController.equalizerValues[i],
                          min: -12,
                          max: 12,
                          onChanged: (value) {
                            _metronomeController.setEqualizerValue(i, value);
                          },
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '0 dB',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                for (int i = 0; i < 5; i++) const SizedBox(),
                const Text(
                  '',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '-12 dB',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
                for (int i = 0; i < 5; i++) const SizedBox(),
                const Text(
                  '',
                  style: TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('32', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('64', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('125', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('250', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('500', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('1K', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('2K', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('4K', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('8K', style: TextStyle(color: Colors.white54, fontSize: 10)),
                Text('16K', style: TextStyle(color: Colors.white54, fontSize: 10)),
              ],
            ),
          ],
        ) : const SizedBox.shrink()),
      ],
    );
  }
  
  void _showAudioOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF4A5568),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '选择音频',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.music_note, color: Colors.white),
                title: const Text('生成测试音频 (440Hz)', style: TextStyle(color: Colors.white)),
                onTap: () => _generateAndLoadAudio(440.0),
              ),
              ListTile(
                leading: const Icon(Icons.speed, color: Colors.white),
                title: const Text('生成节拍器音频 (120 BPM)', style: TextStyle(color: Colors.white)),
                onTap: () => _generateAndLoadMetronome(120),
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack, color: Colors.white),
                title: const Text('生成低音测试 (220Hz)', style: TextStyle(color: Colors.white)),
                onTap: () => _generateAndLoadAudio(220.0),
              ),
              ListTile(
                leading: const Icon(Icons.audiotrack, color: Colors.white),
                title: const Text('生成高音测试 (880Hz)', style: TextStyle(color: Colors.white)),
                onTap: () => _generateAndLoadAudio(880.0),
              ),
            ],
          ),
        );
      },
    );
  }
  
  Future<void> _generateAndLoadAudio(double frequency) async {
    Navigator.pop(context);
    
    try {
      // 显示加载状态
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        barrierDismissible: false,
      );
      
      // 生成音频文件
      final filePath = await AudioGenerator.generateTestAudio(
        frequency: frequency,
        duration: 10.0, // 10秒
      );
      
      // 加载音频文件
      await _metronomeController.loadAudio(filePath);
      
      // 关闭加载对话框
      Get.back();
      
      // 显示成功消息
      Get.snackbar(
        '成功',
        '音频文件已生成并加载 (${frequency.toInt()}Hz)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // 关闭加载对话框
      Get.back();
      
      // 显示错误消息
      Get.snackbar(
        '错误',
        '生成音频文件失败: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> _generateAndLoadMetronome(int bpm) async {
    Navigator.pop(context);
    
    try {
      // 显示加载状态
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
        barrierDismissible: false,
      );
      
      // 生成节拍器音频文件
      final filePath = await AudioGenerator.generateMetronomeAudio(
        bpm: bpm,
        duration: 30.0, // 30秒
      );
      
      // 加载音频文件
      await _metronomeController.loadAudio(filePath);
      
      // 关闭加载对话框
      Get.back();
      
      // 显示成功消息
      Get.snackbar(
        '成功',
        '节拍器音频已生成并加载 (${bpm} BPM)',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      // 关闭加载对话框
      Get.back();
      
      // 显示错误消息
      Get.snackbar(
        '错误',
        '生成节拍器音频失败: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
} 