//
//  PLRTCStreamingViewerViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import <PLRTCStreamingKit/PLRTCStreamingKit.h>
#import "PLRTCStreamingViewerViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "PLRTCStreamingViewerViewController.h"
#import "PLRTCStreamingSettingView.h"
#import "AppServerBase.h"

const static char *rtcStateNames[] = {
    "PLRTCStateConferenceUnInit",
    "PLRTCStateConferenceInited",
    "ConferenceStarted",
    "ConferenceStopped"
};

const static NSString *playerStatusNames[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};

@interface PLRTCStreamingViewerViewController ()<PLMediaStreamingSessionDelegate, PLPlayerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate, PLRTCStreamingSettingViewDelegate>

@property (nonatomic, strong) UIButton *actionButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *toggleButton;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *muteButton;

@property (nonatomic, strong) PLMediaStreamingSession *session;
@property (nonatomic, strong) PLPlayer *player;

@property (nonatomic, assign) NSUInteger viewSpaceMask;

@property (nonatomic, strong) NSMutableDictionary *userViewDictionary;
@property (nonatomic, strong) NSString *    userID;
@property (nonatomic, strong) NSString *    roomToken;

@property (nonatomic, assign) NSInteger reconnectCount;

@property (nonatomic, strong) UIView *fullscreenView;
@property (nonatomic, strong) UIView *tappedView;
@property (nonatomic, assign) CGRect originRect;

@property (nonatomic, strong) UIButton *settingButton;
@property (nonatomic, strong) PLRTCStreamingSettingView *settingView;

@end

@implementation PLRTCStreamingViewerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    self.userViewDictionary = [[NSMutableDictionary alloc] initWithCapacity:3];
    self.reconnectCount = 0;
    
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
    [self initPlayer];
}

- (void)setupUI
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 66, 66)];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, size.height - 66, 66, 66)];
    [self.conferenceButton setTitle:@"连麦" forState:UIControlStateNormal];
    [self.conferenceButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.conferenceButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.conferenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.conferenceButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceButton];
    self.conferenceButton.hidden = YES;
    
    self.muteButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - 33, size.height - 66, 66, 66)];
    [self.muteButton setTitle:@"静音" forState:UIControlStateNormal];
    [self.muteButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.muteButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
    [self.muteButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.muteButton addTarget:self action:@selector(muteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.muteButton];
    
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
        self.toggleButton.hidden = YES;
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
                        audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration] videoStreamingConfiguration:nil audioStreamingConfiguration:nil stream:nil];
        self.session.delegate = self;
    }
    else {
        PLVideoCaptureConfiguration *videoCap = [PLVideoCaptureConfiguration defaultConfiguration];
        videoCap.sessionPreset = AVCaptureSessionPreset1280x720;
        self.session = [[PLMediaStreamingSession alloc]
                        initWithVideoCaptureConfiguration:videoCap
                        audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration] videoStreamingConfiguration:nil audioStreamingConfiguration:nil stream:nil];
        self.session.delegate = self;
        self.session.previewView.frame = self.view.bounds;
        self.fullscreenView = self.session.previewView;
        [self addGestureOnView:self.fullscreenView];
        if (self.userType == PLMediaUserTypeSecondChief) {
            self.toggleButton.hidden = NO;
            [self.view insertSubview:self.session.previewView atIndex:0];
        }
        [self.session setBeautifyModeOn:YES];
    }
    
    self.userID = [[NSUUID UUID] UUIDString];
    [AppServerBase getRTCTokenWithRoomToken:self.roomName userID:self.userID completed:^(NSError *error, NSString *token) {
        if (!token) {
            [self showAlertWithMessage:[NSString stringWithFormat:@"Demo request token failed, error: %@", error] completion:^{
                [self backButtonClick:nil];
            }];
            return ;
        }
        self.roomToken = token;
    }];
    
    [self.session setWithServerRegionID:PLRTC_SERVER_REGION_DEFAULT serverRegionName:@""];
}

