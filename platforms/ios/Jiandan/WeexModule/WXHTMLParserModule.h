//
//  WXHTMLParserModule.h
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WeexSDK/WeexSDK.h>
@interface WXHTMLParserModule : NSObject <WXModuleProtocol>
- (void) css:(NSString *)html css:(NSString *)css callback:(WXModuleCallback) callback;
- (void) cssEx:(NSString *)html css:(NSString *)css ex:(NSArray<NSString*>*) exIncludes callback:(WXModuleCallback) callback;
- (void) parse:(NSString *) html callback:(WXModuleCallback) callback;
- (void) parseTree:(NSString *) html callback:(WXModuleCallback) callback;
@end
@interface HtmlModuleObject :NSObject
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,copy) NSString *src;
@property (nonatomic ,copy) NSString *text;
@end
