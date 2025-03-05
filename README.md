# Synai AI - 智能AI聊天社区

Synai AI是一款专为iOS平台设计的Flutter应用，提供智能AI助手聊天和社区互动功能。用户可以与各种专业领域的AI助手进行对话，分享内容到社区，以及与其他用户互动。

## 功能特点

### AI助手聊天
- 多种专业领域的AI助手可供选择
- 支持文本、图片、语音等多种消息类型
- 智能回复和上下文理解
- 收藏喜欢的AI助手

### 社区互动
- 发布帖子分享知识和经验
- 支持图片、标签和AI助手关联
- 点赞、评论和分享功能
- 按标签和热度筛选内容

### 个人中心
- 个人资料管理
- 聊天历史记录
- 收藏内容管理
- 会员特权

## 技术栈

- Flutter 3.0+
- Provider状态管理
- Material Design UI
- 多语言支持
- 深色模式支持

## 项目结构

```
lib/
├── models/          # 数据模型
├── providers/       # 状态管理
├── screens/         # 页面
│   └── tabs/        # 主页标签页
├── utils/           # 工具类
├── widgets/         # UI组件
└── main.dart        # 应用入口
```

## 安装与运行

### 前提条件
- Flutter SDK 3.0+
- Dart SDK 3.0+
- iOS 13.0+

### 安装步骤

1. 克隆仓库
```bash
git clone https://github.com/yourusername/synai-ai.git
cd synai-ai
```

2. 安装依赖
```bash
flutter pub get
```

3. 运行应用
```bash
flutter run
```

## 依赖项

- `provider`: ^6.0.5 - 状态管理
- `intl`: ^0.18.1 - 国际化和日期格式化
- `image_picker`: ^1.0.4 - 图片选择
- `cached_network_image`: ^3.3.0 - 图片缓存
- `flutter_svg`: ^2.0.7 - SVG图标支持
- `shared_preferences`: ^2.2.1 - 本地数据存储

## 贡献指南

1. Fork项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add some amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建Pull Request

## 许可证

本项目采用MIT许可证 - 详情请参阅 [LICENSE](LICENSE) 文件

## 联系方式

项目维护者 - [@yourusername](https://github.com/yourusername)

项目链接: [https://github.com/yourusername/synai-ai](https://github.com/yourusername/synai-ai)
