//
//  WXEventModule.m
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "WXEventModule.h"

@implementation WXEventModule
@synthesize weexInstance;
WX_EXPORT_METHOD(@selector(openURL:))
WX_EXPORT_METHOD(@selector(openURL:params:))
- (void)openURL:(NSString *)url {
    [self openURL:url params:nil];
}

- (void) openURL:(NSString *)url params:(NSDictionary *) params {
    NSString *newURL = url;
    if ([url hasPrefix:@"//"]) {
        newURL = [NSString stringWithFormat:@"http:%@", url];
    }
    if ([url hasPrefix:@"http"]) {
        WXBaseViewController *controller = [[WXBaseViewController alloc] initWithSourceURL:[NSURL URLWithString:newURL]];
        [[weexInstance.viewController navigationController] pushViewController:controller animated:YES];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}
@end
