# <center>连麦 SDK 2.x.x -> 3.x.x 版本迁移文档</center>

## 说明

- 更新内容：全面升级连麦内核，可提供更好的连麦体验。

- **注意事项：** 
  - 3.x.x 版本与 2.x.x 版本不兼容，<b>新老版本无法互相连麦</b>，升级前请详细阅读本文档说明。
  -  一定要先调用 `-setWithServerRegionID:serverRegionName:userID:roomToken:rtcConfiguration:` 方法初始化（只需初始化一次），初始化成功后，再调用 `startConferenceWithRoomName` 方法。

## 版本

- 发布了连麦 SDK 3.0.0 全新版本

## 更新说明

具体接口使用方式详见 docs 目录下的[ PLRTCStreamingKit 文档](https://github.com/pili-engineering/PLRTCStreamingKit/docs/PLRTCStreamingKit.md)。

### 接口新增   

#### PLMediaStreamingSession    

- 新增连麦时合流的音频静音选项    

```   
/// @abstract 设置是否静音，默认是 NO，为 YES 时，推流的音频静音
/// @see muted
/// @warning 如需要连麦与推流均静音，请和 muted 组合使用
@property (nonatomic, assign, getter=isMuteMixedAudio) BOOL muteMixedAudio;   
```

- 新增初始化连麦接口

```
/*!
 * 初始化连麦参数
 * @param serverRegionID 服务器区域
 * @param serverRegionName 服务器区域扩展标识，如果没有特殊需求，可填 nil
 * @discussion 初始化连麦服务器参数，只需调用一次。需要在 start conference 接口之前调用，并在状态变更为 PLRTCStateConferenceInited 后方可调用 start conference 接口。
 */
- (void)setWithServerRegionID:(PLRTC_SERVER_REGION)serverRegionID
             serverRegionName:(NSString *)serverRegionName;
```    

- 连麦用户（以 userID 标识）音视频的统计数据回调     
 
```    
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音视频的统计数据回调
 *
 * @param userID 用户ID
 *
 * @param type 音视频码率帧率类型
 *
 * @param value 音视频码率帧率类型对应的数值
 *
 * @see rtcAVStatisticInterval 当设置为0时，关闭当前回调
 */
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value;    
```      
#### PLRTCStreamingSession    

- 新增连麦时合流的音频静音选项    

```   
/// @abstract 设置是否静音，默认是 NO，为 YES 时，推流的音频静音
/// @see muted
/// @warning 如需要连麦与推流均静音，请和 muted 组合使用
@property (nonatomic, assign, getter=isMuteMixedAudio) BOOL muteMixedAudio;   
```

- 新增初始化连麦接口

```
/*!
 * 初始化连麦参数
 * @param serverRegionID 服务器区域
 * @param serverRegionName 服务器区域扩展标识，如果没有特殊需求，可填 nil
 * @discussion 初始化连麦服务器参数，只需调用一次。需要在 start conference 接口之前调用，并在状态变更为 PLRTCStateConferenceInited 后方可调用 start conference 接口。
 */
- (void)setWithServerRegionID:(PLRTC_SERVER_REGION)serverRegionID
             serverRegionName:(NSString *)serverRegionName;
```    

- 连麦用户（以 userID 标识）音视频的统计数据回调     
 
```    
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音视频的统计数据回调
 *
 * @param userID 用户ID
 *
 * @param type 音视频码率帧率类型
 *
 * @param value 音视频码率帧率类型对应的数值
 *
 * @see rtcAVStatisticInterval 当设置为0时，关闭当前回调
 */
- (void)RTCStreamingSession:(PLRTCStreamingSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value;    
```         
#### PLRTCSession    

- 新增连麦时合流的音频静音选项    

```   
/// @abstract 设置是否静音，默认是 NO，为 YES 时，推流的音频静音
/// @see muted
/// @warning 如需要连麦与推流均静音，请和 muted 组合使用
@property (nonatomic, assign, getter=isMuteMixedAudio) BOOL muteMixedAudio;   
```

- 新增初始化连麦接口

```
/*!
 * 初始化连麦参数
 * @param serverRegionID 服务器区域
 * @param serverRegionName 服务器区域扩展标识，如果没有特殊需求，可填 nil
 * @discussion 初始化连麦服务器参数，只需调用一次。需要在 start conference 接口之前调用，并在状态变更为 PLRTCStateConferenceInited 后方可调用 start conference 接口。
 */
- (void)setWithServerRegionID:(PLRTC_SERVER_REGION)serverRegionID
             serverRegionName:(NSString *)serverRegionName;
```    

- 连麦用户（以 userID 标识）音视频的统计数据回调     
 
```    
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音视频的统计数据回调
 *
 * @param userID 用户ID
 *
 * @param type 音视频码率帧率类型
 *
 * @param value 音视频码率帧率类型对应的数值
 *
 * @see rtcAVStatisticInterval 当设置为0时，关闭当前回调
 */
- (void)RTCSession:(PLRTCSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value;    
```      


#### PLRTCConfiguration    

- 新增设置连麦音视频统计数据回调时间间隔     

```     
/**
 @brief 设置连麦音视频统计数据回调时间间隔，单位：s
 @warning 0s 为关闭数据回调
 默认为：0s
 */
@property (nonatomic, assign) NSInteger rtcAVStatisticInterval;    
```   

#### PLTypeDefines

- 新增初始化连麦服务器首选区域的配置枚举    

```   
typedef NS_ENUM(NSUInteger, PLRTC_SERVER_REGION) {
    PLRTC_SERVER_REGION_CN       = 0,  // 中国
    PLRTC_SERVER_REGION_HK       = 1,  // 香港
    PLRTC_SERVER_REGION_US       = 2,  // 美国东部
    PLRTC_SERVER_REGION_SG       = 3,  // 新加坡
    PLRTC_SERVER_REGION_KR       = 4,  // 韩国
    PLRTC_SERVER_REGION_AU       = 5,  // 澳洲
    PLRTC_SERVER_REGION_DE       = 6,  // 德国
    PLRTC_SERVER_REGION_BR       = 7,  // 巴西
    PLRTC_SERVER_REGION_IN       = 8,  // 印度
    PLRTC_SERVER_REGION_JP       = 9,  // 日本
    PLRTC_SERVER_REGION_IE       = 10, // 爱尔兰
    PLRTC_SERVER_REGION_USW      = 11, // 美国西部
    PLRTC_SERVER_REGION_USM      = 12, // 美国中部
    PLRTC_SERVER_REGION_CA       = 13, // 加拿大
    PLRTC_SERVER_REGION_LON      = 14, // 伦敦
    PLRTC_SERVER_REGION_FRA      = 15, // 法兰克福
    PLRTC_SERVER_REGION_DXB      = 16, // 迪拜
    
    PLRTC_SERVER_REGION_EXT      = 10000, // 使用扩展服务器
    PLRTC_SERVER_REGION_DEFAULT  = 10001, // 缺省服务器
};    
```     

- 新增连麦显示类       

```   
//
//  PLRTCVideoRender.h
//  PLMediaStreamingKit(RTC)
//
//  Created by lawder on 2017/9/1.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLRTCVideoView.h"

@interface PLRTCVideoRender : NSObject

/**
 @brief 对应的 userID，由 SDK 内部设置
 */
@property (nonatomic, strong, readonly) NSString *userID;

/**
 @brief 用于渲染该用户的视频的 view， 可以使用 SDK 提供的 PLRTCVideoView，如果对渲染画面有定制需求，也可以自行封装一个实现了 PLRTCVideoViewDelegate 协议的渲染 View
 */
@property (nonatomic, strong) UIView<PLRTCVideoViewDelegate> *renderView;

/**
 @brief 设置该用户在合流画面中的大小和位置
 */
@property (nonatomic, assign) CGRect mixOverlayRect;

@end    

```       

- 新增连麦渲染 UI 类       

```    
@interface PLRTCVideoView : UIView <PLRTCVideoViewDelegate>

@end
```    

### 接口变更  

#### PLMediaStreamingSession

- 变更连麦渲染界面回调接口    
    变更前：   
  
```
  /// @abstract 连麦时，将对方视频渲染到 remoteView 后的回调，可将 remoteView 添加到合适的 View 上将其显示出来。本接口在主队列中回调。
/// @warning 推出去的流中连麦的窗口位置在 rtcMixOverlayRectArray 中设定，与 remoteView 的位置没有关系。
/// @see rtcMixOverlayRectArray
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView;
``` 

 变更后:      

```    
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;

```     

- 变更连麦音量回调     
  变更前：     
  
```    
/*!
 *  @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param inputLevel 本地语音输入音量
 *
 * @param outputLevel 本地语音输出音量
 *
 * @param rtcActiveStreams 其他连麦用户的语音音量对应表，以userID为key，对应音量为值，只包含音量大于0的用户
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session audioLocalInputLevel:(NSInteger)inputLevel localOutputLevel:(NSInteger)outputLevel otherRtcActiveStreams:(NSDictionary *)rtcActiveStreams;    

```      
 变更后:   
    
```     
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param voiceLevel 对应 userID 音量大小
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level;
```          
#### PLRTCStreamingSession

- 变更连麦渲染界面回调接口    
    变更前：   
  
```
  /// @abstract 连麦时，将对方视频渲染到 remoteView 后的回调，可将 remoteView 添加到合适的 View 上将其显示出来。本接口在主队列中回调。
/// @warning 推出去的流中连麦的窗口位置在 rtcMixOverlayRectArray 中设定，与 remoteView 的位置没有关系。
/// @see rtcMixOverlayRectArray
- (void)RTCStreamingSession:(PLRTCStreamingSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView;
``` 

 变更后:      

```    
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)RTCStreamingSession:(PLRTCStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;

```     

- 变更连麦音量回调     
  变更前：     
  
```    
/*!
 *  @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param inputLevel 本地语音输入音量
 *
 * @param outputLevel 本地语音输出音量
 *
 * @param rtcActiveStreams 其他连麦用户的语音音量对应表，以userID为key，对应音量为值，只包含音量大于0的用户
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */
- (void)RTCStreamingSession:(PLRTCStreamingSession *)session audioLocalInputLevel:(NSInteger)inputLevel localOutputLevel:(NSInteger)outputLevel otherRtcActiveStreams:(NSDictionary *)rtcActiveStreams;    

```      
 变更后:   
    
```     
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param voiceLevel 对应 userID 音量大小
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */

- (void)RTCStreamingSession:(PLRTCStreamingSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level;
```      
#### PLRTCSession

- 变更连麦渲染界面回调接口    
    变更前：   
  
```
  /// @abstract 连麦时，将对方视频渲染到 remoteView 后的回调，可将 remoteView 添加到合适的 View 上将其显示出来。本接口在主队列中回调。
/// @warning 推出去的流中连麦的窗口位置在 rtcMixOverlayRectArray 中设定，与 remoteView 的位置没有关系。
/// @see rtcMixOverlayRectArray
- (void)RTCSession:(PLRTCSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView;
``` 

 变更后:      

```    
/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)RTCSession:(PLRTCSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;

```     

- 变更连麦音量回调     
  变更前：     
  
```    
/*!
 *  @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param inputLevel 本地语音输入音量
 *
 * @param outputLevel 本地语音输出音量
 *
 * @param rtcActiveStreams 其他连麦用户的语音音量对应表，以userID为key，对应音量为值，只包含音量大于0的用户
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */
- (void)RTCSession:(PLRTCSession *)session audioLocalInputLevel:(NSInteger)inputLevel localOutputLevel:(NSInteger)outputLevel otherRtcActiveStreams:(NSDictionary *)rtcActiveStreams;    

```      
 变更后:   
    
```     
/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param voiceLevel 对应 userID 音量大小
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel开启当前回调
 */

- (void)RTCSession:(PLRTCSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level;
```   

#### PLRTCConfiguration   

- 重命名 videoSize 属性：  
  变更前：     
  
```    
/**
 @brief 设置连麦者的画面尺寸，默认是 PLRTCVideoSizePresetDefault，即使用传入的视频的尺寸；
 */
@property (nonatomic, assign) PLRTCVideoSizePreset videoSize; 

```      
 变更后:   
    
```     
/**
 @brief 设置连麦的编码分辨率，默认是 PLRTCVideoSizePresetDefault，即 PLRTCVideoSizePreset368x640；
 */
@property (nonatomic, assign) PLRTCVideoSizePreset videoSizePreset;
```   
#### PLTypeDefines   

- 变更连麦状态枚举     
  变更前：     
  
```    
///连麦状态
typedef NS_ENUM(NSUInteger, PLRTCState) {
    /// 未知状态，只会作为 init 时的初始状态
    PLRTCStateUnknown = 0,
    /// 已进入到连麦的状态
    PLRTCStateConferenceStarted,
    /// 连麦已结束的状态
    PLRTCStateConferenceStopped
}; 

```      
 变更后:   
    
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

### 接口删除        

#### 删除 PLCameraStreamingKit     

#### PLMediaStreamingSession

- 删除连麦视频的数据回调

```
/// @abstract 连麦时，SDK 内部不渲染连麦者（以 userID 标识）的视频，而由该接口返回相应的视频数据
/// @ warning pixelBuffer必须在用完之后手动释放，否则会引起内存泄漏
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session  didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofUserID:(NSString *)userID;
```

- 删除取消视频的数据回调

```
/// @abstract 连麦时，对方（以 userID 标识）取消视频的数据回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLostPixelBufferOfUserID:(NSString *)userID;
```
- 删除配置合流后连麦的窗口参数

```
/**
 @abstract 配置合流后连麦的窗口在主窗口中的位置和大小，里面存放 NSValue 封装的 CGRect。注意，该位置是指连麦的窗口在推出来流的画面中的位置，并非在本地预览的位置
 
 @see - (void)RTCStreamingSession:(PLRTCStreamingSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView;
 
 @see - (void)RTCStreamingSession:(PLRTCStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;
 
 @warning - 目前版本需要在连麦开始前设置好，连麦过程中更新无效
 */
@property (nonatomic, strong) NSArray *rtcMixOverlayRectArray;
```     
- 删除设置连麦窗口的大小

```
/**
 @abstract 设置连麦窗口的大小，请在 joinRoom 前设置。由于主播涉及到画面合成和推流，可不设置或者设置较大 size，其它连麦者可以设置较小 size。
 */
@property (nonatomic, strong) NSDictionary *rtcOption;
```    
#### PLRTCStreamingSession

- 删除连麦视频的数据回调

```
/// @abstract 连麦时，SDK 内部不渲染连麦者（以 userID 标识）的视频，而由该接口返回相应的视频数据
/// @ warning pixelBuffer必须在用完之后手动释放，否则会引起内存泄漏
- (void)RTCStreamingSession:(PLRTCStreamingSession *)session  didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofUserID:(NSString *)userID;
```

- 删除取消视频的数据回调

```
/// @abstract 连麦时，对方（以 userID 标识）取消视频的数据回调
- (void)RTCStreamingSession:(PLRTCStreamingSession *)session didLostPixelBufferOfUserID:(NSString *)userID;
```
- 删除配置合流后连麦的窗口参数

```
/**
 @abstract 配置合流后连麦的窗口在主窗口中的位置和大小，里面存放 NSValue 封装的 CGRect。注意，该位置是指连麦的窗口在推出来流的画面中的位置，并非在本地预览的位置
 
 @see - (void)RTCStreamingSession:(PLRTCSession *)session userID:(NSString *)userID didAttachRemoteView:(UIView *)remoteView;
 
 @see - (void)RTCStreamingSession:(PLRTCSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;
 
 @warning - 目前版本需要在连麦开始前设置好，连麦过程中更新无效
 */
@property (nonatomic, strong) NSArray *rtcMixOverlayRectArray;
```     
- 删除设置连麦窗口的大小

```
/**
 @abstract 设置连麦窗口的大小，请在 joinRoom 前设置。由于主播涉及到画面合成和推流，可不设置或者设置较大 size，其它连麦者可以设置较小 size。
 */
@property (nonatomic, strong) NSDictionary *rtcOption;
```   
#### PLRTCSession

- 删除连麦视频的数据回调

```
/// @abstract 连麦时，SDK 内部不渲染连麦者（以 userID 标识）的视频，而由该接口返回相应的视频数据
/// @ warning pixelBuffer必须在用完之后手动释放，否则会引起内存泄漏
- (void)RTCSession:(PLRTCSession *)session  didGetPixelBuffer:(CVPixelBufferRef)pixelBuffer ofUserID:(NSString *)userID;
```

- 删除取消视频的数据回调

```
/// @abstract 连麦时，对方（以 userID 标识）取消视频的数据回调
- (void)RTCSession:(PLRTCSession *)session didLostPixelBufferOfUserID:(NSString *)userID;
```
- 删除配置合流后连麦的窗口参数

```
/**
 @abstract 配置合流后连麦的窗口在主窗口中的位置和大小，里面存放 NSValue 封装的 CGRect。注意，该位置是指连麦的窗口在推出来流的画面中的位置，并非在本地预览的位置
 
 @warning - 目前版本需要在连麦开始前设置好，连麦过程中更新无效
 */
@property (nonatomic, strong) NSArray *rtcMixOverlayRectArray;
```     
- 删除设置连麦窗口的大小

```
/**
 @abstract 设置连麦窗口的大小，请在 joinRoom 前设置。由于主播涉及到画面合成和推流，可不设置或者设置较大 size，其它连麦者可以设置较小 size。
 */
@property (nonatomic, strong) NSDictionary *rtcOption;
```   

#### PLRTCConfiguration
- 删除设置外部渲染参数

```
/**
 @brief 设置是否在连麦状态下外部渲染画面，默认为NO
 */
@property (nonatomic, assign, getter=isRtcExternalRendering) BOOL rtcExternalRendering;
```

