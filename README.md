# PLRTCStreamingKit
PLRTCStreamingKit 是七牛推出的一款适用于 iOS 平台的连麦互动 SDK，支持低延时音视频通话、RTMP 直播推流，可快速开发一对一视频聊天、多人视频会议、网红直播连麦、狼人杀、娃娃机等应用，接口简单易用，支持高度定制以及二次开发。

<a id="1"></a>
# 1 功能列表
PLRTCStreamingKit SDK 的功能  

| 功能 | 描述 |
|---|---|
| 基本的推流和连麦对讲功能 | 轻松与主播视频互动 |
| 基本的视频合流和音频混音功能 | 边唱边聊不单调 |
| 支持丰富的连麦消息回调 | 掌握连麦消息状态 |
| 支持踢人功能 | 多级管理 |
| 支持获取连麦房间统计信息（帧率、码率等） | 充分掌握连麦动态 |
| 支持纯音频连麦 | 自由配置语音通话 |
| 支持连麦大小窗口切换 | 轻松实现更多显示可能 |
| 支持连麦获取远端麦克风音量大小 | 轻松获得聊天音量 |
| 支持硬件编码 | 更低的 CPU 占用及发热量 |
| 支持 ARM7, ARM64 指令集 | 为最新设备优化 |
| 提供音视频配置分离 | 配置解耦 |
| 支持推流时码率变更 | 更方便定制流畅度/清晰度策略 |
| 支持弱网丢帧策略 | 不必担心累计延时，保障实时性 |
| 支持模拟器运行 | 不影响模拟器快速调试 |
| 支持 RTMP 协议直播推流 | 保证秒级实时性 |
| 支持后台推流 | 轻松实现边推流边聊天等操作 |
| 提供多码率可选 | 更自由的配置 |
| 提供 H.264 视频编码 | 多种 profile level 可设定 |
| 支持多分辨率编码 | 更可控的清晰度 |
| 提供 AAC 音频编码 | 当前采用 AAC-LC |
| 提供 HeaderDoc 文档 | 开发中使用 Quick Help 及时阅读文档 |
| 支持美颜滤镜 | 轻松实现更美真人秀 |
| 支持水印功能 | 彰显自身特色 | 
| 提供内置音效及音频文件播放功能 | 轻松实现各种音效 | 
| 支持返听功能 | 唱歌更易把握节奏 | 
| 支持截屏功能 | 轻松分享美好瞬间 | 
| 支持 iOS 10 ReplayKit 录屏 | 方便分享游戏过程 | 
| 支持苹果 ATS 安全标准 | 安全性更高 |   

# 2 阅读对象

本文档为技术文档，需要阅读者：

- 具有基本的 iOS 开发能力
- 准备接入七牛云直播

<a id="3"></a>
# 3 开发准备

<a id="3.1"></a>
## 3.1 设备以及系统

- 设备要求：iPhone 5 及以上
- 系统要求：iOS 8.0+

<a id="3.2"></a>
## 3.2 前置条件

- 已注册七牛账号
- 通过 pili@qiniu.com 申请并已开通直播权限   
## 4. 安装方法

[CocoaPods](https://cocoapods.org/) 是针对 Objective-C 的依赖管理工具，它能够将使用类似 PLRTCStreamingKit 的第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：

```bash
$ sudo gem install cocoapods
```

### Podfile

为了使用 CoacoaPods 集成 PLRTCStreamingKit 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
target 'TargetName' do
pod 'PLRTCStreamingKit'
end
```

然后，运行如下的命令：

```bash
$ pod install
```

## 5. PLRTCStreamingKit 文档

请参考开发者中心文档：[PLRTCStreamingKit 文档](https://github.com/pili-engineering/PLRTCStreamingKit/doc/PLRTCStreamingKit.md)   
## 6. 反馈及意见

当你遇到任何问题时，可以通过在 GitHub 的 repo 提交 issues 来反馈问题，请在 Labels 中指明类型为 bug 或者其他，请描述清楚遇到的问题，如果有错误信息也一同附带，尽可能附带如下信息：   
1. SDK 版本   
2. 复现问题的手机型号，系统   
3. 复现流程    
4. demo 中是否可复现   
5. 错误 log   
6. 如果推流有问题，麻烦提供推流地址，若是连麦问题，麻烦提供房间号，token 等相关信息      

[通过这里查看已有的 issues 和提交 Bug](https://github.com/pili-engineering/PLRTCStreamingKit/issues)