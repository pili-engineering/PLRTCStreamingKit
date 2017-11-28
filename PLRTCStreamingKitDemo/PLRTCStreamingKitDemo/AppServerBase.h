//
//  AppServerBase.h
//  PLMediaStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/21.
//  Copyright © 2017年 NULL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppServerBase : NSObject

/*!
 * @abstract 登陆
 *
 * @param name 用户名
 *
 * @param password 用户密码
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(nil) 即可
 */
+ (void)loginWithName:(NSString *)name password:(NSString *)password completed:(void (^)(NSError *error))handler;
/*!
 * @abstract 获取推流 URL
 *
 * @param roomName 房间名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(nil, @"推流 URL") 即可
 */
+ (void)getPublishAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSError *error, NSString *urlString))handler;
/*!
 * @abstract 获取播放 URL
 *
 * @param roomName 房间名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(@"播放 URL") 即可
 */
+ (void)getPlayAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSString *playUrl))handler;
/*!
 * @abstract 连麦 roomToken
 *
 * @param roomName 房间名
 *
 * @param userID 连麦用户名
 *
 * @discussion 若不需要登录，可直接注销方法内部代码，替换成 handler(nil, @"连麦 token") 即可
 */
+ (void)getRTCTokenWithRoomToken:(NSString *)roomName userID:(NSString *)userID completed:(void (^)(NSError *error, NSString *token))handler;

@end
