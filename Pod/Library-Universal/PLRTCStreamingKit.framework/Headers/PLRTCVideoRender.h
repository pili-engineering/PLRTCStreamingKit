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
