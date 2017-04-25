//
//  AppDelegate.m
//  jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <WeexSDK/WeexSDK.h>
#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <PgyUpdate/PgyUpdateManager.h>
#import "AppDelegate.h"
#import "WXEventModule.h"
#import "WXHTMLParserModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "WXBrowserImageModule.h"
@interface AppDelegate ()
    @property (nonatomic, strong) NSString *mainURL;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"68d83db068dcd3b78b266858f4682bdb"];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    [WXAppConfiguration setAppGroup:@"Leo Studio"];
    [WXAppConfiguration setAppName:@"Jiandan"];
    [WXAppConfiguration setAppVersion:@"1.0.0"];
    
    [WXSDKEngine registerHandler:[WXEventModule new] withProtocol:@protocol(WXEventModuleProtocol)];
    [WXSDKEngine registerHandler:[WXImgLoaderDefaultImpl new] withProtocol:@protocol(WXImgLoaderProtocol)];
    [WXSDKEngine registerModule:@"event" withClass:[WXEventModule class]];
    [WXSDKEngine registerModule:@"html" withClass:[WXHTMLParserModule class]];
    [WXSDKEngine registerModule:@"browser" withClass:[WXBrowserImageModule class]];
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
//    self.mainURL = @"http://192.168.199.200:12580/dist/native/index.js";
    self.mainURL = @"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/dist/native/index.js";
    
    self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:[NSURL URLWithString:self.mainURL]];
    [self checkNetwork];
    return YES;
}
- (void) checkNetwork {
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] HEAD:self.mainURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        [SVProgressHUD dismiss];
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:[NSURL URLWithString:self.mainURL]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您当前网络已经离线，请检查网络设置" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"检查网络" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self checkNetwork];
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
#ifdef DEBUG
    [[PgyUpdateManager sharedPgyManager] checkUpdate];
#endif
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