- (void)initPlayer
{
    if (self.userType == PLMediaUserTypeViewer) {
        PLPlayerOption *option = [PLPlayerOption defaultOption];
        [AppServerBase getPlayAddrWithRoomname:self.roomName completed:^(NSString *playUrl) {
            if (!playUrl) {
                [self showAlertWithMessage:[NSString stringWithFormat:@"Demo request play url failed"] completion:^{
                    [self backButtonClick:nil];
                }];
                return ;
            }
            
            self.player = [PLPlayer playerWithURL:[NSURL URLWithString:playUrl] option:option];
            self.player.delegate = self;
            if (!self.audioOnly) {
                [self.view addSubview:self.player.playerView];
                [self.view sendSubviewToBack:self.player.playerView];
            }
            [self.player play];
        }];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- PLMediaSettingViewDelegate
- (void)rtcStreamingSettingView:(PLRTCStreamingSettingView *)rtcStreamingSettingView {
    [self resetSession];
}

- (void)resetSession {
    if (self.userType == PLMediaUserTypeSecondChief) {
        self.viewSpaceMask = 0;
        self.conferenceButton.selected = NO;
        self.conferenceButton.enabled = YES;
        self.muteButton.selected = NO;
        
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
        
        return;
    }
    
    if (self.userType == PLMediaUserTypeViewer) {
        self.viewSpaceMask = 0;
        self.conferenceButton.selected = NO;
        self.conferenceButton.enabled = YES;
        self.muteButton.selected = NO;
        
        if (!self.audioOnly) {
            NSArray *remoteViews = [self.userViewDictionary allValues];
            for (UIView *view in remoteViews) {
                [view removeFromSuperview];
            }
            self.toggleButton.hidden = YES;
            if (self.session.previewView.superview) {
                [self.session.previewView removeFromSuperview];
            }
            self.player.playerView.hidden = NO;
        }
        [self.player play];
        
        self.session.delegate = nil;
        [self.session destroy];
        self.session = nil;
        
        [self initStreamingSession];
        
        return;
    }
}

#pragma mark -- button clicked events
- (void)settingButtonClick:(id)sender {
    [self.settingView show];
}

- (void)kickoutByUserIDEvent:(id)sender {
    [self resetSession];
}

- (IBAction)backButtonClick:(id)sender
{
    self.session.delegate = nil;
    [self.session destroy];
    self.session = nil;
    
    self.player.delegate = nil;
    self.player = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO];
}

- (IBAction)toggleButtonClick:(id)sender
{
    [self.session toggleCamera];
}

- (IBAction)conferenceButtonClick:(id)sender
{
    self.conferenceButton.enabled = NO;
    if (self.userType == PLMediaUserTypeSecondChief) {
        if (!self.conferenceButton.selected) {
            PLRTCConferenceType conferenceType = self.audioOnly ? PLRTCConferenceTypeAudio : PLRTCConferenceTypeAudioAndVideo;
            PLRTCConfiguration *configuration = [[PLRTCConfiguration alloc] initWithVideoSizePreset:(PLRTCVideoSizePreset)self.settingView.settings.rtcSizePreset conferenceType:conferenceType];
            configuration.videoSizePreset = (PLRTCVideoSizePreset)self.settingView.settings.rtcSizePreset;
            self.session.rtcMinVideoBitrate= 300 * 1000;
            self.session.rtcMaxVideoBitrate= 800 * 1000;
            
            [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
        }
        else {
            [self.session stopConference];
        }
        
        return;
    }
    
    if (self.userType == PLMediaUserTypeViewer) {
        if (!self.conferenceButton.selected) {
            [self.player pause];
            
            if (!self.audioOnly) {
                self.player.playerView.hidden = YES;
                if (!self.session.previewView.superview) {
                    self.session.previewView.frame = self.view.bounds;
                    self.fullscreenView = self.session.previewView;
                    [self.view insertSubview:self.session.previewView atIndex:0];
                }
                self.toggleButton.hidden = NO;
            }
            
            PLRTCConferenceType conferenceType = self.audioOnly ? PLRTCConferenceTypeAudio : PLRTCConferenceTypeAudioAndVideo;
            PLRTCConfiguration *configuration = [[PLRTCConfiguration alloc] initWithVideoSizePreset:(PLRTCVideoSizePreset)self.settingView.settings.rtcSizePreset conferenceType:conferenceType];
            [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
            self.session.rtcMinVideoBitrate= 300 * 1000;
            self.session.rtcMaxVideoBitrate= 800 * 1000;
        }
        else {
            [self.session stopConference];
            if (!self.audioOnly) {
                self.toggleButton.hidden = YES;
                if (self.session.previewView.superview) {
                    [self.session.previewView removeFromSuperview];
                }
                self.player.playerView.hidden = NO;
            }
            [self.player play];
        }
        
        return;
    }
}

- (IBAction)muteButtonClick:(id)sender
{
    if (self.session.isRtcRunning) {
        self.muteButton.selected = !self.muteButton.selected;
    }
    self.session.muted = self.muteButton.selected;
    self.session.muteMixedAudio = self.muteButton.selected;
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

- (void)alertShow:(NSString *)message completion:(void (^)(void))completion
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (completion) {
            completion();
        }
    }]];
    [self presentViewController:controller animated:YES completion:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(dismissAlert:) userInfo:controller repeats:NO];
    
}

