//
//  UIViewController+Orientation.m
//  Jiandan
//
//  Created by 周程 on 2017/4/26.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <WeexSDK/WeexSDK.h>
#import "UIViewController+Orientation.h"

@implementation UIViewController (Orientation)
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([self isKindOfClass:[WXBaseViewController class]] || [self isKindOfClass:[WXRootViewController class]]) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}
@end
