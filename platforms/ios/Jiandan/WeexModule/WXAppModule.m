//
//  WXAppModule.m
//  Jiandan
//
//  Created by 周程 on 2017/6/12.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import "WXAppModule.h"

#import <CloudPushSDK/CloudPushSDK.h>
@implementation WXAppModule
WX_EXPORT_METHOD(@selector(getDeviceId:))
- (void)getDeviceId:(WXModuleCallback) callback {
    callback([CloudPushSDK getDeviceId]);
}
@end
