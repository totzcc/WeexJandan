//
//  WXHTMLParserModule.h
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
#import <HTMLReader/HTMLReader.h>
@interface WXHTMLParserModule : NSObject <WXModuleProtocol>
- (void) css:(NSString *)html css:(NSString *)css callback:(WXModuleCallback) callback;
- (void) parse:(NSString *)html callback:(WXModuleCallback) callback;
@end
