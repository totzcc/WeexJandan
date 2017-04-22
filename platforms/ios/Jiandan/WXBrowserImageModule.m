//
//  WXBrowserImageModule.m
//  Jiandan
//
//  Created by 周程 on 2017/4/19.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <WeexSDK/WeexSDK.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>
#import "WXBrowserImageModule.h"
#import "AppDelegate.h"
@implementation WXBrowserImageModule
WX_EXPORT_METHOD(@selector(browserImages:selectedIndex:))
WX_EXPORT_METHOD(@selector(browserWeb:isReader:))
- (void) browserImages:(NSArray<NSString*> *) imgs selectedIndex:(NSUInteger) selectedIndex {
    AppDelegate *delegate =  (AppDelegate * )[UIApplication sharedApplication].delegate;
    WXRootViewController *rootViewController = (WXRootViewController *) delegate.window.rootViewController;
    NSMutableArray *photos = [NSMutableArray new];
    for (NSString *img in imgs) {
        NSString *url = img;
        if ([url hasPrefix:@"//"]) {
            url = [NSString stringWithFormat:@"http:%@", url];
        }
        
        if ([url hasPrefix:@"http"]) {
            [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
        }
    }
    if (photos.count > 0) {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithPhotos:photos];
        [browser setCurrentPhotoIndex:selectedIndex];
        [rootViewController pushViewController:browser animated:YES];
    }
}
- (void) browserWeb:(NSString *)url isReader:(bool) isReader{
    if (url != nil && ![url isEqualToString:@""]) {
        AppDelegate *delegate =  (AppDelegate * )[UIApplication sharedApplication].delegate;
        WXRootViewController *rootViewController = (WXRootViewController *) delegate.window.rootViewController;
        SFSafariViewController *safari = [[SFSafariViewController alloc] initWithURL:[NSURL URLWithString:url] entersReaderIfAvailable:isReader];
        safari.delegate = self;
        [rootViewController presentViewController:safari animated:YES completion:nil];
    }
}
- (void)safariViewControllerDidFinish:(SFSafariViewController *)controller {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
