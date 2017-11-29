//
//  PLRTCMasterViewController.m
//  PLRTCStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/28.
//  Copyright © 2017年 Aaron. All rights reserved.
//

#import "PLRTCMasterViewController.h"
#import "PLRTCChiefViewController.h"
#import "PLRTCSettingViewController.h"

@interface PLRTCMasterViewController ()

@property NSArray *objects;

@end

@implementation PLRTCMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"PLRTCKitDemo";
    
    self.objects = @[@"主播", @"观众"];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingButtonClick:)];
    self.navigationItem.rightBarButtonItem = item;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)settingButtonClick:(id)sender
{
    PLRTCSettingViewController *settingViewController = [[PLRTCSettingViewController alloc] init];
    [self.navigationController pushViewController:settingViewController animated:YES];
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
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *roomName = [userDefaults objectForKey:@"PLRTCRoomName"];
    if (!roomName || [roomName isEqualToString:@""]) {
        [self showAlertWithMessage:@"请先在设置界面设置您的 roomName"];
        return;
    }
    
    if (indexPath.row == 0) {
        PLRTCChiefViewController *controller = [[PLRTCChiefViewController alloc] init];
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.roomName = roomName;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
    else {
        PLRTCChiefViewController *controller = [[PLRTCChiefViewController alloc] init];
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        controller.roomName = roomName;
        controller.isViewer = YES;
        [self.navigationController pushViewController:controller animated:YES];
        return;
    }
}

- (void)showAlertWithMessage:(NSString *)message
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"错误" message:message preferredStyle:UIAlertControllerStyleAlert];
    [controller addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:controller animated:YES completion:nil];
}
@end
