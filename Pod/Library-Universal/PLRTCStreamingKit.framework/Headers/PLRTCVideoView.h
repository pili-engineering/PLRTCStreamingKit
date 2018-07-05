//
//  PLRTCVideoView.h
//  PLMediaStreamingKit(RTC)
//
//  Created by lawder on 2017/10/24.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PLTypeDefines.h"

@protocol PLRTCVideoViewDelegate

- (void)displayYUV420pData:(void *)data width:(NSInteger)w height:(NSInteger)h;

- (void)clearFrame;

@end


@interface PLRTCVideoView : UIView <PLRTCVideoViewDelegate>
    
- (instancetype)initWithFrame:(CGRect)frame;
    
-(instancetype)init __attribute__((unavailable("init not available, call initWithFrame instead")));
    
-(instancetype)initWithCoder:(NSCoder *)aDecoder __attribute__((unavailable("initWithCoder not available, call initWithFrame instead")));

- (void)setRenderMode:(PLRTCVideoRenderMode)mode;

@end
