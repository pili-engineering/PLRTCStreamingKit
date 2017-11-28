//
//  PLRTCStreamingSettingView.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCStreamingSettingView.h"
#import <AVFoundation/AVFoundation.h>
#import "PLRTCStreamingSettingManager.h"

@interface PLRTCStreamingSettingView () <UITextFieldDelegate>
{
    NSArray *_videoFrameRateArray;
    NSArray *_sessionPresetArray;
    NSArray *_averageVideoBitRateArray;
    NSArray *_videoEncoderArray;
    NSArray *_rtcSizePresetArray;
    
    NSArray *_frameRateArray;
    NSArray *_captureSessionPresetArray;
    NSArray *_videoBitRateArray;
    NSArray *_videoEncoderTypeArray;
    NSArray *_rtcVideoSizePresetArray;
    
    UISegmentedControl *_videoFrameRateSegmentedControl;
    UISegmentedControl *_sessionPresetSegmentedControl;
    UISegmentedControl *_averageVideoBitRateSegmentedControl;
    UISegmentedControl *_videoEncoderSegmentedControl;
    UISegmentedControl *_rtcSizePresetSegmentedControl;
    
    PLRTCStreamingSettingManager *_currentSettings;
}

@property (nonatomic, strong) UITextField *roomNametextField;
@property (nonatomic, strong) UISegmentedControl *audioOnlySegmentControl;
@property (nonatomic, strong) NSArray *audioOnlySegmentArray;
@property (nonatomic, strong) UILabel *versionLabel;
@property (strong, nonatomic) UIButton *saveButton;

@end


@implementation PLRTCStreamingSettingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupSubviews];
        self.settings = [[PLRTCStreamingSettingManager alloc] init];
        
        _currentSettings = [[PLRTCStreamingSettingManager alloc] init];
    }
    return self;
}

- (void)show {
    [self refreshValues];
    [[[UIApplication sharedApplication] keyWindow] addSubview:self];
}

- (void)refreshValues {
    if ([NSThread isMainThread]) {
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *roomName = [userDefaults objectForKey:@"PLRTCStreamingRoomName"];
        self.roomNametextField.text = roomName;
        
        self.settings.roomName = self.roomNametextField.text;
        
        self.audioOnlySegmentControl.selectedSegmentIndex = self.settings.onlyAudio;
        
        _videoFrameRateSegmentedControl.selectedSegmentIndex = [_frameRateArray indexOfObject:@(self.settings.videoFrameRate)];
        _sessionPresetSegmentedControl.selectedSegmentIndex = [_captureSessionPresetArray indexOfObject:self.settings.sessionPreset];
        _averageVideoBitRateSegmentedControl.selectedSegmentIndex = [_videoBitRateArray indexOfObject:@(self.settings.videoBitRate)];
        _videoEncoderSegmentedControl.selectedSegmentIndex = [_videoEncoderTypeArray indexOfObject:@(self.settings.h264EncoderType)];
        
        [_currentSettings setObjValue:self.settings];
    }
    else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *roomName = [userDefaults objectForKey:@"PLRTCStreamingRoomName"];
            self.roomNametextField.text = roomName;
            
            self.settings.roomName = self.roomNametextField.text;
            
            self.audioOnlySegmentControl.selectedSegmentIndex = self.settings.onlyAudio;
            
            _videoFrameRateSegmentedControl.selectedSegmentIndex = [_frameRateArray indexOfObject:@(self.settings.videoFrameRate)];
            _sessionPresetSegmentedControl.selectedSegmentIndex = [_captureSessionPresetArray indexOfObject:self.settings.sessionPreset];
            _averageVideoBitRateSegmentedControl.selectedSegmentIndex = [_videoBitRateArray indexOfObject:@(self.settings.videoBitRate)];
            _videoEncoderSegmentedControl.selectedSegmentIndex = [_videoEncoderTypeArray indexOfObject:@(self.settings.h264EncoderType)];
            
            [_currentSettings setObjValue:self.settings];
        });
    }
}

