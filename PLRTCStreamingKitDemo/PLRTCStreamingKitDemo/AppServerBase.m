//
//  AppServerBase.m
//  PLMediaStreamingKitDemo
//
//  Created by 何昊宇 on 2017/11/21.
//  Copyright © 2017年 NULL. All rights reserved.
//

#import "AppServerBase.h"

#define QINIUBaseDomain @"https://api-demo-v2.qnsdk.com"

@interface AppServerBase()

@end

@implementation AppServerBase

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+ (void)loginWithName:(NSString *)name password:(NSString *)password completed:(void (^)(NSError *error))handler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/login",QINIUBaseDomain]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    // 2.设置请求头
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // 3.设置请求体
    NSDictionary *json =@{@"name":name,
                          @"password":password};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableData *tempJsonData = [NSMutableData dataWithData:postData];
    request.HTTPBody = tempJsonData;
    request.timeoutInterval = 10;
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"login faild, %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error);
            });
            return;
        }
        
        NSDictionary *userDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (userDic == nil) {
            NSLog(@"user decode error %@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error);
            });
            return;
        }
        
        if ([userDic[@"code"] integerValue] != 200) {
            NSError * userDicError = [NSError errorWithDomain:@"pili/v1/login" code:userDic[@"code"] userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"no authorized"]}];
            NSLog(@"no authorized %@", userDicError);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(userDicError);
            });
            return;
        }
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        [userDefaults setObject:name forKey:@"name"];
        [userDefaults synchronize];
        [userDefaults setObject:password forKey:@"password"];
        [userDefaults synchronize];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil);
        });
        
    }];
    [task resume];
    
}

+ (void)getPublishAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSError *error, NSString *urlString))handler {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/stream/%@",QINIUBaseDomain, roomName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [AppServerBase AuthorizationFromText] };
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error, nil);
            });
            return;
        }
        
        NSDictionary *userDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if ([userDic[@"code"] integerValue] != 200) {
            NSError * userDicError = [NSError errorWithDomain:@"pili/v1/login" code:userDic[@"code"] userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"no authorized"]}];
            NSLog(@"no authorized %@", userDicError);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(userDicError,nil);
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, userDic[@"url"]);
        });
        
    }];
    [task resume];
    
}

+ (void)getPlayAddrWithRoomname:(NSString *)roomName completed:(void (^)(NSString *playUrl))handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/stream/query/%@",QINIUBaseDomain, roomName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = 10;
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [AppServerBase AuthorizationFromText] };
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil || response == nil || data == nil) {
            NSLog(@"get play url faild, %@, %@, %@", error, response, data);
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil);
            });
            return;
        }
        NSDictionary *userDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        
        if (userDic == nil || [userDic[@"code"] integerValue] != 200) {
            NSLog(@"no authorized");
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(nil);
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(userDic[@"rtmp"]);
        });
    }];
    [task resume];
}

+ (void)getRTCTokenWithRoomToken:(NSString *)roomName userID:(NSString *)userID completed:(void (^)(NSError *error, NSString *token))handler {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    config.HTTPAdditionalHeaders = @{@"Authorization": [AppServerBase AuthorizationFromText] };
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/pili/v1/room/token",QINIUBaseDomain]];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"Room":roomName,@"user":userID,@"version":@"2.0"} options:NSJSONWritingPrettyPrinted error:nil];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 10;
    request.HTTPBody = jsonData;
    NSURLSessionDataTask *task = [[NSURLSession sessionWithConfiguration:config] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                handler(error, nil);
            });
            return;
        }
        
        NSString *token = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(nil, token);
        });
    }];
    [task resume];
    
}


+ (NSString *)AuthorizationFromText
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * Authorization =[NSString stringWithFormat:@"%@:%@",[userDefaults objectForKey:@"name"],[userDefaults objectForKey:@"password"]];
    
    NSData* originData = [Authorization dataUsingEncoding:NSASCIIStringEncoding];
    
    NSString* encodeResult = [originData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeResult;
}

@end
