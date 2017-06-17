//
//  AppDelegate+Push.m
//  Jiandan
//
//  Created by leo on 17/6/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import "AppDelegate+Push.h"

#import <WeexSDK/WeexSDK.h>
#import <CloudPushSDK/CloudPushSDK.h>
@implementation AppDelegate (Push)
- (void)initCloudPush:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // SDK初始化
    [CloudPushSDK asyncInit:@"24303407" appSecret:@"8d50a4afe9377c658fdaa5ea025a747d" callback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
        } else {
            NSLog(@"Push SDK init failed, error: %@", res.error);
        }
    }];
    [CloudPushSDK sendNotificationAck:launchOptions];
    [self registerAPNS:application];
    
    if (launchOptions != nil && launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
        NSDictionary *userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self pushToMiddleWeexPage:userInfo];
        });
    }
}
/**
 *    注册苹果推送，获取deviceToken用于推送
 */
- (void)registerAPNS:(UIApplication *)application {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:
         [UIUserNotificationSettings settingsForTypes: (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [application registerForRemoteNotifications];
    }
    //    else {
    //        // iOS < 8 Notifications
    //        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
    //         (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
    //    }
}
/*
 *  苹果推送注册成功回调，将苹果返回的deviceToken上传到CloudPush服务器
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [CloudPushSDK registerDevice:deviceToken withCallback:^(CloudPushCallbackResult *res) {
        if (res.success) {
            NSLog(@"Register deviceToken success.");
        } else {
            NSLog(@"Register deviceToken failed, error: %@", res.error);
        }
    }];
}
/*
 *  苹果推送注册失败回调
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

/**
 *    注册推送消息到来监听
 */
- (void)registerMessageReceive {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
}
/**
 *    处理到来推送消息
 */
- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    NSLog(@"Receive message title: %@, content: %@.", title, body);
}


/*
 *  App处于启动状态时，通知打开回调
 */
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo {
    
    NSLog(@"Receive one notification.");
    // 取得APNS通知内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    // 内容
    NSString *content = [aps valueForKey:@"alert"];
    // badge数量
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    // 播放声音
    NSString *sound = [aps valueForKey:@"sound"];
    // 取得Extras字段内容
    NSDictionary *extraMap = [userInfo valueForKey:@"extraMap"]; //服务端中Extras字段，key是自己定义的
    NSLog(@"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]", content, (long)badge, sound, extraMap);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    // [CloudPushSDK handleReceiveRemoteNotification:userInfo];(Deprecated from v1.8.1)
    [CloudPushSDK sendNotificationAck:userInfo];
    
    
    if (application.applicationState != UIApplicationStateActive) {
        [self pushToMiddleWeexPage:userInfo];
    }
}

- (void) pushToMiddleWeexPage:(NSDictionary *) userInfo {
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"RecentNotification"];
    if ([self.window.rootViewController isKindOfClass:[WXRootViewController class]]) {
        WXRootViewController *rootViewController = (WXRootViewController*) self.window.rootViewController;
        NSRange range = [self.mainURL.absoluteString rangeOfString:@"/" options:(NSBackwardsSearch)];
        if (range.location != NSNotFound) {
            NSString *weexEntry =  [self.mainURL.absoluteString substringWithRange:NSMakeRange(0, range.location)];
            NSURL *middleURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/middle.js", weexEntry]];
            WXBaseViewController *viewController = [[WXBaseViewController alloc] initWithSourceURL:middleURL];
            [rootViewController pushViewController:viewController animated:YES];
        }
    }
}

@end