- (void)dismissAlert:(NSTimer *)timer{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
        UIAlertView *alert = [timer userInfo];
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
        alert = nil;
    } else {
        UIAlertController *alert = [timer userInfo];
        [alert dismissViewControllerAnimated:YES completion:nil];
        alert = nil;
    }
}

- (void)dealloc
{
    NSLog(@"PLRTCStreamingViewerViewController dealloc");
}

#pragma mark - observer

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    if (!self.session.isRtcRunning) {
        return;
    }
    
    self.conferenceButton.enabled = YES;
    if (self.userType == PLMediaUserTypeSecondChief) {
        [self.session stopConference];
        return;
    }
    
    if (self.userType == PLMediaUserTypeViewer) {
        [self.session stopConference];
        if (!self.audioOnly) {
            self.toggleButton.hidden = YES;
            if (self.session.previewView.superview) {
                [self.session.previewView removeFromSuperview];
            }
            self.player.playerView.hidden = NO;
        }
        [self.player play];
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

#pragma mark - 连麦回调

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcStateDidChange:(PLRTCState)state {
    NSString *log = [NSString stringWithFormat:@"RTC State: %s", rtcStateNames[state]];
    NSLog(@"%@", log);
    self.textView.text = [NSString stringWithFormat:@"%@%@\n", self.textView.text, log];
    if (state == PLRTCStateConferenceInited) {
        self.conferenceButton.hidden = NO;
        NSLog(@"rtc init successed");
    }
    if (state == PLRTCStateConferenceStarted) {
        self.conferenceButton.enabled = YES;
        self.conferenceButton.selected = YES;
    }
    else {
        self.conferenceButton.enabled = YES;
        self.conferenceButton.selected = NO;
        self.viewSpaceMask = 0;
    }
}

/// @abstract 因产生了某个 error 的回调
- (void)mediaStreamingSession:(PLMediaStreamingSession *)session rtcDidFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.conferenceButton.enabled = YES;
    self.conferenceButton.selected = NO;
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
    CGFloat width = screenSize.width * 108 / 352.0;
    CGFloat height = screenSize.height * 192 / 640.0;
    PLRTCVideoView *remoteView = [[PLRTCVideoView alloc] initWithFrame:CGRectMake(screenSize.width - width, screenSize.height - height * space, width, height)];
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    
    [self addGestureOnView:remoteView];
    
    [self.userViewDictionary setObject:remoteView forKey:userID];
    [self.view bringSubviewToFront:self.conferenceButton];
    
    PLRTCVideoRender *render = [[PLRTCVideoRender alloc] init];
    render.renderView = remoteView;
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
    [self showAlertWithMessage:@"您被主播踢出房间了！" completion:^{
        [self kickoutByUserIDEvent:nil];
    }];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didJoinConferenceOfUserID:(NSString *)userID {
    self.textView.text = [NSString stringWithFormat:@"%@userID: %@ didJoinConference\n", self.textView.text, userID];
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session didLeaveConferenceOfUserID:(NSString *)userID {
    self.textView.text = [NSString stringWithFormat:@"%@userID: %@ didLeaveConference\n", self.textView.text, userID];
}

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    NSLog(@"%@", playerStatusNames[state]);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    NSLog(@"player error: %@", error);
    
    if (self.session.rtcState == PLRTCStateConferenceStarted) {
        return;
    }
    
    self.reconnectCount ++;
    NSString *errorMessage = [NSString stringWithFormat:@"Error code: %ld, %@, 播放器将在%.1f秒后进行第 %ld 次重连", (long)error.code, error.localizedDescription, 0.5 * pow(2, self.reconnectCount - 1), (long)self.reconnectCount];
    [self alertShow:errorMessage completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player play];
    });
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session userID:(NSString *)userID voiceLevel:(NSInteger)level {
    NSLog(@"userID = %@\nvoiceLevel = %ld",userID,level);
}

- (void)mediaStreamingSession:(PLMediaStreamingSession *)session AVStatisticOfUserID:(NSString *)userID type:(PLRTCAVStatisticType)type value:(NSInteger)value {
    NSLog(@"AVStatistic: userID: %@, tpye: %d, value: %d",userID, type, value);
}

@end
