//
//  WXShareModule.m
//  Jiandan
//
//  Created by 周程 on 2017/5/4.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import "WXShareModule.h"
#import "AppDelegate.h"
@implementation WXShareModule
WX_EXPORT_METHOD(@selector(share:title:))
- (void) share:(NSString*) url title:(NSString *) title {
    UIActivityViewController *shareController = [[UIActivityViewController alloc] initWithActivityItems:@[[NSURL URLWithString:url], title] applicationActivities:nil];
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window.rootViewController presentViewController:shareController animated:YES completion:nil];
}
@end
