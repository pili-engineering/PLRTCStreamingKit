//
//  PLRTCStreamingChiefViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCStreamingChiefViewController.h"
#import "PLMediaStreamingKit.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "PLRTCStreamingSettingManager.h"
#import "PLRTCStreamingSettingView.h"
#import "AppServerBase.h"

const static char *streamStateNames[] = {
    "Unknow",
    "Connecting",
    "Connected",
    "Disconnecting",
    "Disconnected",
    "Error"
};

const static char *rtcStateNames[] = {
    "PLRTCStateConferenceUnInit",
    "PLRTCStateConferenceInited",
    "ConferenceStarted",
    "ConferenceStopped"
};

static const CGSize videoSizeMap[] = {
    {144, 192},
    {176, 320},
    {240, 320},
    {240, 432},
    {368, 640},
    {480, 640},
    {544, 720},
    {544, 960},
    {720, 960},
    {720, 1280}
};

@interface PLRTCStreamingChiefViewController ()<PLMediaStreamingSessionDelegate, PLPlayerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, PLRTCStreamingSettingViewDelegate>

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *muteButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *beautyModeButton;
@property (nonatomic, strong) UIButton *waterMarkButton;
@property (nonatomic, strong) UIButton *muteMixAudioButton;
@property (nonatomic, strong) UILabel *joinTimeLabel;

@property (nonatomic, strong) PLMediaStreamingSession *session;

@property (nonatomic, assign) NSUInteger viewSpaceMask;

@property (nonatomic, strong) NSMutableDictionary *userViewDictionary;
@property (nonatomic, strong) NSString *    userID;
@property (nonatomic, strong) NSString *    roomToken;
@property (nonatomic, strong) PLStream *stream;

@property (nonatomic, strong) UIView *fullscreenView;
@property (nonatomic, strong) UIView *tappedView;
@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) PLRTCStreamingSettingView *settingView;

@property (nonatomic, strong) NSURL *pushURL;
@property (nonatomic, strong) NSDate *startConferenceTime;

@end

@implementation PLRTCStreamingChiefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.userViewDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self setupUI];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.roomName = [userDefaults objectForKey:@"PLRTCStreamingRoomName"];
    if (!self.roomName) {
        [self showAlertWithMessage:@"请先在设置界面设置您的房间名" completion:nil];
        return;
    }
    
    [self initStreamingSession];
}


- (void)setupUI
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 66, 66)];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    self.joinTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20 + 66 + 10, 180, 40)];
    [self.joinTimeLabel setTextColor:[UIColor blueColor]];
    [self.view addSubview:self.joinTimeLabel];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.actionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, size.height - 66, 66, 66)];
    [self.actionButton setTitle:@"推流" forState:UIControlStateNormal];
    [self.actionButton setTitle:@"暂停" forState:UIControlStateSelected];
    [self.actionButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.actionButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.actionButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.actionButton addTarget:self action:@selector(actionButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.actionButton];
    self.actionButton.hidden = YES;
    
    self.muteButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - 33, size.height - 66, 66, 66)];
    [self.muteButton setTitle:@"静音" forState:UIControlStateNormal];
    [self.muteButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.muteButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteButton addTarget:self action:@selector(muteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteButton];
    
    self.muteMixAudioButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 120 - 20, 80, 120, 66)];
    [self.muteMixAudioButton setTitle:@"静音远端" forState:UIControlStateNormal];
    [self.muteMixAudioButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.muteMixAudioButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteMixAudioButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteMixAudioButton addTarget:self action:@selector(muteMixAudioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteMixAudioButton];
    
    self.beautyModeButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 120 - 20, 80 + 66, 120, 66)];
    [self.beautyModeButton setTitle:@"美颜" forState:UIControlStateNormal];
    [self.beautyModeButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.beautyModeButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.beautyModeButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.beautyModeButton addTarget:self action:@selector(beautyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.beautyModeButton];
    self.beautyModeButton.selected = YES;
    
    self.waterMarkButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 120 - 20, 80 + 66 + 66, 120, 66)];
    [self.waterMarkButton setTitle:@"水印" forState:UIControlStateNormal];
    [self.waterMarkButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.waterMarkButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.waterMarkButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.waterMarkButton addTarget:self action:@selector(waterMarkButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.waterMarkButton];
    self.waterMarkButton.selected = YES;
    
    self.conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, size.height - 66, 66, 66)];
    [self.conferenceButton setTitle:@"连麦" forState:UIControlStateNormal];
    [self.conferenceButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.conferenceButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.conferenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.conferenceButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceButton];
    self.conferenceButton.hidden = YES;
    
    if (self.audioOnly) {
        self.view.backgroundColor = [UIColor blackColor];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 106, size.width, size.height - 106 * 2)];
        self.textView.editable = NO;
        self.textView.backgroundColor = [UIColor clearColor];
        self.textView.textColor = [UIColor whiteColor];
        [self.view addSubview:self.textView];
    }
    else {
        self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, 20, 66, 66)];
        [self.toggleButton setTitle:@"切换" forState:UIControlStateNormal];
        [self.toggleButton addTarget:self action:@selector(toggleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.toggleButton];
    }
    
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton.frame = CGRectMake(110, 20, 140, 66);
    [self.settingButton setTitle:@"推流／连麦设置" forState:UIControlStateNormal];
    [self.settingButton addTarget:self action:@selector(settingButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingButton];
    
    self.settingView = [[PLRTCStreamingSettingView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight([UIScreen mainScreen].bounds))];
    self.settingView.delegte = self;
}

