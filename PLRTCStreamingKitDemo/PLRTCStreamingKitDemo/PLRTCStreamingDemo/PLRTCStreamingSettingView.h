//
//  PLRTCStreamingSettingView.h
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PLRTCStreamingSettingManager.h"

@class PLRTCStreamingSettingView;
@protocol PLRTCStreamingSettingViewDelegate <NSObject>

- (void)rtcStreamingSettingView:(PLRTCStreamingSettingView *)rtcStreamingSettingView;

@end

@interface PLRTCStreamingSettingView : UIView

@property (nonatomic, weak) id<PLRTCStreamingSettingViewDelegate> delegte;
@property (nonatomic, strong) PLRTCStreamingSettingManager *settings;

- (void)show;

@end
