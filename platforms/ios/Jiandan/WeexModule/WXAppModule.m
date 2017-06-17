//
//  WXAppModule.m
//  Jiandan
//
//  Created by 周程 on 2017/6/12.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import "WXAppModule.h"

#import <CloudPushSDK/CloudPushSDK.h>
#import <MJExtension/MJExtension.h>
@implementation WXAppModule
WX_EXPORT_METHOD(@selector(getDeviceId:))
WX_EXPORT_METHOD(@selector(getRecentNotification:))
- (void)getDeviceId:(WXModuleCallback) callback {
    callback([CloudPushSDK getDeviceId]);
}

- (void)getRecentNotification:(WXModuleCallback)callback {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *notification = [defaults objectForKey:@"RecentNotification"];
    [defaults removeObjectForKey:@"RecentNotification"];
    [defaults synchronize];
    
    callback(notification);
}
@end