- (void)initStreamingSession
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.roomName = [userDefaults objectForKey:@"PLRTCStreamingRoomName"];
    
    self.audioOnly = self.settingView.settings.onlyAudio;
    
    if (self.audioOnly) {
        self.session = [[PLMediaStreamingSession alloc]
                        initWithVideoCaptureConfiguration:nil
                        audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration] videoStreamingConfiguration:nil audioStreamingConfiguration:[PLAudioStreamingConfiguration defaultConfiguration] stream:nil];
    }
    else {
        NSInteger videoFrameRate = self.settingView.settings.videoFrameRate;
        NSInteger videoBitRate = self.settingView.settings.videoBitRate;
        PLH264EncoderType h264EncoderType = self.settingView.settings.h264EncoderType;
        NSString *sessionPreset = self.settingView.settings.sessionPreset;
        CGSize videoSize = videoSizeMap[self.settingView.settings.rtcSizePreset];
        
        PLVideoStreamingConfiguration *videoStreamingConfiguration = [[PLVideoStreamingConfiguration alloc] initWithVideoSize:videoSize expectedSourceVideoFrameRate:videoFrameRate videoMaxKeyframeInterval:72 averageVideoBitRate:videoBitRate videoProfileLevel:AVVideoProfileLevelH264HighAutoLevel videoEncoderType:h264EncoderType];
        
        PLVideoCaptureConfiguration *videoCaptureConfiguration = [PLVideoCaptureConfiguration defaultConfiguration];
        videoCaptureConfiguration.sessionPreset = sessionPreset;
        videoCaptureConfiguration.videoFrameRate = videoFrameRate;
        
        self.session = [[PLMediaStreamingSession alloc]
                        initWithVideoCaptureConfiguration:videoCaptureConfiguration
                        audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration] videoStreamingConfiguration:videoStreamingConfiguration audioStreamingConfiguration:[PLAudioStreamingConfiguration defaultConfiguration] stream:nil];
        UIImage *waterMark = [UIImage imageNamed:@"qiniu.png"];
        [self.session setWaterMarkWithImage:waterMark position:CGPointMake(100, 100)];
        self.session.previewView.frame = self.view.bounds;
        self.fullscreenView = self.session.previewView;
        [self addGestureOnView:self.fullscreenView];
        [self.view insertSubview:self.session.previewView atIndex:0];
        [self.session setBeautifyModeOn:YES];
    }
    self.session.delegate = self;
    NSLog(@"PLMediaStreamingSession versionInfo :%@",[PLMediaStreamingSession versionInfo]);
    [AppServerBase getPublishAddrWithRoomname:self.roomName completed:^(NSError *error, NSString *urlString) {
        if (error) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Demo request streamJson failed, error: %@", error] completion:^{
                [self backButtonClick:nil];
            }];
            return ;
        };
        
        self.pushURL = [NSURL URLWithString:urlString];
        self.actionButton.hidden = NO;
    }];
    
    self.userID = [[NSUUID UUID] UUIDString];
    [AppServerBase getRTCTokenWithRoomToken:self.roomName userID:self.userID completed:^(NSError *error, NSString *token){
        if (!token) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Demo request token failed, error: %@", error] completion:^{
                [self backButtonClick:nil];
            }];
            return ;
        }
        self.roomToken = token;
        [self checkConferenceButtonStatus];
    }];
    
    [self.session setWithServerRegionID:PLRTC_SERVER_REGION_DEFAULT serverRegionName:@""];
}

