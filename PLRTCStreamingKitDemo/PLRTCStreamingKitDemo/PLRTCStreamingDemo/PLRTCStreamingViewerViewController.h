//
//  PLRTCStreamingViewerViewController.h
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PLMediaUserType) {
    PLMediaUserTypeUnknown = 0,
    PLMediaUserTypeSecondChief = 1,
    PLMediaUserTypeViewer = 2
};

@interface PLRTCStreamingViewerViewController : UIViewController

@property (nonatomic, assign) PLMediaUserType userType;
@property (nonatomic, strong) NSString *roomName;
@property (nonatomic, assign) BOOL audioOnly;

@end
