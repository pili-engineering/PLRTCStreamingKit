//
//  MasterViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by lawder on 16/6/30.
//  Copyright © 2016年 NULL. All rights reserved.
//

#import "PLHomeViewController.h"
#import "PLRTCStreamingMasterViewController.h"
#import "PLRTCMasterViewController.h"
#import "LoginViewController.h"

@interface PLHomeViewController ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation PLHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    LoginViewController * loginViewController = [[LoginViewController alloc] init];
    [self presentViewController:loginViewController animated:YES completion:nil];
    self.title = @"首页";

    self.objects = @[@"PLRTCStreamingKitDemo", @"PLRTCKitDemo"];

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = self.objects[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        PLRTCStreamingMasterViewController *rtcStreamingViewController = [[PLRTCStreamingMasterViewController alloc] init];
        [self.navigationController pushViewController:rtcStreamingViewController animated:YES];
        return;
    }

    if (indexPath.row == 1) {
        PLRTCMasterViewController *rtcViewController = [[PLRTCMasterViewController alloc] init];
        [self.navigationController pushViewController:rtcViewController animated:YES];
        return;
    }
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

@end
