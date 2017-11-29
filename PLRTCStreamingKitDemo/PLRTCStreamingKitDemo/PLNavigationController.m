//
//  PLNavigationController.m
//  PLMediaStreamingKitDemo
//
//  Created by WangSiyu on 9/14/16.
//  Copyright © 2016 Pili. All rights reserved.
//

#import "PLNavigationController.h"

@interface PLNavigationController ()

@end

@implementation PLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

@end
