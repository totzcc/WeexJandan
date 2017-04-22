//
//  UIWindow+Motion.m
//  Jiandan
//
//  Created by 周程 on 2017/4/18.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <WeexSDK/WeexSDK.h>
#import "UIWindow+Motion.h"
#import "AppDelegate.h"
@implementation UIWindow (Motion)
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"motionEnded");
    AppDelegate *delegate =  (AppDelegate * )[UIApplication sharedApplication].delegate;
    WXRootViewController *rootViewController = (WXRootViewController *) delegate.window.rootViewController;
    WXBaseViewController *controller = (WXBaseViewController *) rootViewController.viewControllers.lastObject;
    if ([controller isKindOfClass:[WXBaseViewController class]]) {
        [controller refreshWeex];
    }
}
@end
