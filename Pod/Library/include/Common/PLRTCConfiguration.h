//
//  PLRTCConfiguration.h
//  PLMediaStreamingKit
//
//  Created by lawder on 16/8/16.
//  Copyright © 2016年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PLTypeDefines.h"

@interface PLRTCConfiguration : NSObject
<
NSCopying
>

/**
 @brief 设置连麦的编码分辨率，默认是 PLRTCVideoSizePresetDefault，即 PLRTCVideoSizePreset368x640；
 */
@property (nonatomic, assign) PLRTCVideoSizePreset videoSizePreset;

/**
 @brief 设置连麦的类型，默认是 PLRTCConferenceTypeAudioAndVideo；
 */
@property (nonatomic, assign) PLRTCConferenceType conferenceType;

/**
 @brief 设置连麦的合流分辨率，默认跟推流的 PLVideoStreamingConfiguration 的 videoSize 保持一致。
 */
@property (nonatomic, assign) CGSize mixVideoSize;

/**
 @brief 设置本地视频在连麦合流的画面中的大小和位置，默认为占满整个合流画面
 */
@property (nonatomic, assign) CGRect localVideoRect;

/**
 @brief 设置连麦音视频统计数据回调时间间隔，单位：s
 @warning 0s 为关闭数据回调
 默认为：0s
 */
@property (nonatomic, assign) NSInteger rtcAVStatisticInterval;


+ (instancetype)defaultConfiguration;

-(instancetype)initWithVideoSizePreset:(PLRTCVideoSizePreset)videoSize;

-(instancetype)initWithVideoSizePreset:(PLRTCVideoSizePreset)videoSize
                        conferenceType:(PLRTCConferenceType)conferenceType;

@end
