//
//  PLRTCStreamingSettingManager.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCStreamingSettingManager.h"

@implementation PLRTCStreamingSettingManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _roomName = nil;
        _onlyAudio = NO;
        _videoFrameRate = 24;
        _sessionPreset = AVCaptureSessionPreset640x480;
        _videoBitRate = 768000;
        _h264EncoderType = PLH264EncoderType_AVFoundation;
        _rtcSizePreset = 4;
    }
    return self;
}

- (void)setObjValue:(PLRTCStreamingSettingManager *)settings {
    self.roomName = settings.roomName;
    self.onlyAudio = settings.onlyAudio;
    self.videoFrameRate = settings.videoFrameRate;
    self.sessionPreset = settings.sessionPreset;
    self.videoBitRate = settings.videoBitRate;
    self.h264EncoderType = settings.h264EncoderType;
    self.rtcSizePreset = settings.rtcSizePreset;
}

- (BOOL)isEqualObj:(PLRTCStreamingSettingManager *)settings {
    if ( [self.roomName isEqualToString:settings.roomName] &&
        self.onlyAudio == settings.onlyAudio &&
        self.videoFrameRate == settings.videoFrameRate &&
        [self.sessionPreset isEqualToString:settings.sessionPreset] &&
        self.videoBitRate == settings.videoBitRate &&
        self.h264EncoderType == settings.h264EncoderType &&
        self.rtcSizePreset == settings.rtcSizePreset)
    {
        return YES;
    }
    else
        return NO;
}

@end