- (void)checkConferenceButtonStatus {
    if (self.roomToken && self.session.rtcState != PLRTCStateConferenceUnInit) {
        self.conferenceButton.hidden = NO;
    }
    else {
        self.conferenceButton.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PLMediaSettingViewDelegate
- (void)rtcStreamingSettingView:(PLRTCStreamingSettingView *)rtcStreamingSettingView {
    [self.session stopConference];
    self.conferenceButton.selected = NO;
    self.conferenceButton.enabled = YES;
    self.actionButton.selected = NO;
    self.viewSpaceMask = 0;
    
    if (!self.audioOnly) {
        NSArray *remoteViews = [self.userViewDictionary allValues];
        for (UIView *view in remoteViews) {
            [view removeFromSuperview];
        }
        if (self.session.previewView.superview) {
            [self.session.previewView removeFromSuperview];
        }
    }
    
    self.session.delegate = nil;
    [self.session destroy];
    self.session = nil;
    
    [self initStreamingSession];
}

#pragma mark -- button clicked events
- (IBAction)backButtonClick:(id)sender
{
    self.session.delegate = nil;
    [self.session destroy];
    self.session = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)settingButtonClick:(id)sender {
    [self.settingView show];
}

- (IBAction)toggleButtonClick:(id)sender
{
    [self.session toggleCamera];
}

- (IBAction)actionButtonClick:(id)sender
{
    if (!self.session.isStreamingRunning) {
        self.actionButton.enabled = NO;
        if (!self.session.stream) {
            self.session.stream = self.stream;
        }
        
        _session.pushURL = self.pushURL;
        
        [self.session startStreamingWithPushURL:_session.pushURL feedback:^(PLStreamStartStateFeedback feedback) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.actionButton.enabled = YES;
                if (feedback == PLStreamStartStateSuccess) {
                    self.actionButton.selected = YES;
                }
                else {
                    [self showAlertWithMessage:[NSString stringWithFormat:@"推流失败! feedback is %lu", (unsigned long)feedback] completion:nil];
                }
            });
        }];
        
    } else {
        [self.session stopStreaming];
        self.actionButton.selected = NO;
    }
}

- (IBAction)muteButtonClick:(id)sender
{
    if (self.session.isRtcRunning) {
        self.muteButton.selected = !self.muteButton.selected;
    }
    self.session.muted = self.muteButton.selected;
    NSLog(@"self.session.muted == %d",self.session.isMuted);
}

- (IBAction)muteMixAudioButtonClick:(id)sender {
    NSLog(@"self.session.isMuteSpeaker == %d",self.session.isMuteSpeaker);
    self.muteMixAudioButton.selected = !self.muteMixAudioButton.selected;
    self.session.muteMixedAudio = self.muteMixAudioButton.selected;
}

- (IBAction)beautyButtonClick:(id)sender {
    self.beautyModeButton.selected = !self.beautyModeButton.selected;
    [self.session setBeautifyModeOn:self.beautyModeButton.isSelected];
}

- (IBAction)waterMarkButtonClick:(id)sender {
    self.waterMarkButton.selected = !self.waterMarkButton.selected;
    if (self.waterMarkButton.isSelected) {
        UIImage *waterMark = [UIImage imageNamed:@"qiniu.png"];
        [self.session setWaterMarkWithImage:waterMark position:CGPointMake(100, 100)];
    }else {
        [self.session clearWaterMark];
    }
}

- (void)kickoutButtonClick:(id)sender {
    UIButton *button = (UIButton *)sender;
    UIView *view = button.superview;
    for (NSString *userID in self.userViewDictionary.allKeys) {
        if ([self.userViewDictionary objectForKey:userID] == view) {
            [self.session kickoutUserID:userID];
            break;
        }
    }
}

