//
//  PLRTCStreamingSettingManager.h
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PLTypeDefines.h"

@interface PLRTCStreamingSettingManager : NSObject

@property (strong, nonatomic) NSString *roomName;
@property (assign, nonatomic) BOOL onlyAudio;
@property (assign, nonatomic) NSInteger videoFrameRate;
@property (strong, nonatomic) NSString *sessionPreset;
@property (assign, nonatomic) NSInteger videoBitRate;
@property (assign, nonatomic) PLH264EncoderType h264EncoderType;
@property (assign, nonatomic) NSInteger rtcSizePreset;

- (void)setObjValue:(PLRTCStreamingSettingManager *)settings;
- (BOOL)isEqualObj:(PLRTCStreamingSettingManager *)settings;

@end