- (void)setupSubviews {
    // 双击手势 - 收起键盘
    UITapGestureRecognizer *singleRecongnizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleRecognizerHandler)];
    singleRecongnizer.numberOfTapsRequired = 2;
    [self addGestureRecognizer:singleRecongnizer];
    
    // 房间号
    UILabel *roomNameLabel =[self getLabelView:@"房间号：" andFrame:CGRectMake(20, 90, 80, 30)];
    [self addSubview:roomNameLabel];
    
    self.roomNametextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 90, CGRectGetWidth([UIScreen mainScreen].bounds) - 120, 30)];
    self.roomNametextField.delegate = self;
    [self addSubview:self.roomNametextField];
    
    // 纯音频
    UILabel *audioOnlyLabel =[self getLabelView:@"纯音频：" andFrame:CGRectMake(20, 130, 80, 30)];
    [self addSubview:audioOnlyLabel];
    
    self.audioOnlySegmentArray = @[@"NO", @"YES"];
    self.audioOnlySegmentControl = [self getUISegmentedControlView:self.audioOnlySegmentArray andFrame:CGRectMake(100, 130, CGRectGetWidth([UIScreen mainScreen].bounds) - 120, 30)];
    [self addSubview:self.audioOnlySegmentControl];
    self.audioOnlySegmentControl.selectedSegmentIndex = 0;
    [self addSubview:self.audioOnlySegmentControl];
    
    self.roomNametextField.layer.borderColor = [self.audioOnlySegmentControl.tintColor CGColor];
    self.roomNametextField.layer.borderWidth = 1.0f;
    
    // 版本信息
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 30)];
    self.versionLabel.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) - 20);
    self.versionLabel.text = [NSString stringWithFormat:@"版本：%@", info[@"CFBundleVersion"]];
    self.versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.versionLabel];
    
    [self addMediaSettingControlView];
    
}

- (void)addMediaSettingControlView {
    // 视频帧率
    UILabel *videoFrameRateLabel =[self getLabelView:@"视频帧率：" andFrame:CGRectMake(20, 190, 140, 30)];
    [self addSubview:videoFrameRateLabel];
    
    _frameRateArray = @[@15, @20, @24, @30];
    _videoFrameRateArray = @[@"15", @"20", @"24", @"30"];
    _videoFrameRateSegmentedControl = [self getUISegmentedControlView:_videoFrameRateArray andFrame:CGRectMake(10, 220,  CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 30)];
    [self addSubview:_videoFrameRateSegmentedControl];
    _videoFrameRateSegmentedControl.selectedSegmentIndex = 2;
    
    // 视频采集分辨率
    UILabel *sessionPresetLabel =[self getLabelView:@"视频采集分辨率：" andFrame:CGRectMake(20, 255, 140, 30)];
    [self addSubview:sessionPresetLabel];
    
    _captureSessionPresetArray = @[AVCaptureSessionPreset640x480, AVCaptureSessionPresetiFrame960x540, AVCaptureSessionPreset1280x720, AVCaptureSessionPreset1920x1080];
    _sessionPresetArray = @[@"480P", @"540P", @"720P", @"1080P"];
    _sessionPresetSegmentedControl = [self getUISegmentedControlView:_sessionPresetArray andFrame:CGRectMake(10, 285, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 30)];
    [self addSubview:_sessionPresetSegmentedControl];
    _sessionPresetSegmentedControl.selectedSegmentIndex = 0;
    
    // 视频连麦分辨率
    UILabel *rtcSizePresetLabel =[self getLabelView:@"视频编码分辨率：" andFrame:CGRectMake(20, 320, 140, 30)];
    [self addSubview:rtcSizePresetLabel];
    
    _rtcVideoSizePresetArray = @[@4, @5, @7, @9];
    _rtcSizePresetArray = @[@"368x640", @"480x640", @"544x960", @"720x1280"];
    _rtcSizePresetSegmentedControl = [self getUISegmentedControlView:_rtcSizePresetArray andFrame:CGRectMake(10, 355, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 30)];
    [self addSubview:_rtcSizePresetSegmentedControl];
    _rtcSizePresetSegmentedControl.selectedSegmentIndex = 0;
    
    
    // 视频平均码率
    UILabel *averageVideoBitRateLabel = [self getLabelView:@"视频平均码率 Kbps：" andFrame:CGRectMake(20, 390, 140, 30)];
    [self addSubview:averageVideoBitRateLabel];
    
    _videoBitRateArray = @[@"512000", @"768000", @"1024000", @"1280000", @"1536000", @"2048000"];
    _averageVideoBitRateArray = @[@"512", @"768", @"1024", @"1280", @"1536", @"2048"];
    _averageVideoBitRateSegmentedControl = [self getUISegmentedControlView:_averageVideoBitRateArray andFrame:CGRectMake(10, 425, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 30)];
    [self addSubview:_averageVideoBitRateSegmentedControl];
    _averageVideoBitRateSegmentedControl.selectedSegmentIndex = 1;
    
    // 视频编码器类型
    UILabel *videoEncoderLabel =[self getLabelView:@"视频编码器类型：" andFrame:CGRectMake(20, 465, 120, 30)];
    [self addSubview:videoEncoderLabel];
    
    _videoEncoderTypeArray = @[@(PLH264EncoderType_AVFoundation), @(PLH264EncoderType_VideoToolbox)];
    _videoFrameRateArray = @[@"AVFoundation", @"VideoToolbox"];
    _videoEncoderSegmentedControl = [self getUISegmentedControlView:_videoFrameRateArray andFrame:CGRectMake(videoEncoderLabel.frame.origin.x + 120, 465, CGRectGetWidth([UIScreen mainScreen].bounds) - videoEncoderLabel.frame.origin.x - 130, 30)];
    [self addSubview:_videoEncoderSegmentedControl];
    _videoEncoderSegmentedControl.selectedSegmentIndex = 0;
    
    // 保存按钮
    _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _saveButton.frame = CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 4, 500, CGRectGetWidth([UIScreen mainScreen].bounds) / 2, 45);
    [_saveButton setTitle:@"保存并退出" forState:UIControlStateNormal];
    [_saveButton setBackgroundColor:_videoEncoderSegmentedControl.tintColor];
    [_saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_saveButton];
}