- (IBAction)conferenceButtonClick:(id)sender
{
    self.conferenceButton.enabled = NO;
    
    if (!self.conferenceButton.selected) {
        PLRTCConferenceType conferenceType = self.audioOnly ? PLRTCConferenceTypeAudio : PLRTCConferenceTypeAudioAndVideo;
        PLRTCConfiguration *configuration = [PLRTCConfiguration defaultConfiguration];
        configuration.conferenceType = conferenceType;
        configuration.videoSizePreset = (PLRTCVideoSizePreset)self.settingView.settings.rtcSizePreset;
        CGSize videoSize = videoSizeMap[self.settingView.settings.rtcSizePreset];
        configuration.rtcAVStatisticInterval = 3;
        self.session.rtcMinVideoBitrate= 100 * 1000;
        self.session.rtcMaxVideoBitrate= 300 * 1000;
        
        [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
        self.startConferenceTime = [NSDate date];
    }
    else {
        [self.session stopConference];
    }
    return;
}

- (void)showAlertWithMessage:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
}

- (void)dealloc
{
    NSLog(@"PLRTCStreamingChiefViewController dealloc");
}

#pragma mark - observer

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    if (self.session.isRtcRunning) {
        [self.session stopConference];
        self.conferenceButton.enabled = YES;
    }
}


#pragma mark - 大小窗口切换

// 加此手势是为了实现大小窗口切换的功能
- (void)addGestureOnView:(UIView *)view {
    UISwipeGestureRecognizer* recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(viewSwiped:)];
    recognizer.direction = UISwipeGestureRecognizerDirectionUp;
    [view addGestureRecognizer:recognizer];
}

- (void)animationToFullscreenWithView:(UIView *)view {
    [UIView beginAnimations:@"FrameAni" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationStopped:)];
    [UIView setAnimationRepeatCount:1];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    view.frame = self.view.frame;
    [UIView commitAnimations];
}

- (void)animationStopped:(NSString *)aniID {
    self.fullscreenView.frame = self.originRect;
    [self setKickoutButtonHidden:NO onView:self.fullscreenView];
    [self.view sendSubviewToBack:self.tappedView];
    self.fullscreenView = self.tappedView;
}

- (void)viewSwiped:(UITapGestureRecognizer *)gestureRecognizer {
    self.tappedView = gestureRecognizer.view;
    if (CGSizeEqualToSize(self.tappedView.frame.size, self.view.frame.size)) {
        return;
    }
    
    self.originRect = self.tappedView.frame;
    [self setKickoutButtonHidden:YES onView:self.tappedView];
    [self animationToFullscreenWithView:self.tappedView];
}

- (void)setKickoutButtonHidden:(BOOL)hidden onView:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if ([subview isKindOfClass:[UIButton class]]) {
            subview.hidden = hidden;
        }
    }
}

#pragma mark - 视频数据回调

/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作，否则可能会导致推流帧率下降
- (CVPixelBufferRef)mediaStreamingSession:(PLMediaStreamingSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    
    //此处可以做美颜等处理
    
    return pixelBuffer;
}


#pragma mark - 推流回调

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStateDidChange:(PLStreamState)state {
    NSString *log = [NSString stringWithFormat:@"Stream State: %s", streamStateNames[state]];
    NSLog(@"%@", log);
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didDisconnectWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.actionButton.selected = NO;
    [self showAlertWithMessage:[NSString stringWithFormat:@"Error code: %ld, %@", (long)error.code, error.localizedDescription] completion:nil];
}


/// @abstract 当开始推流时，会每间隔 3s 调用该回调方法来反馈该 3s 内的流状态，包括视频帧率、音频帧率、音视频总码率
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session streamStatusDidUpdate:(PLStreamStatus *)status {
    NSLog(@"%@", status);
}

#pragma mark - 连麦回调

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcStateDidChange:(PLRTCState)state {
    NSString *log = [NSString stringWithFormat:@"RTC State: %s", rtcStateNames[state]];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, log];
    if (state == PLRTCStateConferenceInited) {
        [self checkConferenceButtonStatus];
    }
    
    if (state == PLRTCStateConferenceStarted) {
        NSTimeInterval conferenceTime = [[NSDate date] timeIntervalSinceDate:self.startConferenceTime];
        self.joinTimeLabel.text = [NSString stringWithFormat:@"连麦时长： %ld",(long)(conferenceTime * 1000)];
        self.conferenceButton.selected = YES;
    } else {
        self.conferenceButton.selected = NO;
        self.viewSpaceMask = 0;
    }
    self.conferenceButton.enabled = YES;
}

