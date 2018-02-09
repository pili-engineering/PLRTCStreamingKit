//
//  PLRTCChiefViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCChiefViewController.h"
#import <PLRTCStreamingKit/PLRTCSession.h>
#import "AppServerBase.h"

const static char *rtcStateNames[] = {
    "PLRTCStateConferenceUnInit",
    "PLRTCStateConferenceInited",
    "ConferenceStarted",
    "ConferenceStopped"
};

@interface PLRTCChiefViewController ()<PLRTCSessionDelegate>

@property (nonatomic, strong) UIButton *conferenceButton;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *audioButton;
@property (nonatomic, strong) UIButton *videoButton;
@property (nonatomic, strong) UIButton *toggleButton;

@property (nonatomic, strong) PLRTCSession *session;

@property (nonatomic, assign) NSUInteger viewSpaceMask;

@property (nonatomic, strong) NSString *    userID;
@property (nonatomic, strong) NSString *    roomToken;

@end

@implementation PLRTCChiefViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.userID = [[NSUUID UUID] UUIDString];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:YES];
    
    [self setupUI];
    [self initRTCSession];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleApplicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)setupUI
{
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 66, 66)];
    [self.backButton setTitle:@"返回" forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backButton];
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    self.conferenceButton = [[UIButton alloc] initWithFrame:CGRectMake(20, size.height - 66, 66, 66)];
    [self.conferenceButton setTitle:@"连麦" forState:UIControlStateNormal];
    [self.conferenceButton setTitle:@"停止" forState:UIControlStateSelected];
    [self.conferenceButton.titleLabel setFont:[UIFont systemFontOfSize:22]];
    [self.conferenceButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.conferenceButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.conferenceButton addTarget:self action:@selector(conferenceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.conferenceButton];
    self.conferenceButton.enabled = NO;
    
    self.audioButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width / 2 - 33, size.height - 66, 88, 66)];
    [self.audioButton setTitle:@"发布音频" forState:UIControlStateNormal];
    [self.audioButton setTitle:@"取消发布" forState:UIControlStateSelected];
    [self.audioButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.audioButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.audioButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.audioButton addTarget:self action:@selector(audioButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.audioButton];
    self.audioButton.enabled = NO;
    self.audioButton.hidden = self.isViewer;
    
    self.videoButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 88 - 20, size.height - 66, 88, 66)];
    [self.videoButton setTitle:@"发布视频" forState:UIControlStateNormal];
    [self.videoButton setTitle:@"取消发布" forState:UIControlStateSelected];
    [self.videoButton.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [self.videoButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.videoButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.1] forState:UIControlStateDisabled];
    [self.videoButton addTarget:self action:@selector(videoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.videoButton];
    self.videoButton.enabled = NO;
    self.videoButton.hidden = self.isViewer;
    
    self.toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(size.width - 66 - 20, 20, 66, 66)];
    [self.toggleButton setTitle:@"切换" forState:UIControlStateNormal];
    [self.toggleButton addTarget:self action:@selector(toggleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.toggleButton];
}

- (void)initRTCSession
{
    [PLRTCSession enableLogging];
    self.session = [[PLRTCSession alloc] initWithVideoCaptureConfiguration:[PLVideoCaptureConfiguration defaultConfiguration] audioCaptureConfiguration:[PLAudioCaptureConfiguration defaultConfiguration]];
    
    UIImage *waterMark = [UIImage imageNamed:@"qiniu.png"];
    [self.session setWaterMarkWithImage:waterMark position:CGPointMake(100, 100)];
    self.session.previewView.frame = self.view.bounds;
    [self.view insertSubview:self.session.previewView atIndex:0];
    [self.session setBeautifyModeOn:YES];
    self.session.stateDelegate = self;
    
    if (!self.isViewer) {
        [self.session startVideoCapture];
    }
    
    [AppServerBase getRTCTokenWithRoomToken:self.roomName userID:self.userID completed:^(NSError *error, NSString *token) {
        if (error) {
            [self showAlertWithMessage:error.localizedDescription completion:^{
                [self backButtonClick:nil];
                return ;
            }];
            
            return;
        }
        
        self.roomToken = token;
        
        [self.session setWithServerRegionID:PLRTC_SERVER_REGION_DEFAULT serverRegionName:@""];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClick:(id)sender
{
    self.session.stateDelegate = nil;
    [self.session destroy];
    self.session = nil;
    
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
    if (!self.conferenceButton.isSelected) {
        PLRTCConfiguration *configuration = [[PLRTCConfiguration alloc] initWithVideoSizePreset:PLRTCVideoSizePreset368x640];
        [self.session startConferenceWithRoomName:self.roomName userID:self.userID roomToken:self.roomToken rtcConfiguration:configuration];
        
        self.session.rtcMinVideoBitrate= 100 * 1000;
        self.session.rtcMaxVideoBitrate= 300 * 1000;
    }
    else {
        [self.session stopConference];
    }
    return;
}

- (IBAction)audioButtonClick:(id)sender {
    if (self.session.state != PLRTCStateConferenceStarted) {
        return;
    }
    
    self.audioButton.enabled = NO;
    if (!self.audioButton.selected) {
        [self.session publishLocalAudioWithCompletionHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.audioButton.enabled = YES;
                if (error) {
                    NSLog(@"publishLocalAudioWithCompletionHandler error: %@", error);
                    return ;
                }
                
                self.audioButton.selected = YES;
                [self.session startAudioCapture];
            });
        }];
    }
    else {
        [self.session unpublishLocalAudio];
        self.audioButton.selected = NO;
        self.audioButton.enabled = YES;
    }
}

