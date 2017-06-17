//
//  WXAppModule.h
//  Jiandan
//
//  Created by 周程 on 2017/6/12.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
@interface WXAppModule : NSObject
- (void) getDeviceId:(WXModuleCallback) callback;

- (void) getRecentNotification:(WXModuleCallback) callback;
@end
