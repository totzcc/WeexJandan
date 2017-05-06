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
#import <UMMobClick/MobClick.h>
#import <HTMLReader/HTMLReader.h>
#import <GCDWebServer/GCDWebServer.h>
#import <GCDWebServer/GCDWebServerDataResponse.h>
#import <GrowingIO/Growing.h>
#import <SSZipArchive/SSZipArchive.h>
#import "DataUtil.h"
#import "AppDelegate.h"
#import "WXEventModule.h"
#import "WXHTMLParserModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "WXBrowserImageModule.h"
#import "WXShareModule.h"
#import "WXLogModule.h"

#define ZIPFileOnline @"http://images-file.oss-cn-hangzhou.aliyuncs.com/jandan.zip"
#define ZIPFileOnlineSize @"ZIPFileOnlineSize"
@interface AppDelegate ()
@property (nonatomic, strong) NSURL *mainURL;
@property (nonatomic, strong) GCDWebServer *webServer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UMConfigInstance.appKey = @"59006e6c6e27a45e71001bcb";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick event:@"didFinishLaunchingWithOptions"];
    
    [Growing startWithAccountId:@"809b5650755a1813"];
    
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
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
    
    
    [self loadMainBundleJS];
    self.webServer = [[GCDWebServer alloc] init];
    [GCDWebServer setLogLevel:WXLogLevelError];
    [self.webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  NSString *url = request.query[@"url"];
                                  return [GCDWebServerDataResponse responseWithHTML:[DataUtil convertToReaderHTML:url]];
                              }];
    [self.webServer startWithPort:9090 bonjourName:nil];
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    if ([Growing handleUrl:url]) // 请务必确保该函数被调用
    {
        return YES;
    }
    return NO;
}
- (void) loadMainBundleJS{
    if (self.window.rootViewController == nil) {
        self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:nil];
    }
#if DEBUG
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
    
    [SVProgressHUD show];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager HEAD:ZIPFileOnline parameters:@{@"t":[NSString stringWithFormat:@"%f", [[NSDate new] timeIntervalSinceNow]]} success:^(NSURLSessionDataTask * _Nonnull task) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *) task.response;
        NSDictionary *headers =  response.allHeaderFields;
        NSString *contentLength = headers[@"Content-Length"];
        NSString *zipSize = [[NSUserDefaults standardUserDefaults] objectForKey:ZIPFileOnlineSize];
        if (![zipSize isEqualToString:contentLength]) {
            [[manager downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:ZIPFileOnline]] progress:^(NSProgress * _Nonnull downloadProgress) {
                //
            } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
                NSString *cachePath= NSTemporaryDirectory();
                NSString *fileName= [cachePath stringByAppendingPathComponent:response.suggestedFilename];
                return [NSURL fileURLWithPath:fileName];
            } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
                [[NSUserDefaults standardUserDefaults] setObject:contentLength forKey:ZIPFileOnlineSize];
                
                
                [[NSFileManager defaultManager] removeItemAtPath:weexFileDir error:nil];
                [[NSFileManager defaultManager] createDirectoryAtPath:weexFileDir withIntermediateDirectories:YES attributes:nil error:nil];
                [SSZipArchive unzipFileAtPath:filePath.path toDestination:weexFileDir];
                [SVProgressHUD dismiss];
                [self loadMainBundleJS];
            }] resume];
        } else {
            self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:self.mainURL];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"您当前网络已经离线，请检查网络设置" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        [alert addAction:[UIAlertAction actionWithTitle:@"检查网络" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self loadMainBundleJS];
        }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }];
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


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [MobClick event:@"applicationDidBecomeActive"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
