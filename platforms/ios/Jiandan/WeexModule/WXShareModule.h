//
//  WXShareModule.h
//  Jiandan
//
//  Created by 周程 on 2017/5/4.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
@interface WXShareModule : NSObject
- (void) share:(NSString*) url title:(NSString *) title;
@end
