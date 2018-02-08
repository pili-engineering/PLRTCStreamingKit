//
//  PLRTCSession.h
//  PLRTCStreamingKit
//
//  Created by lawder on 16/7/4.
//  Copyright © 2016年 PILI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "PLStreamingSession.h"
#import "PLStreamingEnv.h"
#import "PLCommon.h"
#import "PLRTCVideoRender.h"

@class PLRTCSession;

@protocol PLRTCSessionDelegate <NSObject>

@optional

/// @abstract 连麦时，远端用户（以 userID 标识）的视频首帧解码后的回调，如果需要显示，则该需要返回含 renderView 的 PLRTCVideoRender 对象
///           如果此时不想显示，可以返回 nil，后续需要时再次调用 subscribeUserID 订阅即可
/// @see PLRTCVideoRender
- (PLRTCVideoRender *)rtcSession:(PLRTCSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID;

/// @abstract 连麦时，取消远端用户（以 userID 标识）的视频渲染到 View 后的回调
- (void)rtcSession:(PLRTCSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView;

/// @abstract 连麦状态的回调
- (void)rtcSession:(PLRTCSession *)session stateDidChange:(PLRTCState)state;

/// @abstract PLRTCSession 内部产生了某个 error 的回调
- (void)rtcSession:(PLRTCSession *)session didFailWithError:(NSError *)error;

/// @abstract 被 userID 从房间踢出
- (void)rtcSession:(PLRTCSession *)session didKickoutByUserID:(NSString *)userID;

/// @abstract  userID 加入房间
- (void)rtcSession:(PLRTCSession *)session didJoinConferenceOfUserID:(NSString *)userID;

/// @abstract userID 离开房间
- (void)rtcSession:(PLRTCSession *)session didLeaveConferenceOfUserID:(NSString *)userID;

/// @abstract 当 userID 取消发布视频时的回调
- (void)rtcSession:(PLRTCSession *)session didUnpublishVideoOfUserID:(NSString *)userID;




/*!
 * @abstract 连麦时，连麦用户（以 userID 标识）音量监测回调
 *
 * @param voiceLevel 对应 userID 音量大小
 *
 * @discussion 音量对应幅度：0-9，其中0为无音量，9为最大音量
 *
 * @see rtcMonitorAudioLevel 开启当前回调
 */

- (void)rtcSession:(PLRTCSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level;

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
- (void)rtcSession:(PLRTCSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value;

/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理
- (CVPixelBufferRef)rtcSession:(PLRTCSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer;

/// @abstract 获取到麦克风原数据时的回调
- (AudioBuffer *)rtcSession:(PLRTCSession *)session microphoneSourceDidGetAudioBuffer:(AudioBuffer *)audioBuffer;

@end

#pragma mark - RTC

@interface PLRTCSession : NSObject

/// @abstract start conference 后会变成 running 状态，直到出错或者 stop
@property (nonatomic, assign, readonly) BOOL    isRunning;

/// @abstract 调用 start conference 时传入的 PLRTCConfiguration，只读，修改它的属性不会生效
@property (nonatomic, strong, readonly) PLRTCConfiguration *rtcConfiguration;

/// @abstract 状态变更的 delegate
@property (nonatomic, weak) id<PLRTCSessionDelegate> stateDelegate;

/// @abstract PLRTCSession 的状态，只读
@property (nonatomic, assign, readonly) PLRTCState state;

/// @abstract 连麦房间中的 userID 列表（不包含自己），只读
@property (nonatomic, strong, readonly) NSArray *participants;

/// @abstract 连麦房间中的人数（不包含自己），只读
@property (nonatomic, assign, readonly) NSUInteger participantsCount;

/// @abstract 设置连麦视频动态码率调整的范围的下限，当上下限相等时，码率固定，将不会动态调整
@property (nonatomic, assign) NSUInteger rtcMinVideoBitrate;

/// @abstract 设置连麦视频动态码率调整的范围的上限，当上下限相等时，码率固定，将不会动态调整
@property (nonatomic, assign) NSUInteger rtcMaxVideoBitrate;

/// @abstract 设置是否在连麦状态下阻止系统锁屏，默认是 YES
@property (nonatomic, assign, getter=isIdleTimerDisable) BOOL  idleTimerDisable;

/// @abstract 设置是否播放房间内其他连麦者音频，默认是 NO，为 YES 时，其他连麦者音频静默
/// @warning 注意，需要在 PLRTCStateConferenceStarted 状态下设置才有效，且当次连麦有效，停止连麦后，该值会重置为 NO
@property (nonatomic, assign, getter=isMuteSpeaker) BOOL muteSpeaker;

/// @abstract  设置连麦是否开启连麦音频监测回调，默认是 NO，为 YES 时，开启房间连麦音频音量回调。
/// @warning 注意，需要在 PLRTCStateConferenceStarted 状态下开启才有效，且当次连麦有效，停止连麦后，该值会重置为 NO
@property (nonatomic, assign, getter=isRtcMonitorAudioLevel) BOOL rtcMonitorAudioLevel;

/*!
 * @abstract 摄像头的预览视图，获取它之前需要先调用 startVideoCapture
 *
 */
@property (nonatomic, strong, readonly) UIView *previewView;

/**
 @brief previewView 中视频的填充方式，默认使用 PLVideoFillModePreserveAspectRatioAndFill
 */
@property(readwrite, nonatomic) PLVideoFillModeType fillMode;

/**
 @brief 初始化方法，如果连麦过程中需要使用音/视频功能，则对应的 configuration 配置不能为 nil
 */
- (instancetype)initWithVideoCaptureConfiguration:(PLVideoCaptureConfiguration *)videoCaptureConfiguration
                        audioCaptureConfiguration:(PLAudioCaptureConfiguration *)audioCaptureConfiguration;


/*!
 * 初始化连麦参数
 * @param serverRegionID 服务器区域
 * @param serverRegionName 服务器区域扩展标识，如果没有特殊需求，可填 nil
 * @discussion 初始化连麦服务器参数，只需调用一次。需要在 start conference 接口之前调用，并在状态变更为 PLRTCStateConferenceInited 后方可调用 start conference 接口。
 */
- (void)setWithServerRegionID:(PLRTC_SERVER_REGION)serverRegionID
             serverRegionName:(NSString *)serverRegionName;

/*!
 * 开始连麦
 *
 * @discussion 开始连麦，加入连麦房间后需要手动发布音视频
 *
 * @warning 目前只支持 PLRTCConfiguration 的 videoSizePreset 和 rtcAVStatisticInterval 参数，其它参数无效
 */
- (void)startConferenceWithRoomName:(NSString *)roomName
                             userID:(NSString *)userID
                          roomToken:(NSString *)roomToken
                   rtcConfiguration:(PLRTCConfiguration *)rtcConfiguration;

/*!
 * 停止连麦
 *
 * @discussion 停止连麦后，音视频会取消发布。
 */
- (void)stopConference;


/*!
 * 发布视频
 *
 * @discussion 连麦开始（state 状态为 PLRTCStateConferenceStarted）后，发布本地的视频到房间中。注意 completionHandler 的回调不一定在主线程中进行。
 */
- (void)publishLocalVideoWithCompletionHandler:(void (^)(NSError *))completionHandler;

/*!
 * 取消发布视频
 *
 * @discussion 取消发布视频。stopConference 时，SDK 内部会取消发布视频，不需要再主动调用该接口。
 */
- (void)unpublishLocalVideo;

/*!
 * 发布音频
 *
 * @discussion 连麦开始（state 状态为 PLRTCStateConferenceStarted）后，发布本地的音频到房间中。注意 completionHandler 的回调不一定在主线程中进行。
 */
- (void)publishLocalAudioWithCompletionHandler:(void (^)(NSError *error))completionHandler;

/*!
 * 取消发布音频
 *
 * @discussion 取消发布音频。stopConference 时，SDK 内部会取消发布音频，不需要再主动调用该接口。
 */
- (void)unpublishLocalAudio;

/*!
 * 踢出指定 userID 的用户
 *
 * @discussion 踢出指定 userID 的用户
 */
- (void)kickoutUserID:(NSString *)userID;

/*!
 * 销毁 PLRTCSession 的方法
 *
 * @discussion 销毁 PLRTCSession 的方法，销毁前不需要调用 stop 方法。
 */
- (void)destroy;

/*!
 * 打开日志，目录位于 App Container/Documents 目录下，以 PLRTC_+当前时间命名
 *
 * @discussion 打开连麦日志，注意：产品上线时需要关闭日志，否则影响性能。
 */
+ (void)enableLogging;

@end


#pragma mark - Category (CameraSource)

/*!
 * @category PLCameraStreamingSession(CameraSource)
 *
 * @discussion 与摄像头相关的接口
 */
@interface PLRTCSession (CameraSource)

/// default as AVCaptureDevicePositionBack.
@property (nonatomic, assign) AVCaptureDevicePosition   captureDevicePosition;

/**
 @brief 开启 camera 时的采集摄像头的旋转方向，默认为 AVCaptureVideoOrientationPortrait
 */
@property (nonatomic, assign) AVCaptureVideoOrientation videoOrientation;

/// default as NO.
@property (nonatomic, assign, getter=isTorchOn) BOOL    torchOn;

/*!
 @property  continuousAutofocusEnable
 @abstract  连续自动对焦。该属性默认开启。
 */
@property (nonatomic, assign, getter=isContinuousAutofocusEnable) BOOL  continuousAutofocusEnable;

/*!
 @property  touchToFocusEnable
 @abstract  手动点击屏幕进行对焦。该属性默认开启。
 */
@property (nonatomic, assign, getter=isTouchToFocusEnable) BOOL touchToFocusEnable;

/*!
 @property  smoothAutoFocusEnabled
 @abstract  该属性适用于视频拍摄过程中用来减缓因自动对焦产生的镜头伸缩，使画面不因快速的对焦而产生抖动感。该属性默认开启。
 */
@property (nonatomic, assign, getter=isSmoothAutoFocusEnabled) BOOL  smoothAutoFocusEnabled;

/// default as (0.5, 0.5), (0,0) is top-left, (1,1) is bottom-right.
@property (nonatomic, assign) CGPoint   focusPointOfInterest;

/// 默认为 1.0，设置的数值需要小于等于 videoActiveForat.videoMaxZoomFactor，如果大于会设置失败。
@property (nonatomic, assign) CGFloat videoZoomFactor;

@property (nonatomic, strong, readonly) NSArray<AVCaptureDeviceFormat *> *videoFormats;

@property (nonatomic, strong) AVCaptureDeviceFormat *videoActiveFormat;

/**
 @brief 采集的视频的 sessionPreset，默认为 AVCaptureSessionPreset640x480
 */
@property (nonatomic, copy) NSString *sessionPreset;

/**
 @brief 采集的视频数据的帧率，默认为 30
 */
@property (nonatomic, assign) NSUInteger videoFrameRate;

/**
 @brief 前置预览是否开启镜像，默认为 YES
 */
@property (nonatomic, assign) BOOL previewMirrorFrontFacing;

/**
 @brief 后置预览是否开启镜像，默认为 NO
 */
@property (nonatomic, assign) BOOL previewMirrorRearFacing;

/**
 *  前置摄像头，推的流是否开启镜像，默认 NO
 */
@property (nonatomic, assign) BOOL streamMirrorFrontFacing;

/**
 *  后置摄像头，推的流是否开启镜像，默认 NO
 */
@property (nonatomic, assign) BOOL streamMirrorRearFacing;

- (void)toggleCamera;


/**
 @brief 由于硬件性能限制，为了保证推流的质量，下列 美颜、美白、红润的 API 只支持 iPhone 5、iPad 3、iPod touch 4 及以上的设备，这些 API 在低端设备上将无效
 */


/**
 *  是否开启美颜
 */
-(void)setBeautifyModeOn:(BOOL)beautifyModeOn;

/**
 @brief 设置对应 Beauty 的程度参数.
 
 @param beautify 范围从 0 ~ 1，0 为不美颜
 */
-(void)setBeautify:(CGFloat)beautify;

/**
 *  设置美白程度（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param white 范围是从 0 ~ 1，0 为不美白
 */
-(void)setWhiten:(CGFloat)whiten;

/**
 *  设置红润的程度参数.（注意：如果美颜不开启，设置美白程度参数无效）
 *
 *  @param redden 范围是从 0 ~ 1，0 为不红润
 */

-(void)setRedden:(CGFloat)redden;

/**
 *  开启水印
 *
 *  @param wateMarkImage 水印的图片
 *  @param positio       水印的位置
 */
-(void)setWaterMarkWithImage:(UIImage *)wateMarkImage position:(CGPoint)position;

/**
 *  移除水印
 */
-(void)clearWaterMark;

/**
 *  @brief 设置推流图片
 *
 *  @param image 推流的图片
 *
 *  @discussion 由于某些特殊原因不想使用摄像头采集的数据来推流时，可以使用该接口设置一张图片来替代。传入 nil 则关闭该功能。
 *
 */
- (void)setPushImage:(UIImage *)image;

/**
 *  开启摄像头采集
 *
 *  @discussion 开启摄像头采集
 */
- (void)startVideoCapture;

/**
 *  关闭摄像头采集
 *
 *  @discussion 关闭摄像头采集
 */
- (void)stopVideoCapture;

@end

#pragma mark - Category (MicrophoneSource)

/*!
 * @category PLCameraStreamingSession(MicrophoneSource)
 *
 * @discussion 与麦克风相关的接口
 */
@interface PLRTCSession (MicrophoneSource)

/*!
 * @brief 返听功能
 */
@property (nonatomic, assign, getter=isPlayback) BOOL   playback;

@property (nonatomic, assign, getter=isMuted)   BOOL    muted;                   // default as NO.

/*!
 @brief 是否允许在后台与其他 App 的音频混音而不被打断，默认关闭。
 */
@property (nonatomic, assign) BOOL allowAudioMixWithOthers;

/*!
 @brief 音频被其他 app 中断开始时会回调该函数，注意回调不在主线程进行。
 */
@property (nonatomic, copy) PLAudioSessionDidBeginInterruptionCallback audioSessionBeginInterruptionCallback;

/*!
 @brief 音频中断结束时回调，即其他 app 结束打断音频操作时会回调该函数，注意回调不在主线程进行。
 */
@property (nonatomic, copy) PLAudioSessionDidEndInterruptionCallback audioSessionEndInterruptionCallback;

/**
 @brief 麦克风采集的音量，设置范围为 0~1，各种机型默认值不同。
 
 @warning iPhone 6s 系列不支持调节麦克风采集的音量。
 */
@property (nonatomic, assign) float inputGain;

/**
 * @brief 音效，所有生效音效的一个数组。
 *
 * @see PLAudioEffectConfiguration
 */
@property (nonatomic, strong) NSArray<PLAudioEffectConfiguration *> *audioEffectConfigurations;

/**
 * @brief 绑定一个音频文件播放器。该播放器播放出的声音将和麦克风声音混和，并推流出去。
 *
 * @param audioFilePath 音频文件路径
 * @see PLAudioPlayer
 */
- (PLAudioPlayer *)audioPlayerWithFilePath:(NSString *)audioFilePath;

/**
 * @brief 关闭当前的音频文件播放器
 */
- (void)closeCurrentAudio;

/**
 *  开启麦克风采集
 *
 *  @discussion 开启麦克风采集
 */
- (void)startAudioCapture;

/**
 *  关闭麦克风采集
 *
 *  @discussion 关闭麦克风采集
 */
- (void)stopAudioCapture;

@end

#pragma mark - Category (Authorization)

/*!
 * @category PLMediaStreamingSession(Authorization)
 *
 * @discussion 与设备授权相关的接口
 */
@interface PLRTCSession (Authorization)

// Camera
+ (PLAuthorizationStatus)cameraAuthorizationStatus;

/**
 * 获取摄像头权限
 * @param handler 该 block 将会在主线程中回调。
 */
+ (void)requestCameraAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

// Microphone
+ (PLAuthorizationStatus)microphoneAuthorizationStatus;

/**
 * 获取麦克风权限
 * @param handler 该 block 将会在主线程中回调。
 */
+ (void)requestMicrophoneAccessWithCompletionHandler:(void (^)(BOOL granted))handler;

@end

#pragma mark - Category (Info)

@interface PLRTCSession (Info)

/**
 * 获取 SDK 的版本信息
 *
 */
+ (NSString *)versionInfo;

@end



