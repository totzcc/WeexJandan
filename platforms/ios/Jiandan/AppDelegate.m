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
#import <HTMLReader/HTMLReader.h>
#import "BaiduMobStat.h"
#import <SSZipArchive/SSZipArchive.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import "AppDelegate.h"
#import "WXEventModule.h"
#import "AppDelegate+Push.h"
#import "WXHTMLParserModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "WXBrowserImageModule.h"
#import "WXShareModule.h"
#import "WXLogModule.h"
#import "WXAppModule.h"

#define ZIPFileOnline [NSString stringWithFormat:@"%@?timestamp=%f", @"http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.2/jandan.zip", [NSDate timeIntervalSinceReferenceDate]]
#define ZIPFileOnlineSize @"ZIPFileOnlineSize"
@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[BaiduMobStat defaultStat] startWithAppId:@"fd52db7f54"];
    [[BaiduMobStat defaultStat] logEvent:@"didFinishLaunchingWithOptions" eventLabel:@"启动"];
    [self initCloudPush:application didFinishLaunchingWithOptions:launchOptions];
    
    
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
    [WXSDKEngine registerModule:@"share" withClass:[WXShareModule class]];
    [WXSDKEngine registerModule:@"log" withClass:[WXLogModule class]];
    [WXSDKEngine registerModule:@"app" withClass:[WXAppModule class]];
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
    
    
    [self loadMainBundleJS];
    return YES;
}

- (void) loadMainBundleJS{
    if (self.window.rootViewController == nil) {
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:nil];
    }
#if DEBUG
//    self.mainURL = [NSURL URLWithString:@"http://192.168.199.200:12580/dist/native/index.js"];
    self.mainURL = [NSURL URLWithString:@"http://127.0.0.1:12580/dist/native/index.js"];
    [SVProgressHUD show];
    [[AFHTTPSessionManager manager] HEAD:self.mainURL.absoluteString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
        [SVProgressHUD dismiss];
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:self.mainURL];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您当前网络已经离线，请检查网络设置" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"检查网络" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadMainBundleJS];
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
#else
    
    NSString *weexFileDir = [NSString stringWithFormat:@"%@/Documents/weex", NSHomeDirectory()];
    self.mainURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/index.js", weexFileDir]];
    NSString *zipSize = [[NSUserDefaults standardUserDefaults] objectForKey:ZIPFileOnlineSize];
    if (zipSize == nil) {
        [SSZipArchive unzipFileAtPath:[[NSBundle mainBundle] pathForResource:@"jandan" ofType:@"zip"] toDestination:weexFileDir];
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:self.mainURL];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:ZIPFileOnlineSize];
    } else {
//        [SVProgressHUD show];
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:self.mainURL];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager HEAD:ZIPFileOnline parameters:nil success:^(NSURLSessionDataTask * _Nonnull task) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
            NSDictionary *headers =  response.allHeaderFields;
            NSString *contentLength = headers[@"Content-Length"];
            if (![zipSize isEqualToString:contentLength]) {
                [[manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ZIPFileOnline]] progress:^(NSProgress * _Nonnull downloadProgress) {
                    //
                } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                    NSString *cachePath= NSTemporaryDirectory();
                    NSString *fileName= [cachePath stringByAppendingPathComponent:response.suggestedFilename];
                    [[NSFileManager defaultManager] removeItemAtPath:fileName error:nil];
                    return [NSURL fileURLWithPath:fileName];
                } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                    [[NSUserDefaults standardUserDefaults] setObject:contentLength forKey:ZIPFileOnlineSize];
                    
                    NSError *deleteFileError = nil;
                    [[NSFileManager defaultManager] removeItemAtPath:weexFileDir error:&deleteFileError];
                    [[NSFileManager defaultManager] createDirectoryAtPath:weexFileDir withIntermediateDirectories:YES attributes:nil error:nil];
                    [SSZipArchive unzipFileAtPath:filePath.path toDestination:weexFileDir];
//                    [SVProgressHUD dismissWithDelay:1 completion:^{
//                        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:self.mainURL];
//                    }];
                }] resume];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVProgressHUD dismiss];
            /**
             去除检查远程资源文件失败后的提示
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您当前网络已经离线，请检查网络设置" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
            [alert addAction:[UIAlertAction actionWithTitle:@"检查网络" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                [self loadMainBundleJS];
            }]];
            [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
             */
        }];
    }
   
#endif
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
