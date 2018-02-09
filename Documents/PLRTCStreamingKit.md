<a id="1"></a>
# 1 概述

PLRTCStreamingKit 是七牛推出的一款适用于 iOS 平台的连麦互动 SDK，支持低延时音视频通话、RTMP 直播推流，可快速开发一对一视频聊天、多人视频会议、网红直播连麦、狼人杀、娃娃机等应用，接口简单易用，支持高度定制以及二次开发。

<a id="1.1"></a>
## 1.1 功能以及版本

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
| 支持 QUIC 推流功能 | 弱网推流更流畅 |

<a id="2"></a>
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

<a id="4"></a>
# 4 总体设计

<a id="4.1"></a>
## 4.1 基本规则

为了方便理解和使用，对于 SDK 的接口设计，我们遵循了如下的原则：

- 每一个接口类，均以 `PL` 开头
- 配置类，以 `PLXXXConfiguration` 命名
- 所有的回调代理，以 `PLXXXXDelegate` 命名    

<a id="4.2"></a>
## 4.2 框架规则
PLRTCStreamingKit 提供四种不同的 API，分别介绍如下：
### 推流    

- 核心类是 PLStreamingSession，提供包括音视频编码、封包以及网络发送功能。另外，还支持 ReplayKit 录屏推流功能。

### 采集 + 连麦   

- 核心类是 PLRTCSession，提供包括音视频采集、美颜滤镜以及连麦功能；    
 
 
### 推流 + 连麦   

- 核心类是 PLRTCStreamingSession，在 PLStreamingSession 基础上提供连麦功能，PLRTCStreamingSession 不支持音视频采集，需要您调用相关接口导入音视频数据；      

### 采集 + 推流 + 连麦    

- 核心类是 PLMediaStreamingSession，在 PLRTCStreamingSession 基础上增加音视频采集、美颜、音效等基础功能，我们强烈推荐对音视频没有太多了解的开发者使用 PLMediaStreamingSession 进行开发，如果您对音视频数据的采集和处理有更多的需求，那么可以使用 PLStreamingSession 或 PLRTCStreamingSession 进行开发。   

<a id="4.3"></a>

## 4.3 核心接口

核心的接口类说明如下：

| 接口类名                 | 功能        | 备注              |
| ----------------------- | --------- | --------------- |
| PLStreamingSession    | 提供推流功能   | 提供包括音视频编码、封包以及网络发送功能，另外，还支持录屏推流功能 |
| PLRTCSession   	   | 提供采集和连麦功能 | 提供包括音视频编码、封包以及连麦功能,可单独做连麦互动   |
| PLRTCStreamingSession | 提供推流和连麦功能 | 在 PLStreaming 基础上提供连麦功能     |
| PLMediaStreamingSession  | 提供采集，推流和连麦功能 | 在 PLRTCStreaming 基础上增加音视频采集、美颜、音效等基础功能     |
<a id="4.4"></a>

## 4.4 配置接口类

配置接口相关的类说明如下：

| 接口名                         | 功能        | 备注           |
| --------------------------- | --------- | ------------ |
| PLVideoCaptureConfiguration | 视频采集配置 |     预览分辨率，前后摄像头等     |
| PLAudioCaptureConfiguration | 音频采集配置   | 麦克风配置，音频数据声道等 |
| PLVideoStreamingConfiguration   | 视频编码配置   | 配置视频帧率，码率等      |
| PLAudioStreamingConfiguration   | 音频编码配置    | 配置音频帧率等    |
| PLRTCConfiguration| 连麦相关配置 | 包括连麦编码分辨率，河流分辨率等   |   
| PLAudioEffectConfiguration   | 音效配置    | 配置混音等    |
| PLAudioEffectCustomConfiguration| 用户自定义音效配置 | 用户自定义音效配置   |


<a id="4.5"></a>

## 4.5 连麦视频渲染类

连麦显示功能相关的类说明如下：

| 接口名                      | 功能        | 备注        |
| ------------------------ | --------- | --------- |
| PLRTCVideoRender     | 设置连麦显示参数 | 包括设置该用户在合流中显示位置，设置显示其他连麦者位置等      |
| PLRTCVideoView | 设置该连麦者显示画面    | 显示其他连麦者界面 |



<a id="5"></a>
# 5 快速开始

<a id="5.1"></a>
## 5.1 开发环境配置

