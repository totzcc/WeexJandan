//
//  WXLogModule.m
//  Jiandan
//
//  Created by 周程 on 2017/5/5.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <WeexSDK/WeexSDK.h>
#import <UMMobClick/MobClick.h>
#import "WXLogModule.h"

@implementation WXLogModule
WX_EXPORT_METHOD(@selector(event:))
- (void) event:(NSString *) string {
    [MobClick event:string];
}
@end