- (UILabel *)getLabelView:(NSString *)name andFrame:(CGRect)frame {
    UILabel *label = [[UILabel alloc] init];
    label.frame = frame;
    label.text = name;
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.f];
    return label;
}

- (UISegmentedControl *)getUISegmentedControlView:(NSArray *)names andFrame:(CGRect)frame {
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:names];
    segmentedControl.frame = frame;
    return segmentedControl;
}

- (void)singleRecognizerHandler {
    [self.roomNametextField resignFirstResponder];
}

- (void)saveButtonClick:(id)sender {
    if (!self.roomNametextField.text  || [self.roomNametextField.text isEqualToString:@""]) {
        [self showAlertWithMessage:@"房间名不能为空"];
        return;
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.roomNametextField.text forKey:@"PLRTCStreamingRoomName"];
    //    [userDefaults setInteger:self.audioOnlySegmentControl.selectedSegmentIndex forKey:@"PLMediaAudioOnly"];
    [userDefaults synchronize];
    
    self.settings.roomName = self.roomNametextField.text;
    if (self.audioOnlySegmentControl.selectedSegmentIndex == 0) {
        self.settings.onlyAudio = NO;
    } else {
        self.settings.onlyAudio = YES;
    }
    self.settings.videoFrameRate = [_frameRateArray[_videoFrameRateSegmentedControl.selectedSegmentIndex] integerValue];
    self.settings.sessionPreset = _captureSessionPresetArray[_sessionPresetSegmentedControl.selectedSegmentIndex];
    self.settings.videoBitRate = [_videoBitRateArray[_averageVideoBitRateSegmentedControl.selectedSegmentIndex] integerValue];
    self.settings.h264EncoderType = [_videoEncoderTypeArray[_videoEncoderSegmentedControl.selectedSegmentIndex] intValue];
    self.settings.rtcSizePreset = [_rtcVideoSizePresetArray[_rtcSizePresetSegmentedControl.selectedSegmentIndex] intValue];
    [self removeFromSuperview];
    
    if (![_currentSettings isEqualObj:self.settings]) {
        [_currentSettings setObjValue:self.settings];
        
        if ([self.delegte respondsToSelector:@selector(rtcStreamingSettingView:)]) {
            [self.delegte rtcStreamingSettingView:self];
        }
    }
    else {
        
    }
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark ---- UITextField Delegate methods --------
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.roomNametextField) {
        [self.roomNametextField resignFirstResponder];
    }
    
    return YES;
}

@end