- Xcode 开发工具。App Store [下载地址](https://itunes.apple.com/us/app/xcode/id497799835?ls=1&mt=12)
- 安装 CocoaPods。了解 CocoaPods 使用方法。[官方网站](https://cocoapods.org)

<a id="5.2"></a>
## 5.2 导入 SDK

<a id="5.2.1"></a>
[CocoaPods](https://cocoapods.org/) 是针对 Objective-C 的依赖管理工具，它能够将使用类似 PLRTCStreamingKit 的第三方库的安装过程变得非常简单和自动化，你能够用下面的命令来安装它：

```bash
$ sudo gem install cocoapods
```

### Podfile

为了使用 CoacoaPods 集成 PLRTCStreamingKit 到你的 Xcode 工程当中，你需要编写你的 `Podfile`

```ruby
target 'TargetName' do
#真机(默认)
pod 'PLRTCStreamingKit'
end
```
   
有需要使用模拟器 + 真机的客户，可如下编写你的`Podfile`，    
  
```ruby
target 'TargetName' do
#真机+模拟器
pod "PLRTCStreamingKit", :podspec => 'https://raw.githubusercontent.com/pili-engineering/PLRTCStreamingKit/master/PLRTCStreamingKit-Universal.podspec'
end
```      
#### warning:
#### 鉴于 iOS 上架时，目前只支持动态库真机，请在上架前，更换至真机版本
然后，运行如下的命令：

```bash
$ pod install
```

<a id="5.3"></a>
## 5.3 初始化推流逻辑

<a id="5.3.1"></a>
### 5.3.1 添加引用并初始化 SDK 使用环境

在 `AppDelegate.m` 中添加引用

```Objective-C
#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
```

并在 `- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions` 中添加如下代码:

``` Objective-C
[PLStreamingEnv initEnv];
```

然后在 `ViewController.m` 中添加引用

```Objective-C
#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
```

<a id="5.3.2"></a>
### 5.3.2 添加 session 属性

添加 session 属性在 `ViewController.m`

```Objective-C
@property (nonatomic, strong) PLMediaStreamingSession *session;
```

<a id="5.4"></a>
## 5.4 创建流对象

<a id="5.4.1"></a>
### 5.4.1 创建视频和音频的采集和编码配置对象

当前使用默认配置，之后可以深入研究按照自己的需求作更改

``` Objective-C
PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
PLVideoStreamingConfiguration *videoStreamingConfiguration = [PLVideoStreamingConfiguration defaultConfiguration];
PLAudioStreamingConfiguration *audioStreamingConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
```

<a id="5.4.2"></a>
### 5.4.2 创建推流 session 对象

``` Objective-C
self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:audioStreamingConfiguration stream:nil];
```

<a id="5.5"></a>
## 5.5 预览摄像头拍摄效果

将预览视图添加为当前视图的子视图

```Objective-C
[self.view addSubview:self.session.previewView];
```

<a id="5.6"></a>
## 5.6 添加推流操作

取一个最简单的场景，就是点击一个按钮，然后触发发起直播的操作。

<a id="5.6.1"></a>
### 5.6.1 添加触发按钮

我们在 `view` 上添加一个按钮吧，
在 `- (void)viewDidLoad` 方法最后添加如下代码

``` Objective-C
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
[button setTitle:@"start" forState:UIControlStateNormal];
button.frame = CGRectMake(0, 0, 100, 44);
button.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 80);
[button addTarget:self action:@selector(actionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:button];
```

<a id="5.6.2"></a>
###5.6.2 创建推流地址
在实际开发过程中，为了您的 App 有更好的用户体验，建议提前从服务器端获取推流地址

```
NSURL *pushURL = [NSURL URLWithString:@"your push url"];
```

<a id="5.6.3"></a>
### 5.6.3 实现按钮动作

``` Objective-C
- (void)actionButtonPressed:(id)sender {
    [self.session startStreamingWithPushURL:pushURL feedback:^(PLStreamStartStateFeedback feedback) {
            if (feedback == PLStreamStartStateSuccess) {
                NSLog(@"Streaming started.");
            }
            else {
                NSLog(@"Oops.");
            }
     }];
}
```

<a id="5.6.3"></a>
### 5.6.3 完成首次推流操作

Done，没有额外的代码了，现在可以开始一次推流了。
如果运行后，点击按钮提示 `Oops.`，就要检查一下你之前创建 `PLStream` 对象时填写的 `StreamJson` 是否有漏填或者填错的内容。

<a id="5.7"></a>
## 5.7 添加连麦操作
主播连麦可以使用 4.4.2 创建的 PLMediaStreamingSession 对象来进行，如果仅仅是作为副主播/普通连麦观众加入连麦，不需要推流的话，创建 PLMediaStreamingSession 对象时 audioStreamingConfiguration 及 videoStreamingConfiguration 参数可以传入 nil，示例如下：

``` Objective-C
self.session = [[PLMediaStreamingSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration videoStreamingConfiguration:nil audioStreamingConfiguration:nil stream:nil];
//连麦之前务必调用此接口，初始化连麦设置
[self.session setWithServerRegionID:PLRTC_SERVER_REGION_DEFAULT serverRegionName:@""];
```

<a id="5.7.1"></a>
### 5.7.1 添加触发按钮
我们在 `view` 上添加一个按钮吧，在 `- (void)viewDidLoad` 方法最后添加如下代码

``` Objective-C
UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
[button setTitle:@"start" forState:UIControlStateNormal];
button.frame = CGRectMake(0, 0, 100, 44);
button.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds) - 124);
[button addTarget:self action:@selector(conferenceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:button];
```

<a id="5.7.2"></a>
### 5.7.2 实现按钮动作

``` Objective-C
- (void)conferenceButtonPressed:(id)sender {
    PLRTCConfiguration *configuration = [PLRTCConfiguration defaultConfiguration];
        [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
```

<a id="5.7.3"></a>
### 5.7.3 将连麦画面添加到屏幕上
``` Objective-C
- (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID {
    PLRTCVideoView *remoteView = [[PLRTCVideoView alloc] initWithFrame:CGRectMake(0, 0, 108, 192)];
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    PLRTCVideoRender *render = [[PLRTCVideoRender alloc] init];
    render.renderView = remoteView;
    //主播需要设置当前连麦者在合流画面的位置，此设置只对主播有效
    render.mixOverlayRect = CGRectMake(244, 448, 108, 192);
    return render;
}
```

<a id="5.7.4"></a>
### 5.7.4 完成连麦操作

Done，没有额外的代码了，现在可以开始一次连麦了。如果运行后，点击按钮，没有看到对方的画面加到屏幕上，则需要检查以下方法是否回调了错误，是的话，可以将 error 打印出来，进一步查看出错的具体原因。

``` Objective-C
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error;
```


<a id="5.8"></a>
## 5.8 查看推流内容

<a id="5.8.1"></a>
### 5.8.1 登录 pili.qiniu.com 查看内容

- 登录 [pili.qiniu.com](https://pili.qiniu.com)
- 登录 `streamJson` 中使用的 hub
- 查看 `stream` 属性
- 点击属性中的播放 URL 后的箭头，即可查看内容。

<a id="5"></a>
# 6 功能使用

当你要深入理解 SDK 的一些参数及有定制化需求时，可以从高级功能部分中查询阅读，以下小节无前后依赖。

<a id="6.1"></a>
## 6.1 音视频采集和编码配置

`PLMediaStreaming` 中通过不同的 configuration 设置不同的采集或编码配置信息，对应的有：

- `PLVideoCaptureConfiguration` 视频采集配置
- `PLAudioCaptureConfiguration` 音频采集配置
- `PLVideoStreamingConfiguration` 视频编码配置
- `PLAudioStreamingConfiguration` 音频编码配置

可以通过如下途径来设置 configuration：

- 在 `PLMediaStreamingSession` init 时传递对应的 configuration
- 在推流前、推流中、推流结束后调用 `- (void)reloadVideoStreamingConfiguration:(PLVideoStreamingConfiguration *)videoStreamingConfiguration;` 重置视频编码配置
- 对于视频采集配置，可以直接设置 PLMediaStreamingSession 相关的属性；

需要注意的是，通过 reload 方法重置 configuration 时，需要确保传递的 configuration 与当前 session 已经持有的不是一个对象。

<a id="6.1.1"></a>
### 6.1.1 视频采集参数

1.自定义视频采集参数

当前的 `PLVideoCaptureConfiguration` 中可自行设定的参数有

- videoFrameRate
  - 即 FPS，每一秒所包含的视频帧数
- sessionPreset
  - 即采集时的画幅分辨率大小，目前连麦不支持不能被 16 整除的分辨率，请不要设置，否则会出现花屏现象
- previewMirrorFrontFacing
  - 是否在使用前置摄像头采集的时候镜像预览画面
- previewMirrorRearFacing
  - 是否在使用后置摄像头采集的时候镜像预览画面
- streamMirrorFrontFacing
  - 是否在使用前置摄像头采集的时候镜像编码画面
- streamMirrorRearFacing
  - 是否在使用后置摄像头采集的时候镜像编码画面
- position
  - 开启 PLMediaStreamingSession 的时候默认使用前置还是后置摄像头
- videoOrientation
  - 开启 PLMediaStreamingSession 的时候默认使用哪个旋转方向

需要注意的是指定分辨率的 `sessionPreset` 例如 `AVCaptureSessionPreset1920x1080` 并非所有机型的所有摄像头均支持，在设置相应的采集分辨率之前请务必保证做过充分的机型适配测试，避免在某些机型使用该机型摄像头不支持的 `sessionPreset`。另外，如果使用只指定采集质量的 `sessionPreset`，例如 `AVCaptureSessionPresetMedium`，那系统会根据当前摄像头的支持情况使用相应质量等级的分辨率进行采集。

<a id="6.1.2"></a>
### 6.1.2 音频采集参数

#### 自定义音频采集参数

当前的 `PLAudioCaptureConfiguration` 中可自行设定的参数有

- channelsPerFrame
  - 采集时的声道数，默认为 1，并非所有采集设备都支持多声道数据的采集，可以通过检查 [AVAudioSession sharedInstance].maximumInputNumberOfChannels 得到当前采集设备支持的最大声道数。

<a id="6.1.3"></a>
### 6.1.3 视频编码参数

当不确定视频编码具体的参数该如何设定时，你可以选择 SDK 内置的几种视频编码质量。

#### Quality 的对比


| Quality | VideoSize | FPS | ProfileLevel | Video BitRate(Kbps)|
|---|---|---|---|---|
|kPLVideoStreamingQualityLow1|272x480|24|Baseline AutoLevel|128|
|kPLVideoStreamingQualityLow2|272x480|24|Baseline AutoLevel|256|
|kPLVideoStreamingQualityLow3|272x480|24|Baseline AutoLevel|512|
|kPLVideoStreamingQualityMedium1|368x640|24|High AutoLevel|512|
|kPLVideoStreamingQualityMedium2|368x640|24|High AutoLevel|768|
|kPLVideoStreamingQualityMedium3|368x640|24|High AutoLevel|1024|
|kPLVideoStreamingQualityHigh1|720x1280|24|High AutoLevel|1024|
|kPLVideoStreamingQualityHigh2|720x1280|24|High AutoLevel|1280|
|kPLVideoStreamingQualityHigh3|720x1280|24|High AutoLevel|1536|

#### 自定义编码参数

当前的 `PLVideoStreamingConfiguration` 中可自行设定的参数有

- videoProfileLevel
  - H.264 编码时对应的 profile level 影响编码压缩算法的复杂度和编码耗能。设置的越高压缩率越高，算法复杂度越高，相应的可能带来发热量更大的情况
- videoSize
  - 编码的分辨率，对于采集到的图像，编码前会按照这个分辨率来做拉伸或者裁剪
- expectedSourceVideoFrameRate
  - 预期视频的编码帧率，这个数值对编码器的来说并不是直接限定了 fps, 而是给编码器一个预期的视频帧率，最终编码的视频帧率，是由实际输入的数据决定的
- videoMaxKeyframeInterval
  - 两个关键帧的帧间隔，一般设置为 FPS 的三倍
- averageVideoBitRate
  - 平均的编码码率，设定后编码时的码率并不会是恒定不变，静物较低，动态物体会相应升高
- videoEncoderType
  - H.264 编码器类型，默认采用 `PLH264EncoderType_AVFoundation` 编码方式，在 iOS 8 及以上的系统可采用 `PLH264EncoderType_VideoToolbox`，编码效率更高。

`PLMediaStreaming` 为了防止编码参数设定失败而导致编码失败，出现推流无视频的情况，依据 videoProfileLevel 限定了其他参数的范围，该限定范围针对 Quality 生成的配置同样有效。参见以下表格：

| ProfileLevel | Max VideoSize | Max FPS | Max Video BitRate(Mbps) |
|---|---|---|---|
| Baseline 30 | (720, 480) | 30 | 10 |
| Baseline 31 | (1280, 720) | 30 | 14 |
| Baseline 41 | (1920, 1080) | 30 | 50 |
| Main 30 | (720, 480) | 30 | 10 |
| Main 31 | (1280, 720) | 30 | 14 |
| Main 32 | (1280, 1024) | 30 | 20 |
| Main 41 | (1920, 1080) | 30 | 50 |
| High 40 | (1920, 1080) | 30 | 25 |
| High 41 | (1920, 1080) | 30 | 62.5 |

#### 码率、fps、分辨对清晰度及流畅度的影响

对于码率（BitRate）、FPS（frame per second）、分辨率（VideoSize）三者的关系，有必要在这里做一些说明，以便你根据自己产品的需要可以有的放矢的调节各个参数。

一个视频流个人的感受一般来说会有卡顿、模糊等消极的情况，虽然我们都不愿意接受消极情况的出现，但是在 UGC 甚至 PGC 的直播场景中，都不可避免的要面对。因为直播推流实时性很强烈，所以为了保证这一实时性，在网络带宽不足或者上行速度不佳的情况下，都需要做出选择。

要么选择更好的流程度但牺牲清晰度（模糊），要么选择更好的清晰度但牺牲流畅度（卡顿），这一层的选择大多由产品决定。

一般来说，当选定了一个分辨率后，推流过程中就不会对分辨率做变更，但可以对码率和 FPS 做出调节，从而达到上述两种情况的选择。

| 效果 | 码率 | FPS |
|---|---|---|
| 流畅度 | 负相关 | 正相关 |
| 清晰度 | 正相关 | 负相关 |

通过这个关联，我们就可以容易的知道该如何从技术层面做出调整。在追求更好的流畅度时，我们可以适当降低码率，如果 FPS 已经较高（如 30）时，可以维持 FPS 不变更，如果此时因为码率太低而画面无法接受，可以再适当调低 FPS；在追求更清晰的画质时，可以提高码率，FPS 调节至 24 左右人眼大多还会识别为流畅，如果可以接受有轻微卡顿，那么可以将 FPS 设置的更低，比如 20 甚至 15。

总之，这三者之间一起构建其了画面清晰和视频流畅的感觉，但最终参数是否能满意需要自己不断调整和调优，从而满足产品层面的需求。

<a id="6.1.4"></a>
### 6.1.4 音频编码参数

相比于视频繁杂的参数，当前 `PLAudioStreamingConfiguration` 提供的参数较为简单，当前音频编码最终输出为 AAC-LC。

Quality 的对比：

| Quality | Audio BitRate(Kbps) |
|---|---|
|kPLAudioStreamingQualityHigh1|64|
|kPLAudioStreamingQualityHigh2|96|
|kPLAudioStreamingQualityHigh3|128|

<a id="6.1.5"></a>
### 6.1.5 切换视频配置

为了满足推流中因网络变更，网络拥塞等情况下对码率、FPS 等参数的调节，`PLMediaStreamingSession` 提供了重置编码参数的方法，因为在重置编码器时会重新发送编码参数信息，可能触发播放器重置解码器或者清除缓存的操作（依据播放器自身行为而定），所以推流中切换编码参数时，观看短可能出现短暂（但视觉可感知）的卡顿。因此建议不要频繁的切换编码参数，避免因此带来的播放端体验问题。

- 在推流前、推流中、推流结束后调用 `- (void)reloadVideoStreamingConfiguration:(PLVideoStreamingConfiguration *)videoStreamingConfiguration;` 来重置 configuration

需要注意的是，通过 reload 方法重置 configuration 时，需要确保传递的 configuration 与当前 session 已经持有的不是一个对象。

<a id="6.1.6"></a>
### 6.1.6 建议编码参数

提示：以下为建议值，可根据产品需求自行更改调节。

UGC 场景，因为主播方所在的网络环境参差不齐，所以不易将码率设置的过高，此处我们给出建议设定

- WiFi: video Medium1 或者自定义编码参数时设定码率为 400~500Kbps
- 3G/4G: video Low2 或者自定义编码参数时设定码率为 200~300Kbps

PGC 场景，因为主播方所在网络一般都会有较高的要求，并且主播网络质量大多可以保障带宽充足，此处我们给出建议设定

- WiFi: video High1 或者自定义编码参数时设定码率为 1000~1200Kbps
- 3G/4G: video Medium2 或者自定义编码参数时设定码率为 600~800Kbps

对于 PGC 中的 3G/4G 场景，假定 PGC 时会配备较好的外置热点保证上行带宽充足。

<a id="6.1.7"></a>
### 6.1.7 如何只推音频

当你只需要推送音频时，并不需要额外的增加代码，只需要在创建 `PLMediaStreamingSession` 时，只传入 `PLAudioStreamingConfiguration` 和 `PLAudioCaptureConfiguration` 对象即可，这样 `PLMediaStreamingSession` 就不会在内部创建视频采集和编码的相关内容，推流时也只会发音频配置信息和音频数据。

<a id="6.1.8"></a>
### 6.1.8 返听

`返听`又被称之为`耳返`，指声音通过主播的麦克风被录入之后，立即从主播的耳机中播出来。返听功能如果搭配音效功能一起使用，可以让主播听到经音效处理后（如加入混响效果）的自己的声音，会有一种独特感觉。

返听功能可通过 `PLMediaStreamingSession` 的 `playback` 属性进行开启或关闭。注意，只有在推流进行时，返听功能才会起作用。因为只有开始推流之后，SDK 才会打开麦克风并开始录音。

此外，建议通过业务逻辑禁止主播在没有插上耳机的情况下使用返听功能。虽然 SDK 允许用户即便没有插入耳机却照样可以开启返听，但那并不意味着我们建议你这么做。因为在 iPhone 没有接入耳机的时候开启返听，iPhone 的麦克风录入的声音会从 iPhone 的扬声器中立即播放出来，从而再次被麦克风录入，如此反复几秒后将变成尖锐的电流音。想象一下你在 KTV 把话筒凑到音响附近后听到的令人不快的刺耳声音吧。因此，我们强烈建议开发者在业务逻辑层进行判定，当主播开启返听功能时，如果拔掉耳机, 请将 `playback` 属性设为 `NO` 以关闭返听功能。

<a id="6.1.9"></a>
### 6.1.9 音效

SDK 内置的音效模块会对主播通过麦克风录入的声音进行处理，从而让人听起来有不一样的感觉。例如加入 “回声” 音效后，主播的声音听起来就好像置身于空旷的讲堂一般；加入 “混响” 音效后，主播的声音听起来则更浑厚有力。

音效会影响`返听`功能，经过音效处理后的声音将被主播自己的耳机播放，音响产生的效果也会被推流出去，从而被观众听到。

SDK 的音效功能是对 iOS 的 Audio Unit 进行的封装，使开发者可以抽身于 Audio Unit 复杂的 API 泥潭。音效的添加、修改、删除都可以通过操作下面这个属性进行：

``` Objective-C
@property (nonatomic, strong) NSArray<PLAudioEffectConfiguration *> *audioEffectConfigurations;
```
 
这是一个由 `PLAudioEffectConfiguration` 对象构成的数组，每一个 `PLAudioEffectConfiguration` 对象对应一种音效。如果你需要同时开启多个音效，只需像如下示例把它们全部放在一个数组中即可：

``` Objective-C
mediaStreamingSession.audioEffectConfigurations = @[effect0, effect1, effect2, ...];
```

如果你想删除某个音效，只需要重新构造一个数组，令它唯独不包含那个你想要删除的音效,然后再重新赋值该属性即可。如果你想关闭音效功能，只需要设置一个空数组，或设置 nil 即可。注意，对音效的操作是立即生效的，不需要重启推流。

构成数组的元素必须是 `PLAudioEffectConfiguration` 对象或它的子类的对象。SDK 提供了众多的配置对象供你选择,这些配置对象全部都是 `PLAudioEffectConfiguration` 的子类对象。每一种配置对象往往对应一种 `kAudioUnitType_Effect` 类型的 Audio Unit。如果你熟悉 Audio Unit，你会发现每一种 `kAudioUnitType_Effect` 的子类型，SDK 中都有一种配置类与之对应。
例如，sub type 为 `kAudioUnitSubType_Reverb2` 的 Audio Unit 在 SDK 中对应的配置类为 `PLAudioEffectReverb2Configuration`。而 Reverb2 的所有可使用的属性都可以在 `PLAudioEffectReverb2Configuration` 的成员变量中找到。你可以通过

``` Objective-C
id effect = [PLAudioEffectReverb2Configuration defaultConfiguration];
```

来构造一个所有成员变量都取默认值的配置对象。然后，通过类似

``` Objective-C
...

effect.gain = 0.8; 
effect.decayTimeAt0Hz = 1.2; 

...
```

来设置构造好的配置对象的属性。

至此，你应该已经明白了如何构造任何你想要的音效配置了。

- 首先,你需要查找 Apple 的 Audio Unit 的 API 文档,在所有 type 为
kAudioUnitType\_Effect 的 Audio Unit 中挑选一个 sub type，作为你想要的音效，然后根据 sub type 的名字找到 SDK 中对应的配置类。例如，在之前的例子中，sub type 为 kAudioUnitSubType\_Reverb2，因此配置类的名字为 PLAudioEffectReverb2Configuration。
- 之后调用 [PLAudioEffectXXXConfiguration defaultConfiguration] 来
构造一个全部属性为默认值的配置对象。
- 调整属性的值，来得到你想要的音效效果。
- 重复之前的步骤，直到构造出所有你需要的音效配置对象，并全部装入一个
数组。
- 通过设置 mediaStreamingSession.audioEffectConfigurations =
@[...]; 来让你之前准备的音效配置生效。

除了与 Audio Unit 一一对应的音效配置类，我们还提供了预设的音效类，PLAudioEffectModeConfiguration。你可以通过如下三个方法获取三种预设混响音效配置

``` Objective-C
[PLAudioEffectModeConfiguration reverbLowLevelModeConfiguration];

[PLAudioEffectModeConfiguration reverbMediumLevelModeConfiguration];

[PLAudioEffectModeConfiguration reverbHeightLevelModeConfiguration];
```

mediaStreamingSession.audioEffectConfigurations 这个数组里的音效配置对象是有顺序的，这个顺序最终将和 Audio Unit 在 AUGraph 中的顺序保持一致。如果你不了解 Audio Unit 在 AUGraph 中的顺序对最终产生的音效有什么影响，其实也无妨，实际上你随意地将音频对象排列最终产生的效果用肉耳听起来差别也不大（若你有更高的追求，那么你需要理解这个顺序的意义）。

<a id="6.1.10"></a>
### 6.1.10 混音

当前版本的 SDK 允许主播在推流的同时，播放本地音频文件。主播麦克风录入的声音，在经过音效处理(如果有)后，会与音频文件的内容混合，然后推流出去让观众听到。同时，如果主播开启了返听功能，亦可以从耳机听到音频文件播放出的声音。

场景举例：直播中，主播唱歌，通过播放音频文件来获得伴奏。结合返听功能，主播可以从耳机听到伴奏音乐以及自己的唱出的歌声。同时观众最终听到的也是混合了伴奏的主播的歌声。

要开启音频文件播放功能,首先需要构造播放器实例,通过如下方法构造

``` Objective-C
PLAudioPlayer *player = [mediaStreamingSession audioPlayerWithFilePath:@"audio file path"];
```

之后，所有与音频文件播放相关的功能就都基于 `player` 进行了。

当你播放完音频文件之后，且不打算再使用该功能时，需要释放掉 player，可通过调用

``` Objective-C
[mediaStreamingSession closeCurrentAudio];
```

来释放之前获取的播放器实例。

**注意：播放器使用完必须关闭，否则它将一直占用着资源（例如音频文件的句柄）。**

每当音频文件播放完毕，会回调如下方法询问你是否把该音频文件重新播放一遍

``` Objective-C
- (BOOL)didAudioFilePlayingFinishedAndShouldAudioPlayerPlayAgain:(PLAudioPlayer *)audioPlayer
```

该方法可以让你知道音频文件什么时候播放完毕，同时通过返回一个 BOOL 值，来控制播放器的行为。例如，如果你想做单曲循环效果，可以如此实现该方法

``` Objective-C
- (BOOL)didAudioFilePlayingFinishedAndShouldAudioPlayerPlayAgain:(PLAudioPlayer *)audioPlayer {
    return YES; 
}
```

如果你想实现顺序播放效果，可以如此实现该方法

``` Objective-C
- (BOOL)didAudioFilePlayingFinishedAndShouldAudioPlayerPlayAgain:(PLAudioPlayer *)audioPlayer {
    audioPlayer.audioFilePath = @"/path/to/next/audio/file/name.mp3";
    return YES; 
}
```

<a id="6.1.11"></a>
### 6.1.11 外部采集音视频并导入
我们强烈推荐对音视频没有太多了解的开发者使用 `PLMediaStreaming` 提供的 API 进行开发，如果您对音视频数据的采集和处理有更多的需求，那么可以使用 `PLStreaming` 或 `PLRTCStreaming` 提供的 API 进行开发，不过在进行开发之前请确保您已经掌握了包括音视频采集及处理等相关的基础知识。如概述所述，`PLRTCStreaming` 在 `PLStreaming` 基础上增加连麦功能，因此，如果您需要连麦功能，可以使用`PLRTCStreaming`，否则，直接使用`PLStreaming` 即可。

`PLStreaming` 提供如下 API 来支持开发者导入音视频到 SDK 中：

```
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer completion:(void (^)(BOOL success))handler;
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer;
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer completion:(void (^)(BOOL success))handler;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer completion:(void (^)(BOOL success))handler;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer withChannelID:(const NSString *)channelID completion:(void (^)(BOOL success))handler;
- (void)pushAudioBuffer:(AudioBuffer *)buffer asbd:(const AudioStreamBasicDescription *)asbd;
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd completion:(void (^)(BOOL success))handler;
```

`PLRTCStreaming`提供如下 API 来支持开发者导入音视频到 SDK 中：

```
- (void)pushPixelBuffer:(CVPixelBufferRef)pixelBuffer completion:(void (^)(BOOL success))handler;
- (void)pushAudioBuffer:(AudioBuffer *)audioBuffer asbd:(const AudioStreamBasicDescription *)asbd completion:(void (^)(BOOL success))handler;
```
注意，受连麦接口所限，目前 `PLRTCStreaming` 仅支持 `kCVPixelFormatType_420YpCbCr8BiPlanarFullRange` 格式的 pixelBuffer 数据。




<a id="6.2"></a>
## 6.2 DNS 优化

在大陆一些地区或特别的运营商线路，存在较为普遍的 DNS 劫持问题，而这对于依赖 DNS 解析 rtmp 流地址的 `PLStreaming` 来说是很糟糕的情况，为了解决这一问题，我们引入了 `HappyDNS` 这个库，以便可以实现 httpDNS，localDNS 等方式解决这类问题。

<a id="6.2.1"></a>
### 6.2.1 HappyDNS

你可以[点击这里](#https://github.com/qiniu/happy-dns-objc) 跳转到 `HappyDNS` 的 GitHub 主页，在那里查看更详细的介绍和使用。

默认情况下，你所创建的 `PLMediaStreamingSession` 对象，内部持有一个 `HappyDNS` 对应的 manager 对象，来负责处理 DNS 解析。

如果你期望按照不同的规则来做 DNS 解析，那么你可以在创建 `PLMediaStreamingSession` 前，创建好自己的 `QNDnsManager` 对象，我们在 `PLMediaStreamingSession` 中提供了一个 init 方法满足这类需求，你可以传递自己的 `QNDnsManager` 对象给 `PLMediaStreamingSession`，从而定制化 DNS 解析。

<a id="6.3"></a>
## 6.3 流状态获取

在 `PLMediaStreaming` 中，通过反馈 `PLMediaStreamingSession` 的状态来反馈流的状态。我们定义了几种状态，确保 `PLMediaStreamingSession` 对象在有限的几个状态间切换，并可以较好的反应流的状态。

| 状态名 | 含义 |
|---|---|
| PLStreamStateUnknow | 初始化时指定的状态，不会有任何状态会跳转到这一状态 |
| PLStreamStateConnecting | RTMP 流链接中的状态 |
| PLStreamStateConnected | RTMP 已连接成功时的状态 |
| PLStreamStateDisconnecting | RTMP 正常断开时，正在断开的状态 |
| PLStreamStateDisconnected | RTMP 正常断开时，已断开的状态 |
| PLStreamStateAutoReconnecting | 正在等待自动重连状态 | 
| PLStreamStateError | 因非正常原因导致 RTMP 流断开，如包发送失败、流校验失败等 |

<a id="6.3.1"></a>
### 6.3.1 state 状态回调

state 状态对应的 Delegate 回调方法是

``` Objective-C
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStateDidChange:(PLStreamState)state;
```

只有在正常连接，正常断开的情况下跳转的状态才会触发这一回调。所谓正常连接是指通过调用 `-startStreamingWithFeedback:` 方法使得流连接的各种状态，而所谓正常断开是指调用 `-stopStreaming` 方法使得流断开的各种状态。所以只有以下四种状态会触发这一回调方法。

- PLStreamStateConnecting
- PLStreamStateConnected
- PLStreamStateDisconnecting
- PLStreamStateDisconnected

<a id="6.3.2"></a>
### 6.3.2 error 状态回调

error 状态对应的 Delegate 回调方法是

``` Objective-C
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error;
```

除了调用 `-stopStreaming` 之外的所有导致流断开的情况，都被归属于非正常断开的情况，此时就会触发该回调。对于错误的处理，我们不建议触发了一次 error 后就停掉，最好可以在此时尝试有限次数的重连，详见[重连](#5.4.1)小节。

<a id="6.3.3"></a>
### 6.3.3 status 状态回调

除了 state 作为流本身状态的切换，我们还提供了流实时情况的反馈接口

``` Objective-C
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status;
```

默认情况下，该回调每隔 3s 调用一次，每次包含了这 3s 内音视频的 fps 和总共的码率（注意单位是 kbps）。你可以通过 `PLMediaStreamingSession` 的 statusUpdateInterval 属性来读取或更改这个回调的间隔。

<a id="6.3.4"></a>
### 6.3.4 产品层面的反馈

status 的状态回调可以很好的反应发送情况，及网络是否流畅，是否拥塞。所以此处可以作为产品层面对弱网情况决策的一个入口。

一般的，当 status.videoFPS 比预设的 FPS 明显小时（小于等于 20%），并且维持几秒都是如此，那么就可以判定为当前主播所在的网络为弱网环境，可以给主播视觉上的提示，或者主动降低编码配置，甚至直接断掉主播的流，这些都由具体的产品需求而定，而此处只是给出一个入口的提示和建议。

<a id="6.4"></a>
## 6.4 连麦参数配置及状态获取

<a id="6.4.1"></a>
### 6.4.1 设置连麦者的画面大小和位置
对于主播来说，其视频数据先后经过采集、连麦、合流、推流等阶段，每个阶段的画面尺寸由如下配置确定：

- 采集：采集的视频画面尺寸由 PLVideoCaptureConfiguration 的 sessionPreset 决定；
- 连麦：连麦的视频画面尺寸由 PLRTCConfiguration 的 videoSizePreset 决定，videoSizePreset 的默认值为 PLRTCVideoSizePreset368x640；       
- 合流：合流的画面尺寸由 PLRTCConfiguration 的 mixVideoSize 决定，若 mixVideoSize 未设置，则与推流的画面尺寸保持一致；主播在合流的画面中的大小和位置由 PLRTCConfiguration 的 localVideoRect 属性决定，若 localVideoRect 未设置，则默认主播画面大小与 mixVideoSize 一致；    
- 推流：推流的视频画面尺寸由 PLVideoStreamingConfiguration 的 videoSize 决定；

用一个 CGRect 来表示连麦者的画面在合流的画面中的大小和位置，其中 origin.x 表示水平方向相对于合流的画面的像素，origin.y 表示垂直方向相对于合流的画面的像素，size.width 表示连麦者的画面的宽度，size.height 表示连麦者的画面的高度。

假设合流的画面尺寸是 480 x 640，连麦者的画面的配置是：'CGRectMake(330, 480, 90, 160)'，那么，实际的效果是：
连麦者的画面的大小是：90 x 160，连麦者的画面的位置是：x 坐标位于合流的画面从左到右的 330 像素处，y 坐标位于合流的画面从上往下的 480 像素处。

PLRTCVideoRender 中的 mixOverlayRect 是用来设置该用户在合流画面中的大小和位置。

```
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;

/// @abstract 连麦时，取消远端用户（以 userID 标识）的视频渲染到 renderView 后的回调，可在该方法中将 renderView 从界面上移除。本接口在主队列中回调。
///           该接口所回调的 remoteView，即为通过
///           - (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session
///                        firstVideoFrameDecodedOfUserID:(NSString *)userID;
///           接口传入的 PLRTCVideoRender 对象中的 renderView
/// @see PLRTCVideoRender
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;

```

<a id="6.4.2"></a>
### 6.4.2 连麦状态回调
连麦状态回调：

```
/// @abstract 连麦状态已变更的回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcStateDidChange:(PLRTCState)state;
```

连麦状态包括以下几个：

```
///连麦状态
typedef NS_ENUM(NSUInteger, PLRTCState) {
    /// 未 init 时的初始状态
    PLRTCStateConferenceUnInit = 0,
    ///  init 成功时的状态
    PLRTCStateConferenceInited,
    /// 已进入到连麦的状态
    PLRTCStateConferenceStarted,
    /// 连麦已结束的状态
    PLRTCStateConferenceStopped
};
```
<a id="6.4.3"></a>
### 6.4.3 连麦视频首帧解码后的回调

```
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;     
```       
<a id="6.4.4"></a>
### 6.4.4 连麦视频取消渲染的回调

```   
/// @abstract 连麦时，取消远端用户（以 userID 标识）的视频渲染到 renderView 后的回调，可在该方法中将 renderView 从界面上移除。本接口在主队列中回调。
///           该接口所回调的 remoteView，即为通过
///           - (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session
///                        firstVideoFrameDecodedOfUserID:(NSString *)userID;
///           接口传入的 PLRTCVideoRender 对象中的 renderView
/// @see PLRTCVideoRender
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;

```
<a id="6.4.5"></a>
### 6.4.5 连麦错误状态回调
```
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error;
```
可通过打印 error 错误码来了解具体的错误信息，错误码定义在 `PLTypeDefines.h` 文件中。

<a id="6.4.6"></a>
### 6.4.6 连麦被踢出房间的回调
```
/// @abstract 被 userID 从房间踢出
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didKickoutByUserID:(NSString *)userID;
```
<a id="6.4.7"></a>
### 6.4.7 连麦用户加入房间/离开房间的回调
```
/// @abstract  userID 加入房间
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didJoinConferenceOfUserID:(NSString *)userID;

/// @abstract userID 离开房间
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLeaveConferenceOfUserID:(NSString *)userID;
```

<a id="6.4.8"></a>
### 6.4.8 纯音频连麦
实现纯音频很简单，调用 

```
- (void)startConferenceWithRoomName:(NSString *)roomName
                             userID:(NSString *)userID
                          roomToken:(NSString *)roomToken
                   rtcConfiguration:(PLRTCConfiguration *)rtcConfiguration;
```
时 rtcConfiguration 配置 PLRTCConferenceType 为 `PLRTCConferenceTypeAudio` 即可。

<a id="6.4.9"></a>
### 6.4.9 带宽占用优化
连麦互动相比于原有的单向推流＋播放，增加了更多的带宽占用，因此需要合理的分配推流&连麦的参数，以达到最好的效果。

- 对于主播而言，同时需要 “推流”＋“连麦”，因此，主播端的带宽占用由三部分决定，“推流的码率” ＋ “连麦上行码率” ＋ “连麦下行的码率”

- 推流的视频码率可以在 PLVideoStreamingConfiguration 中配置，具体见 5.1.3 小节；

- 连麦的码率设置可以查看 rtcMinVideoBitrate 和 rtcMaxVideoBitrate 属性说明；

<a id="6.4.10"></a>
### 6.4.10 降低功耗
对于主播而言，同时需要 “推流”＋“连麦”，因此对手机的性能提出了更高的要求，我们也可以通过合理的参数配置，来适当减轻主播端的功耗压力。

- 合理配置连麦者的画面尺寸

  由于连麦对象的画面是小窗口，因此，对于连麦者，可以考虑使用比主播小一些的画面尺寸，这样可以显著降低主播端对连麦画面的剪裁压力，该画面尺寸可以在 PLRTCConfiguration 中设置；


- 合理配置主播端的合流参数

  主播端配置连麦合流画面的尺寸尽量接近连麦者的画面尺寸，比如：如果连麦者输出的画面尺寸是 320 x 240 ，那么主播端配置该对象合流的尺寸就用 320 x 240 或者小于该尺寸的值，这样可以避免或者减少主播端对连麦画面进行拉伸。合流画面的尺寸可以在 rtcMixOverlayRectArray 中设置；

- 适当降低连麦帧率

  连麦对讲的时候，画面很少剧烈运动，一般 15～20 帧的帧率足够了，降低帧率，可以显著降低 CPU 的处理压力，从而优化功耗。视频采集的帧率可以在 PLVideoCaptureConfiguration 中设置。

<a id="6.5"></a>
## 6.5 网络异常处理

直播中，网络异常的情况比我们能意料到的可能会多不少，常见的情况一般有

- 网络环境切换，比如 3G/4G 与 Wi-Fi 环境切换
- 网络不可达，网络断开属于这一类
- 带宽不足，可能触发发送失败
- 上行链路不佳，直接影响流发送速度

作为开发者我们不能乐观的认为只要是 Wi-Fi 网就是好的，因为即便是 Wi-Fi 也有可能因为运营商上行限制，共享网络带宽等因素导致以上网络异常情况的出现。

为何在直播中要面对这么多的网络异常情况，而在其他上传/下载中很少遇到的，这是因为直播对实时性的要求使得它不得面对这一情况，即无论网络是否抖动，是否能一直良好，直播都要尽可能是可持续，可观看的状态。

<a id="6.5.1"></a>
### 6.5.1 重连

`PLMediaStreamingSession` 内置了自动重连功能，但默认处于关闭状态。之所以默认关闭，一方面是考虑到 App 的业务逻辑场景多样而负责，对于直播重连的次数、时机、间隔都会有不同的需求，此时让开发者自己来决定是否重连，以及尝试重连的次数会更加合理；另一方面是兼容旧版本业务层面可能已实现的自动重连逻辑。

如果你想直接使用内置的自动重连功能，可通过将 `PLMediaStreamingSession` 的 `autoReconnectEnable` 属性设置为 `YES` 来开启，并需要注意如下几点：

- 自动重连次数上限目前设定为 3 次，重连的等待时间会由首次的 0~2s 之间逐步递增到第三次的 4~6s 之间
- 等待重连期间，`streamState` 处于 `PLStreamStateAutoReconnecting` 状态，业务层可根据该状态来更新用户界面
- 网络异常的 error Delegate 回调只有在达到最大重连次数后还未连接成功时才会被触发

若你想自己实现自动重连逻辑，可以利用以下网络异常所触发的 error Delegate 回调接口来添加相应的逻辑：

``` Objective-C
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error;
```

你可以在这个方法内通过重新调用 `-startStreamingWithFeedback:` 方法来尝试重连。此处建议不要立即重连，而是采用重连间隔加倍的方式，比如共尝试 3 次重连，第一次等待 0.5s, 第二次等待 1s, 第三次等待 2s，这样的方式主要考虑到弱网时网络带宽的缓解需要时间，而加倍重连可以更容易在网络恢复的时候连接，而非在网络已经拥塞时还不断做无用功的重连。

`PLMediaStreamingSession` 内置了网络切换监测功能，但默认处于关闭状态。开启后，网络在 WWAN(3G/4G) 和 Wi-Fi 之间相互切换时，我们提供了一个回调 `connectionChangeActionCallback` 属性，它的函数签名如下

``` Objective-C
typedef BOOL(^ConnectionChangeActionCallback)(PLNetworkStateTransition transition);
```

该回调函数传入参数为当前网络的切换状态 `PLNetworkStateTransition`。 返回值为布尔值，YES表示在某种切换状态下允许推流自动重启，NO则代表该状态下不应自动重启。例如在 `PLNetworkStateTransitionWWANToWiFi` 状态，即网络从 3G/4G 切换到 Wi-Fi 后，基于节省流量等需求考虑，你可能需要进行一次快速的重连，使得数据可以通过 Wi-Fi 网络发送，此时返回 `YES` 即可。反之，如果推流过程中 Wi-Fi 断掉切换到 3G/4G，此时在未征得用户同意使用移动流量推流时，可返回 `NO` 不自动重启推流。以下为参考逻辑

``` Objective-C
session.connectionChangeActionCallback = ^(PLNetworkStateTransition transition) {
        switch (transition) {
            case PLNetworkStateTransitionWWANToWiFi:
                return YES;
                
            case PLNetworkStateTransitionWiFiToWWAN:
                return NO;
                
            default:
                break;
        }
        
        return NO;
    };
```

如果该属性未被初始化赋值，则 SDK 内部出于节省用户移动网络流量的目的，会默认在 Wi-Fi 切换到 3G/4G 时断开推流。此时，你可以自行监听网络状态，调用 `-restartStreamingWithFeedback:` 方法来快速重连。

<a id="6.5.2"></a>
### 6.5.2 弱网优化

移动直播过程中存在着各种各样的网络挑战。由于无线网络相对于有线网络，可靠性较低，会经常遇到信号覆盖不佳导致的高丢包、高延时等问题，特别是在用网高峰期，由于带宽有限，网络拥塞的情况时有发生。自 [v2.1.3](https://github.com/pili-engineering/PLMediaStreamingKit/releases/tag/v2.1.3) 起，`PLMediaStreaming` 内置了一套弱网优化方案，可以满足以下两个诉求：

- 能动态地适应网络质量，即在质量不佳的网络下，能够自动下调视频编码的输出码率和帧率，而当网络质量恢复稳定时，输出码率和帧率也应得到相应回升，并能在调节过程中使得码率与帧率变化相对平稳。
- 在直播端网络质量稳定时，确保编码器输出的码率和帧率恒定在一个期望的最高值，以提供良好的清晰度和流畅度。

这套弱网优化方案包含两个工作模块：

- 自适应码率模块，能够在期望码率与设定的最低码率间做出调节，适应网络抖动引发的数据带宽变化。
- 动态帧率模块，能够在期望帧率与一个最低帧率间做出调节，动态调整输出的视频数据量。

这两个模块可并行工作，可以单独开启或关闭，开发者可根据自己的业务场景来决定该方案的应用形态。一般情况下，如果开发者想使用该解决方案，建议将两个调节模块都开启，可达到我们测试的最佳效果。利用码率与帧率调整相互配合作用，一方面有效控制网络波动情况下的音视频数据发送量，缓解网络拥塞，同时又能给播放端带来流畅的观看体验；另一方面在网络质量恢复时能够确保音视频的码率帧率是以设定的最优质量配置进行推流，并且能使不同码率帧率配置切换时以一种更为平滑的方式进行，不会给观看端带来画质波动的突兀感。

自适应码率调节可以通过 `PLMediaStreamingSession` 的如下接口开启:

``` Objective-C
- (void)enableAdaptiveBitrateControlWithMinVideoBitRate:(NSUInteger)minVideoBitRate;
```
其关闭接口为:

``` Objective-C
- (void)disableAdaptiveBitrateControl;
```

开启该机制时，需设置允许向下调节的最低码率（注意其单位为 bps，如设置最低为 200 Kbps，应传入参数值为 200*1024），以便使自动调整后的码率不会低于该范围。该机制根据网络吞吐量及 TCP 发送时间来调节推流的码率，在网络带宽变小导致发送缓冲区数据持续增长时，SDK 内部将适当降低推流码率，若情况得不到改善，则会重复该过程直至平均码率降至用户设置的最低值；反之，当一段时间内网络带宽充裕，SDK 将适当增加推流码率，直至达到预设的推流码率。

动态帧率的开关为 `PLMediaStreamingSession` 的 `dynamicFrameEnable` 属性，开启后，自动调整的最大帧率不会超过预设在 `videoStreamingConfiguration` 配置中的 `expectedSourceVideoFrameRate`，最低不会小于 10 FPS。

默认情况下，这两个模块处于关闭状态，是为了兼容旧版本中开发者可能已自行实现的弱网调节机制。若开发者想使用我们的内置方案，请确保您自定义的机制已被关闭。

<a id="6.6"></a>
### 6.6 水印和美颜

<a id="6.6.1"></a>
#### 6.6.1 水印

`PLMediaStreaming` 支持内置水印功能，你可以根据自己的需要添加水印或移除水印，并且能够自由设置水印的大小和位置。需要注意的是水印功能对预览和直播流均生效。

添加水印
```Objective-C
-(void)setWaterMarkWithImage:(UIImage *)wateMarkImage position:(CGPoint)position;
```

该方法将为直播流添加一个水印，水印的大小由 `wateMarkImage` 的大小决定，位置由 position 决定，需要注意的是这些值都是以采集数据的像素点为单位的。例如我们使用 `AVCaptureSessionPreset1280x720` 进行采集，同时 `wateMarkImage.size` 为 `(100, 100)` 对应的 `origin` 为 `(200, 300)`，那么水印的位置将在大小为 `1280x720` 的采集画幅中位于 `(200, 300)` 的位置，大小为 `(100, 100)`。

移除水印
```Objective-C
-(void)clearWaterMark;
```
该方法用于移除已添加的水印

<a id="6.6.2"></a>
#### 6.6.2 美颜

'PLMediaStreaming' 支持内置美颜功能，你可以根据自己的需要选择开关美颜功能，并且能够自由调节包括美颜，美白，红润等在内的参数。需要注意的是水印功能对预览和直播流均生效。

按照默认参数开启或关闭美颜
```Objective-C
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;
```

设置美颜程度，范围为 0 ~ 1
```Objective-C
-(void)setBeautify:(CGFloat)beautify;
```

设置美白程度，范围为 0 ~ 1
```Objective-C
-(void)setWhiten:(CGFloat)whiten;
```

设置红润程度，范围为 0 ~ 1
```Objective-C
-(void)setRedden:(CGFloat)redden;
```

<a id="6.7"></a>
### 6.7 录屏推流

`PLStreaming` 支持 iOS 10 新增的录屏推流 ([`ReplayKit Live`](https://developer.apple.com/reference/replaykit)) 功能，开发者可通过构建 [App Extension](https://developer.apple.com/app-extensions) 来调用推流 API 实现实时游戏直播等功能。需要注意的是，实时直播需要游戏或 App 本身实现对 `ReplayKit` 的支持。

<a id="6.7.1"></a>
### 6.7.1 创建 Broadcast Upload Extension

在原有直播 App 中添加一个类型为 `Broadcast Upload Extension` 的新 Target，如图所示：

![](https://raw.githubusercontent.com/pili-engineering/PLStreamingKit/master/screensnap/broadcast-extension-create.png)

Xcode 会额外自动创建一个类型为 `Broadcast UI Extension` 的 Target，用于显示调用 `Broadcast Upload Extension` 的用户界面。

<a id="6.7.2"></a>
### 6.7.2 添加推流管理类

创建推流 API 调用管理类，添加头文件引用：

``` objectivec
#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
```

头文件参考

``` objectivec
#import <Foundation/Foundation.h>

#import <PLRTCStreamingKit/PLRTCStreamingKit.h>

@interface BroadcastManager : NSObject

@property (nonatomic, strong) PLStreamingSession *session;

+ (instancetype)sharedBroadcastManager;
- (PLStreamState)streamState;
- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer withChannelID:(const NSString *)channelID;

@end
```
类实现参考

``` objectivec
@interface BroadcastManager ()<PLStreamingSessionDelegate>

@end

@implementation BroadcastManager

static BroadcastManager *_instance;

- (instancetype)init
{
    if (self = [super init]) {
        [PLStreamingEnv initEnv];
        
        PLVideoStreamingConfiguration *videoConfiguration = [[PLVideoStreamingConfiguration alloc] initWithVideoSize:CGSizeMake(1280, 720) expectedSourceVideoFrameRate:24 videoMaxKeyframeInterval:24*3 averageVideoBitRate:1000*1024 videoProfileLevel:AVVideoProfileLevelH264High41];
        PLAudioStreamingConfiguration *audioConfiguration = [PLAudioStreamingConfiguration defaultConfiguration];
        audioConfiguration.inputAudioChannelDescriptions = @[kPLAudioChannelApp, kPLAudioChannelMic];
        
        self.session = [[PLStreamingSession alloc] initWithVideoStreamingConfiguration:videoConfiguration
                                                           audioStreamingConfiguration:audioConfiguration
                                                                                stream:nil];
        self.session.delegate = self;
        #warning 以下 pushURL 需替换为一个真实的流地址
        NSString *pushURL = nil;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.session startWithPushURL:[NSURL URLWithString:pushURL] feedback:^(PLStreamStartStateFeedback feedback) {
                if (PLStreamStartStateSuccess == feedback) {
                    NSLog(@"connect success");
                } else {
                    NSLog(@"connect failed");
                }
            }];
        });
    }
    return self;
}

+ (void)initialize
{
    _instance = [[BroadcastManager alloc] init];
}

- (PLStreamState)streamState
{
    return self.session.streamState;
}

- (void)pushVideoSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    [self.session pushVideoSampleBuffer:sampleBuffer];
}

- (void)pushAudioSampleBuffer:(CMSampleBufferRef)sampleBuffer withChannelID:(const NSString *)channelID
{
    [self.session pushAudioSampleBuffer:sampleBuffer withChannelID:channelID completion:nil];
}

+ (instancetype)sharedBroadcastManager
{
    return _instance;
}

// 实现其他必要的协议方法

- (void)streamingSession:(PLStreamingSession *)session didDisconnectWithError:(NSError *)error
{
    NSLog(@"error : %@", error);
}

- (void)streamingSession:(PLStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status
{
    NSLog(@"%@", status);
}

@end

```

注意 `PLAudioStreamingConfiguration` 实例生成时必需注册音频流来源

```objectivec
audioConfiguration.inputAudioChannelDescriptions = @[kPLAudioChannelApp, kPLAudioChannelMic];
```

其中 `kPLAudioChannelApp` 对应于 `RPSampleBufferTypeAudioApp`，是 ReplayKit Live 回调的 app 音频数据，`kPLAudioChannelMic` 对应于 `RPSampleBufferTypeAudioMic`，是 ReplayKit Live 回调的 mic 音频数据。之所以需要显示声明，是为了在 PLStreaming 在音频编码前将两路音频流进行混音。

在自动生成的 `SampleHandler.m` 中实现 `RPBroadcastSampleHandler` 协议部分方法如下：

```objectivec
- (void)processSampleBuffer:(CMSampleBufferRef)sampleBuffer withType:(RPSampleBufferType)sampleBufferType {
    if ([BroadcastManager sharedBroadcastManager].streamState == PLStreamStateConnected) {
        switch (sampleBufferType) {
            case RPSampleBufferTypeVideo:
                // Handle video sample buffer
                [[BroadcastManager sharedBroadcastManager] pushVideoSampleBuffer:sampleBuffer];
                break;
            case RPSampleBufferTypeAudioApp:
                // Handle audio sample buffer for app audio
                [[BroadcastManager sharedBroadcastManager] pushAudioSampleBuffer:sampleBuffer withChannelID:kPLAudioChannelApp];
                break;
            case RPSampleBufferTypeAudioMic:
                // Handle audio sample buffer for mic audio
                [[BroadcastManager sharedBroadcastManager] pushAudioSampleBuffer:sampleBuffer withChannelID:kPLAudioChannelMic];
                break;
                
            default:
                break;
        }
    }
}
```
<a id="6.7.3"></a>
### 6.7.3 一些注意点

如果你使用 CocoaPods 管理依赖库，可能会在编译 broadcast extension target 时遇到 link error，此时请检查 Podfile 里是否为 broadcast extension target 添加相应的依赖；或者可检查以下工程设置是否更改：

![](https://raw.githubusercontent.com/pili-engineering/PLStreamingKit/master/screensnap/extension-cocoapods.png)

<a id="6.8"></a>
## 6.8 纯连麦互动

为了满足纯连麦互动场景的需求，从 v2.2.1.7 开始，连麦 SDK 提供了一个全新的连麦核心类 PLRTCSession，提供灵活的接口，支持动态开关音视频采集、动态视频订阅、动态音视频发布等等。

<a id="6.8.1"></a>
### 6.8.1 添加并引用 PLRTCSession

在目标工程中，引用 `PLRTCSession.h`

```Objective-C
#import <PLRTCStreamingKit/PLRTCSession.h>
```

添加 session 属性

```Objective-C
@property (nonatomic, strong) PLRTCSession *session;
```


<a id="6.8.2"></a>
### 6.8.2 音视频采集对象及视频画面尺寸

`PLRTCSession` 中通过不同的 configuration 设置不同的采集配置信息，对应的有：

- `PLVideoCaptureConfiguration` 视频采集配置
- `PLAudioCaptureConfiguration` 音频采集配置

当前使用默认配置，之后可以深入研究按照自己的需求作更改

``` Objective-C
PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
PLAudioCaptureConfiguration *audioCaptureConfiguration = [PLAudioCaptureConfiguration defaultConfiguration];
```

*注意：采集的视频画面尺寸由 `PLVideoCaptureConfiguration` 的 `sessionPreset` 决定，而连麦的视频画面尺寸由 `PLRTCConfiguration` 的 `videoSizePreset ` 决定，若 `videoSizePreset ` 为 `PLRTCVideoSizePresetDefault`，则 videoSizePreset 的默认值为 PLRTCVideoSizePreset368x640*

<a id="6.8.3"></a>
### 6.8.3 PLRTCSession 初始化方法

若连麦中需使用音频发布或视频发布功能，则相对应的 configuration 配置不能为 nil

```Objective-C
- (instancetype)initWithVideoCaptureConfiguration:(PLVideoCaptureConfiguration *)videoCaptureConfiguration
                        audioCaptureConfiguration:(PLAudioCaptureConfiguration *)audioCaptureConfiguration;
```

#### 初始化 session 对象

``` Objective-C
self.session = [[PLRTCSession alloc] initWithVideoCaptureConfiguration:videoCaptureConfiguration audioCaptureConfiguration:audioCaptureConfiguration];
```

#### 初始化 session 参数 
``` Objective-C
[self.session setWithServerRegionID:PLRTC_SERVER_REGION_DEFAULT serverRegionName:@""];
```

#### 将预览视图添加为当前视图的子视图

```Objective-C
[self.view addSubview:_session.previewView];
```

#### 开启摄像头采集

```Objective-C
[self.session startVideoCapture];
```
*注意：开启摄像头采集后 `previewView` 才会有图像。*

<a id="6.8.4"></a>
### 6.8.4 连麦及其他相关操作

创建 roomToken、roomName 和 userID，其中roomToken 指的是连麦房间的 Token，由 App 服务器动态生成，要对应 roomName 和 userID，三个参数都设置正确才能正常连麦。

#### 开始连麦
  - 加入连麦房间后需要手动发布音视频

```Objective-C
- (void)startConferenceWithRoomName:(NSString *)roomName
                             userID:(NSString *)userID
                          roomToken:(NSString *)roomToken
                   rtcConfiguration:(PLRTCConfiguration *)rtcConfiguration;
```       
*注意：调用上述接口之前，务必成功调用 `setWithServerRegionID` 接口。*

#### 停止连麦
  - 停止连麦后，音视频会取消发布

```Objective-C
- (void)stopConference;
```
#### 踢人
  - 踢出指定 userID 的用户

```Objective-C
- (void)kickoutUserID:(NSString *)userID;
```

<a id="6.8.5"></a>
### 6.8.5 音视频发布和取消

- 发布视频

连麦开始（state 状态为 `PLRTCStateConferenceStarted`）后，发布本地的视频到房间中。

```Objective-C
- (void)publishLocalVideoWithCompletionHandler:(void (^)(NSError *))completionHandler;
```
*注意：completionHandler 的回调不一定在主线程中进行。*

- 取消视频发布

`stopConference` 取消发布视频时，SDK 内部会取消，不需要再主动调用该接口。

```Objective-C
- (void)unpublishLocalVideo;
```

- 发布音频

连麦开始（state 状态为 `PLRTCStateConferenceStarted`）后，发布本地的音频到房间中。

```Objective-C
- (void)publishLocalVideoWithCompletionHandler:(void (^)(NSError *))completionHandler;
```
*注意：completionHandler 的回调不一定在主线程中进行。*

- 取消发布音频

`stopConference` 取消发布音频时，SDK 内部会取消，不需要再主动调用该接口。

```Objective-C
- (void)unpublishLocalVideo;
```

<a id="6.8.6"></a>
### 6.8.6 PLRTCSession 的状态

#### 连麦状态

通过 `PLRTCSession` 的状态来反馈连麦的状态，定义了几种状态，确保 `PLRTCSession` 对象在有限的几个状态间切换，并可以较好的反应连麦的状态，包括以下几个：

| 状态名 | 含义 |
|---|---|
| PLRTCStateConferenceUnInit | 未 init 时的初始状态 |
| PLRTCStateConferenceInited | init 初始化成功 |
| PLRTCStateConferenceStarted | 已进入到连麦的状态 |
| PLRTCStateConferenceStopped | 连麦已结束的状态 |

#### `isRunning` 状态

通过反馈 `PLRTCSession` 的属性 `isRunning` 来反馈是否已经连麦。

``` Objective-C
/// @abstract start conference 后会变成 running 状态，直到出错或者 stop
@property (nonatomic, assign, readonly) BOOL isRunning;
```

#### 连麦状态变化回调

``` Objective-C
- (void)rtcSession:(PLRTCSession *)session stateDidChange:(PLRTCState)state;
```

#### 连麦错误状态回调

error 状态对应的 Delegate 回调方法是

``` Objective-C
- (void)rtcSession:(PLRTCSession *)session didFailWithError:(NSError *)error;
```

除了调用 `-stopConference ` 之外的所有导致连麦断开的情况，都被归属于非正常断开的情况，此时就会触发该回调。可通过打印 error 错误码来了解具体的错误信息，错误码定义在 `PLTypeDefines.h` 文件中。

<a id="6.8.7"></a>
### 6.8.7 连麦视频首帧解码后的回调


```
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)rtcSession:(PLRTCSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;
```    
### 6.8.8 连麦视频取消渲染的回调


```
/// @abstract 连麦时，取消远端用户（以 userID 标识）的视频渲染到 renderView 后的回调，可在该方法中将 renderView 从界面上移除。本接口在主队列中回调。
///           该接口所回调的 remoteView，即为通过
///           - (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session
///                        firstVideoFrameDecodedOfUserID:(NSString *)userID;
///           接口传入的 PLRTCVideoRender 对象中的 renderView
/// @see PLRTCVideoRender
- (void)rtcSession:(PLRTCSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;

```
<a id="6.8.8"></a>
### 6.8.9 连麦房间的相关回调
```
/// @abstract 被 userID 从房间踢出
- (void)rtcSession:(PLRTCSession *)session didKickoutByUserID:(NSString *)userID;
```

```
/// @abstract  userID 加入房间
- (void)rtcSession:(PLRTCSession *)session didJoinConferenceOfUserID:(NSString *)userID;
```

```
/// @abstract  userID 离开房间
- (void)rtcSession:(PLRTCSession *)session didLeaveConferenceOfUserID:(NSString *)userID;
```

<a id="6.8.9"></a>
### 6.8.10 PLRTCSessionStateDelegate 其他回调

- 音量监测回调

``` Objective-C
- (void)rtcSession:(PLRTCSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level;
```
*注意：连麦音频监测回调的开关 rtcMonitorAudioLevel，默认是 NO。为 YES 时，才会开启房间连麦音频音量回调，停止连麦后，该值会重置为 NO*

<a id="6"></a>
# 7 知识补充与建议

<a id="7.1"></a>
## 7.1 丢帧策略

这一章节，我们谈谈丢帧策略，这关乎最终的直播观看体验，这里我们主要说明为何需要它，以及它带来的利弊。

<a id="7.1.1"></a>
### 7.1.1 丢帧策略的必要性

我想可能没有人会喜欢在直播中出现丢帧，但是为何我们一定要实现并提供它呢？这是我们在最初提供出丢帧策略时也在反复考虑和一再讨论过的一个问题。

原因很简单，为了保证直播的实时性。

直播作为有别于录播的富媒体传播手段，它的第一要素就是实时，没有了实时，直播的价值就会荡然无存。保证实时性就需要确保录制端的数据尽可能少的累积，尽可能快的发送，但如果没有丢帧策略，在弱网环境下，就会因为待发送数据的不断堆积而产生累计延时，最终带来延时越来越大的情况。作为推流的发起端和推送端，推流 SDK 要考虑的还不单单是实时性这一点，因为移动设备的内存有限，而视频数据对内存的占用较大，所以在推流时还要确保不会因为待发送数据堆积过多而带来内存吃紧，触发 crash 等严重问题。所以我们需要也一定要在推流端提供丢帧策略。

丢帧的方式可以有很多种，其中有些较为粗暴，会触发各类问题，比如花屏，爆音，音画不同步等问题，在反复尝试和验证了各类的丢帧策略后，我们最终选定了优先保证音频传输且不触发花屏、爆音、音画不同步问题的技术方案。这一方案可以保证在带宽不足或上行速度不佳时，优先丢弃视频帧，保证音频的持续传输，在观看端至多出现画面跳帧的情况，但声音会是连续的片段，体验上不会认为是推流端断网，确保直播的继续进行。

<a id="7.1.2"></a>
### 7.1.2 利弊

丢帧策略固然保证了直播的实时性和推流端相对的稳定性，但是它的弊端也是显然的，就是会带来观看端体验的不佳。

面对并接受这一弊端是必要，这样才可以做出更好的产品决策，我们建议从产品层面至少需要考虑两点

- 在主播弱网情况下，观看端体验要保证流畅度优先还是清晰度优先
- 在主播弱网情况下，尽可能让主播自己知晓自己网络不佳这一事实

对于流畅度和清晰度的问题，可以参考[码率、fps、分辨对清晰度及流畅度的影响](#fluency-influence)这一小节。

<a id="7"></a>
# 8 历史记录
- 3.1.0 ([Release Notes](https://github.com/pili-engineering/PLRTCStreamingKit/blob/master/ReleaseNotes/release-notes-3.1.0.md) && [API Diffs](https://github.com/pili-engineering/PLRTCStreamingKit/blob/master/APIDiffs/api-diffs-3.1.0.md))
- 功能
  - 支持 QUIC 推流功能
- 缺陷
  - 修复某些机型在特定配置下推流画面不完整的问题
  - 修复切换摄像头瞬间画面出现镜像的问题
  - 修复偶现进入后台时崩溃的问题
  - 修复偶现内存泄漏的问题
  - 修复纯连麦时摄像头数据无法回调的问题

- 3.0.0 ([Release Notes](https://github.com/pili-engineering/PLRTCStreamingKit/blob/master/ReleaseNotes/release-notes-3.0.0.md))
 - 基本的推流和连麦对讲功能    
 - 基本的视频合流和音频混音功能    
 - 支持丰富的连麦消息回调    
 - 支持踢人功能    
 - 支持获取连麦房间统计信息（帧率、码率等）    
 - 支持纯音频连麦    
 - 支持连麦大小窗口切换    
 - 支持连麦获取远端麦克风音量大小    
 - 支持硬件编码    
 - 支持 ARM7, ARM64 指令集   
 - 提供音视频配置分离    
 - 支持推流时码率变更    
 - 支持弱网丢帧策略    
 - 支持模拟器运行    
 - 支持 RTMP 协议直播推流    
 - 支持后台推流    
 - 提供多码率可选    
 - 提供 H.264 视频编码    
 - 支持多分辨率编码   
 - 提供 AAC 音频编码   
 - 提供 HeaderDoc 文档    
 - 支持美颜滤镜    
 - 支持水印功能     
 - 提供内置音效及音频文件播放功能    
 - 支持返听功能    
 - 支持截屏功能   
 - 支持 iOS 10 ReplayKit 录屏    
 - 支持苹果 ATS 安全标准    
