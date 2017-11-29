//
//  PLRTCSettingViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCSettingViewController.h"

@interface PLRTCSettingViewController ()
@property (nonatomic, strong) IBOutlet UITextField *textField;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

@end

@implementation PLRTCSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roomName;
    
    roomName = [userDefaults objectForKey:@"PLRTCRoomName"];
    self.textField.text = roomName;
    
    NSDictionary *info= [[NSBundle mainBundle] infoDictionary];
    self.versionLabel.text = [NSString stringWithFormat:@"版本：%@", info[@"CFBundleShortVersionString"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClick:(id)sender
{
    if (!self.textField.text  || [self.textField.text isEqualToString:@""]) {
        [self showAlertWithMessage:@"房间名不能为空"];
        return;
    }
    
    [self.view endEditing:YES];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.textField.text forKey:@"PLRTCRoomName"];
    [userDefaults synchronize];
    [self showAlertWithMessage:@"保存成功"];
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
