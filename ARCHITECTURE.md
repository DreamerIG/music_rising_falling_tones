# 音乐升降调应用 - 系统架构文档

## 概述

本项目参考了 `taiozhanzhe_flutter` 项目的架构模式，采用分层架构设计，使用 GetX 作为状态管理解决方案。

## 架构层次

### 1. 表现层 (Presentation Layer)

#### 页面 (Pages)
- **HomePage**: 应用主页，展示主要功能入口
- **AudioListPage**: 音频文件列表页面
- **AudioPlayerPage**: 音频播放器页面
- **SettingsPage**: 应用设置页面
- **AboutPage**: 关于页面

#### 组件 (Widgets)
- **AppButton**: 通用按钮组件
- **LoadingWidget**: 加载状态组件
- **LoadingOverlay**: 加载遮罩组件

### 2. 业务逻辑层 (Business Logic Layer)

#### 控制器 (Controllers)
- **AppController**: 应用全局状态管理
  - 主题管理 (深色/浅色模式)
  - 语言设置
  - 用户偏好设置
  - 应用状态管理

- **AudioController**: 音频播放控制
  - 音频播放状态管理
  - 播放控制 (播放、暂停、停止)
  - 音调调整
  - 播放速度控制
  - 音频文件管理

### 3. 数据层 (Data Layer)

#### 模型 (Models)
- **AudioModel**: 音频文件数据模型
  - 文件基本信息 (ID、名称、路径)
  - 音频元数据 (艺术家、专辑、时长)
  - 文件属性 (大小、创建时间、修改时间)

#### 服务 (Services)
- **AudioService**: 音频文件服务
  - 音频文件管理
  - 文件系统操作
  - 音频文件验证
  - 文件复制和删除

### 4. 基础设施层 (Infrastructure Layer)

#### 路由管理 (Routes)
- **AppRoutes**: 路由常量定义
- **AppPages**: 路由配置和页面绑定

#### 工具类 (Utils)
- **AppConstants**: 应用常量定义
- **AppHelpers**: 工具函数集合

#### 公共资源 (Common)
- **AppColors**: 颜色配置
- **AppTextStyles**: 文字样式配置

## 技术架构

### 状态管理 (GetX)
```dart
// 控制器示例
class AppController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final RxDouble volume = 1.0.obs;
  
  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    saveSettings();
  }
}
```

### 依赖注入
```dart
// 全局依赖注入
class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AppController>(AppController());
    Get.put<AudioController>(AudioController());
  }
}
```

### 路由管理
```dart
// 路由配置
GetPage(
  name: AppRoutes.home,
  page: () => const HomePage(),
  binding: HomeBinding(),
)
```

## 数据流

### 1. 用户交互流程
```
用户操作 → 页面组件 → 控制器 → 服务层 → 数据模型
```

### 2. 状态更新流程
```
数据变化 → 控制器 → 响应式变量 → UI更新
```

### 3. 音频播放流程
```
选择音频 → AudioController → just_audio → 播放状态更新 → UI反馈
```

## 设计模式

### 1. MVC/GetX 模式
- **Model**: 数据模型 (AudioModel)
- **View**: 页面和组件
- **Controller**: GetX 控制器

### 2. 单例模式
- **AudioService**: 音频服务单例
- **Logger**: 日志单例

### 3. 工厂模式
- **AudioModel.fromJson()**: 从JSON创建模型实例

### 4. 观察者模式
- **GetX 响应式变量**: 自动UI更新

## 文件组织

### 目录结构说明
```
lib/
├── main.dart                 # 应用入口点
├── app.dart                  # 应用配置和初始化
├── core/                     # 核心业务逻辑
│   ├── controller/           # 状态管理控制器
│   ├── model/                # 数据模型
│   └── service/              # 业务服务
├── pages/                    # 页面组件
├── routes/                   # 路由配置
├── common/                   # 公共资源
├── widgets/                  # 可复用组件
└── utils/                    # 工具类
```

### 命名规范
- **文件命名**: 使用 snake_case (如: `audio_controller.dart`)
- **类命名**: 使用 PascalCase (如: `AudioController`)
- **变量命名**: 使用 camelCase (如: `isPlaying`)
- **常量命名**: 使用 SCREAMING_SNAKE_CASE (如: `APP_NAME`)

## 扩展性设计

### 1. 模块化设计
- 每个功能模块独立
- 清晰的依赖关系
- 易于添加新功能

### 2. 插件化架构
- 音频处理插件化
- 支持多种音频格式
- 可扩展的音频效果

### 3. 主题系统
- 支持深色/浅色主题
- 可自定义颜色方案
- 响应式主题切换

## 性能优化

### 1. 内存管理
- 及时释放音频资源
- 清理临时文件
- 优化图片加载

### 2. 状态管理优化
- 使用 GetX 响应式变量
- 避免不必要的重建
- 合理使用 Obx 和 GetBuilder

### 3. 音频处理优化
- 异步音频加载
- 流式音频处理
- 缓存机制

## 测试策略

### 1. 单元测试
- 控制器逻辑测试
- 服务层测试
- 工具函数测试

### 2. 集成测试
- 页面交互测试
- 路由导航测试
- 音频播放测试

### 3. 性能测试
- 内存使用测试
- 音频处理性能测试
- UI响应性能测试

## 部署和发布

### 1. 构建配置
- Android 配置
- iOS 配置
- 版本管理

### 2. 发布流程
- 代码审查
- 自动化测试
- 应用商店发布

## 维护和更新

### 1. 版本管理
- 语义化版本控制
- 更新日志维护
- 向后兼容性

### 2. 错误处理
- 全局异常捕获
- 用户友好的错误提示
- 错误日志记录

### 3. 监控和分析
- 应用性能监控
- 用户行为分析
- 崩溃报告收集

## 总结

本架构设计具有以下特点：

1. **清晰的分层结构**: 便于理解和维护
2. **响应式状态管理**: 高效的UI更新
3. **模块化设计**: 易于扩展和修改
4. **组件化开发**: 提高代码复用性
5. **类型安全**: 减少运行时错误
6. **性能优化**: 良好的用户体验

这个架构为音乐升降调应用提供了坚实的基础，支持后续功能的扩展和优化。 