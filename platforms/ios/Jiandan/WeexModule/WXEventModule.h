//
//  WXEventModule.h
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>

@interface WXEventModule : NSObject <WXEventModuleProtocol>
- (void) openURL:(NSString *)url params:(NSDictionary *) params;
@end
