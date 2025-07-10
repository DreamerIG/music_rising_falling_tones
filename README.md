# 音乐升降调应用

一个专业的音乐升降调工具，支持音频播放、音调调整、节拍器等功能。

## 项目架构

本项目采用分层架构设计，参考了 `taiozhanzhe_flutter` 项目的架构模式。

### 目录结构

```
lib/
├── main.dart                 # 应用入口
├── app.dart                  # 应用主文件
├── core/                     # 核心层
│   ├── controller/           # 控制器层
│   │   ├── app_controller.dart
│   │   └── audio_controller.dart
│   ├── model/                # 数据模型层
│   │   └── audio_model.dart
│   └── service/              # 服务层
│       └── audio_service.dart
├── pages/                    # 页面层
│   ├── home/                 # 主页
│   ├── audio_list/           # 音频列表页
│   ├── audio_player/         # 音频播放页
│   ├── settings/             # 设置页
│   └── about/                # 关于页
├── routes/                   # 路由层
│   ├── app_routes.dart       # 路由常量
│   └── app_pages.dart        # 路由配置
├── common/                   # 公共资源
│   ├── colors.dart           # 颜色配置
│   └── text_styles.dart      # 文字样式
├── widgets/                  # 组件层
│   └── common/               # 通用组件
│       ├── app_button.dart
│       └── loading_widget.dart
└── utils/                    # 工具层
    ├── constants.dart        # 常量定义
    └── helpers.dart          # 工具函数
```

### 架构说明

#### 1. 核心层 (Core Layer)
- **Controller**: 使用 GetX 进行状态管理，处理业务逻辑
- **Model**: 数据模型，定义数据结构
- **Service**: 服务层，处理数据操作和外部接口

#### 2. 页面层 (Pages Layer)
- 每个页面都有独立的目录
- 页面逻辑与UI分离
- 使用 GetX 进行页面导航和状态管理

#### 3. 路由层 (Routes Layer)
- 统一管理应用路由
- 支持页面参数传递
- 自动依赖注入

#### 4. 公共资源 (Common)
- 颜色、样式等公共配置
- 主题管理
- 国际化支持

#### 5. 组件层 (Widgets)
- 可复用的UI组件
- 组件化开发
- 统一的组件规范

#### 6. 工具层 (Utils)
- 工具函数
- 常量定义
- 辅助方法

## 技术栈

- **状态管理**: GetX
- **音频播放**: just_audio
- **本地存储**: shared_preferences, hive
- **网络请求**: dio
- **权限管理**: permission_handler
- **UI组件**: Flutter Material Design
- **日志**: logger

## 主要功能

### 1. 音频播放
- 支持多种音频格式 (MP3, WAV, M4A, AAC, FLAC, OGG)
- 播放控制 (播放、暂停、停止、跳转)
- 播放进度显示

### 2. 音调调整
- 实时音调调整 (-12 到 +12 半音)
- 播放速度控制 (0.5x 到 2.0x)
- 音量控制

### 3. 音频管理
- 音频文件列表
- 文件导入和管理
- 音频信息显示

### 4. 设置功能
- 主题切换 (深色/浅色模式)
- 音频设置
- 应用偏好设置

## 开发指南

### 环境要求
- Flutter SDK: >=3.0.0
- Dart SDK: >=3.0.0
- Android: API 21+
- iOS: 11.0+

### 安装依赖
```bash
flutter pub get
```

### 运行项目
```bash
flutter run
```

### 代码规范
- 使用 Flutter 官方代码规范
- 遵循 GetX 最佳实践
- 组件化开发
- 注释完善

## 项目特色

1. **分层架构**: 清晰的分层设计，便于维护和扩展
2. **状态管理**: 使用 GetX 进行高效的状态管理
3. **组件化**: 可复用的UI组件
4. **主题支持**: 支持深色/浅色主题切换
5. **国际化**: 支持多语言
6. **音频处理**: 专业的音频处理功能

## 贡献指南

1. Fork 项目
2. 创建功能分支
3. 提交更改
4. 推送到分支
5. 创建 Pull Request

## 许可证

本项目采用 MIT 许可证。