/// @abstract 因产生了某个 error 的回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.conferenceButton.enabled = YES;
    [self showAlertWithMessage:[NSString stringWithFormat:@"Error code: %ld, %@", (long)error.code, error.localizedDescription] completion:^{
        [self backButtonClick:nil];
    }];
}

- (PLRTCVideoRender *)mediaStreamingSession:(PLMediaStreamingSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID {
    NSInteger space = 0;
    if (!(self.viewSpaceMask & 0x01)) {
        self.viewSpaceMask |= 0x01;
        space = 1;
    }
    else if (!(self.viewSpaceMask & 0x02)) {
        self.viewSpaceMask |= 0x02;
        space = 2;
    }
    else {
        //超出 3 个连麦观众，不再显示。
        return nil;
    }
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat width = screenSize.width * 108 / 368.0;
    CGFloat height = screenSize.height * 192 / 640.0;
    PLRTCVideoView *remoteView = [[PLRTCVideoView alloc] initWithFrame:CGRectMake(screenSize.width - width, screenSize.height - height * space, width, height)];
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(width - 40, 0, 40, 40)];
    [button setTitle:@"踢出" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button addTarget:self action:@selector(kickoutButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [remoteView addSubview:button];
    
    [self addGestureOnView:remoteView];
    
    [self.userViewDictionary setObject:remoteView forKey:userID];
    [self.view bringSubviewToFront:self.conferenceButton];
    
    CGSize videoSize = videoSizeMap[self.settingView.settings.rtcSizePreset];
    CGSize remoteVideoSize = CGSizeMake(videoSize.width / 3, videoSize.height / 3);
    PLRTCVideoRender *render = [[PLRTCVideoRender alloc] init];
    render.renderView = remoteView;
    switch (space) {
        case 1:
            render.mixOverlayRect = CGRectMake(videoSize.width - remoteVideoSize.width, videoSize.height - remoteVideoSize.height, remoteVideoSize.width, remoteVideoSize.height);
            break;
        case 2:
            render.mixOverlayRect = CGRectMake(videoSize.width - remoteVideoSize.width * 2, videoSize.height - remoteVideoSize.height * 2, remoteVideoSize.width, remoteVideoSize.height);
            break;
        default:
            break;
    }
    return render;
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView {
    //如果有做大小窗口切换，当被 Detach 的窗口是全屏窗口时，用 removedPoint 记录自己的预览的窗口的位置，然后把自己的预览的窗口切换成全屏窗口显示
    CGPoint removedPoint = CGPointZero;
    if (remoteView == self.fullscreenView) {
        removedPoint = self.session.previewView.center;
        self.fullscreenView = nil;
        self.tappedView = self.session.previewView;
        [self animationToFullscreenWithView:self.tappedView];
    }
    else {
        removedPoint = remoteView.center;
    }
    
    [remoteView removeFromSuperview];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = screenSize.height * 192 / 640.0;
    if (self.view.frame.size.height - removedPoint.y < height) {
        self.viewSpaceMask &= 0xFE;
    }
    else {
        self.viewSpaceMask &= 0xFD;
    }
    
    [self.userViewDictionary removeObjectForKey:userID];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didKickoutByUserID:(NSString *)userID {
    [self.session stopConference];
    [self showAlertWithMessage:@"您被主播踢出房间了！" completion:^{
        [self backButtonClick:nil];
    }];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didJoinConferenceOfUserID:(NSString *)userID {
    self.textView.text = [NSString stringWithFormat:@"%@userID: %@ didJoinConference\n", self.textView.text, userID];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLeaveConferenceOfUserID:(NSString *)userID {
    self.textView.text = [NSString stringWithFormat:@"%@userID: %@ didLeaveConference\n", self.textView.text, userID];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level {
    NSLog(@"userID = %@\nvoiceLevel = %ld",userID,level);
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value {
    NSLog(@"AVStatistic: userID: %@, tpye = %d, value: %d",userID,type,value);
}

@end
