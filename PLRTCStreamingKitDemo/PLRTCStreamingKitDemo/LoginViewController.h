//
//  LoginViewController.h
//  PLMediaStreamingKitDemo
//
//  Created by 何昊宇 on 16/9/20.
//  Copyright © 2016年 NULL. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SVProgressHUD.h"

@interface LoginViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameAddressTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end
