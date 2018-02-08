//
//  PLRTCVideoView.h
//  PLMediaStreamingKit(RTC)
//
//  Created by lawder on 2017/10/24.
//  Copyright © 2017年 Pili Engineering, Qiniu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PLRTCVideoViewDelegate

- (void)displayYUV420pData:(void *)data width:(NSInteger)w height:(NSInteger)h;

- (void)clearFrame;

@end


@interface PLRTCVideoView : UIView <PLRTCVideoViewDelegate>

@end
