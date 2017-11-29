//
//  LoginViewController.m
//  PLMediaStreamingKitDemo
//
//  Created by 何昊宇 on 16/9/20.
//  Copyright © 2016年 NULL. All rights reserved.
//

#import "LoginViewController.h"
#import "AppServerBase.h"
#import "PLHomeViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passwordTextField.delegate = self;
    self.nameAddressTextField.delegate = self;
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"请登录";
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (([userDefaults objectForKey:@"name"] != nil) && ([userDefaults objectForKey:@"password"] != nil)) {
        self.nameAddressTextField.text = [userDefaults objectForKey:@"name"];
        self.passwordTextField.text = [userDefaults objectForKey:@"password"];
    }
}

- (IBAction)loginAction:(id)sender {
    
    if ([self.nameAddressTextField.text isEqualToString:@""]) {
        [self showAlertWithMessage:@"用户名不能为空" completion:nil];
        return;
    }
    if ([self.passwordTextField.text isEqualToString:@""]) {
        [self showAlertWithMessage:@"密码不能为空" completion:nil];
        return;
    }
    [AppServerBase loginWithName:self.nameAddressTextField.text password:self.passwordTextField.text completed:^(NSError *error) {
        if (!error) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self showAlertWithMessage:@"登陆失败" completion:nil];
        }
    }];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nameAddressTextField endEditing:YES];
    [self.passwordTextField endEditing:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
