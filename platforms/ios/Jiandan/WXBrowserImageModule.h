//
//  WXBrowserImageModule.h
//  Jiandan
//
//  Created by 周程 on 2017/4/19.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SafariServices/SafariServices.h>
@interface WXBrowserImageModule : NSObject<SFSafariViewControllerDelegate>
- (void) browserImages:(NSArray<NSString*> *) imgs selectedIndex:(NSUInteger) selectedIndex;
- (void) browserWeb:(NSString *)url isReader:(bool) isReader;
@end