- (IBAction)videoButtonClick:(id)sender {
    if (self.session.state != PLRTCStateConferenceStarted) {
        return;
    }
    
    self.videoButton.enabled = NO;
    if (!self.videoButton.isSelected) {
        [self.session publishLocalVideoWithCompletionHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.videoButton.enabled = YES;
                if (error) {
                    [self showAlertWithMessage:error.localizedDescription completion:nil];
                    return ;
                }
                
                self.videoButton.selected = YES;
            });
        }];
    }
    else {
        [self.session unpublishLocalVideo];
        self.videoButton.selected = NO;
        self.videoButton.enabled = YES;
    }
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
    NSLog(@"PLRTCChiefViewController dealloc");
}

#pragma mark - observer

- (void)handleApplicationDidEnterBackground:(NSNotification *)notification {
    if (self.session.isRunning) {
        [self.session stopConference];
        self.conferenceButton.enabled = YES;
    }
}

#pragma mark - 连麦回调

- (void)rtcSession:(PLRTCSession *)session stateDidChange:(PLRTCState)state {
    NSString *log = [NSString stringWithFormat:@"RTC State: %s", rtcStateNames[state]];
    NSLog(@"%@", log);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (state == PLRTCStateConferenceInited) {
            self.conferenceButton.enabled = YES;
        }
        
        if (state == PLRTCStateConferenceStarted) {
            self.conferenceButton.selected = YES;
            self.conferenceButton.enabled = YES;
            self.videoButton.enabled = YES;
            self.audioButton.enabled = YES;
            
        } else if (state == PLRTCStateConferenceStopped){
            self.conferenceButton.selected = NO;
            self.conferenceButton.enabled = YES;
            
            self.videoButton.enabled = NO;
            self.audioButton.enabled = NO;
            self.videoButton.selected = NO;
            self.audioButton.selected = NO;
            
            ///停止连麦后停止麦克风采集
            [self.session stopAudioCapture];
            self.viewSpaceMask = 0;
        }
    });
}

/// @abstract 因产生了某个 error 的回调
- (void)rtcSession:(PLRTCSession *)session didFailWithError:(NSError *)error {
    NSLog(@"error: %@", error);
    self.conferenceButton.enabled = YES;
    [self showAlertWithMessage:[NSString stringWithFormat:@"Error code: %ld, %@", (long)error.code, error.localizedDescription] completion:^{
        [self backButtonClick:nil];
    }];
}

- (PLRTCVideoRender *)rtcSession:(PLRTCSession *)session firstVideoFrameDecodedOfUserID:(NSString *)userID {
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
    CGFloat width = screenSize.width * 108 / 368;
    CGFloat height = screenSize.height * 192 / 640.0;
    PLRTCVideoView *remoteView = [[PLRTCVideoView alloc] initWithFrame:CGRectMake(screenSize.width - width, screenSize.height - height * space, width, height)];
    remoteView.clipsToBounds = YES;
    [self.view addSubview:remoteView];
    [self.view bringSubviewToFront:self.videoButton];
    
    PLRTCVideoRender *render = [[PLRTCVideoRender alloc] init];
    render.renderView = remoteView;
    return render;
}

- (void)rtcSession:(PLRTCSession *)session userID:(NSString *)userID didDetachRemoteView:(UIView *)remoteView {
    //如果有做大小窗口切换，当被 Detach 的窗口是全屏窗口时，用 removedPoint 记录自己的预览的窗口的位置，然后把自己的预览的窗口切换成全屏窗口显示
    CGPoint removedPoint = remoteView.center;
    [remoteView removeFromSuperview];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGFloat height = screenSize.height * 192 / 640.0;
    if (self.view.frame.size.height - removedPoint.y < height) {
        self.viewSpaceMask &= 0xFE;
    }
    else {
        self.viewSpaceMask &= 0xFD;
    }
}

- (void)rtcSession:(PLRTCSession *)session didJoinConferenceOfUserID:(NSString *)userID {
    NSLog(@"userID: %@ didJoinConference", userID);
}

- (void)rtcSession:(PLRTCSession *)session didLeaveConferenceOfUserID:(NSString *)userID {
    NSLog(@"userID: %@ didLeaveConference", userID);
}

#pragma mark - 视频数据回调

/// @abstract 获取到摄像头原数据时的回调, 便于开发者做滤镜等处理，需要注意的是这个回调在 camera 数据的输出线程，请不要做过于耗时的操作
- (CVPixelBufferRef)rtcSession:(PLRTCSession *)session cameraSourceDidGetPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    
    //此处可以做美颜等处理
    
    return pixelBuffer;
}


@end
