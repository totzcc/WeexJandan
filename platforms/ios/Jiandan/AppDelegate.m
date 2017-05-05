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
#import "DataUtil.h"
#import "AppDelegate.h"
#import "WXEventModule.h"
#import "WXHTMLParserModule.h"
#import "WXImgLoaderDefaultImpl.h"
#import "WXBrowserImageModule.h"
#import "WXShareModule.h"

#define HTMLServer @"http://svn.longxipu.cn:8090/?url=%@"
//#define HTMLServer @"http://192.168.199.200:8090/?url=%@"
@interface AppDelegate ()
@property (nonatomic, strong) NSString *mainURL;
@property (nonatomic, strong) GCDWebServer *webServer;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UMConfigInstance.appKey = @"59006e6c6e27a45e71001bcb";
    [MobClick startWithConfigure:UMConfigInstance];
    [MobClick event:@"didFinishLaunchingWithOptions"];
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
    [WXSDKEngine initSDKEnvironment];
    [WXLog setLogLevel:WXLogLevelLog];
#ifdef DEBUG
    self.mainURL = @"http://192.168.199.200:12580/dist/native/index.js";
#else
    self.mainURL = @"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/1.0.1/dist/native/index.js";
#endif
//    self.mainURL = @"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/1.0.1/dist/native/index.js";
    self.window.rootViewController = [[WXRootViewController alloc] initWithSourceURL:[NSURL URLWithString:self.mainURL]];
    [self checkNetwork];
    
    self.webServer = [[GCDWebServer alloc] init];
    [GCDWebServer setLogLevel:WXLogLevelError];
    [self.webServer addDefaultHandlerForMethod:@"GET"
                              requestClass:[GCDWebServerRequest class]
                              processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                                  NSString *url = request.query[@"url"];
                                  return [GCDWebServerDataResponse responseWithHTML:[DataUtil convertToReaderHTML:url]];
//                                  if (url == nil || [url isEqualToString:@"null"]) {
//                                      return [GCDWebServerDataResponse responseWithHTML:@""];
//                                  }
//                                  url = [url stringByReplacingOccurrencesOfString:@"http://www.jandan.net" withString:@"http://i.jandan.net"];
//                                  url = [url stringByReplacingOccurrencesOfString:@"http://jandan.net" withString:@"http://i.jandan.net"];
//                                  NSMutableString *html = [[NSMutableString alloc] init];
//                                  [html appendString:@"<!DOCTYPE html>\n"];
//                                  [html appendString:@"<html>\n"];
//                                  [html appendString:@"<head>\n"];
//                                  [html appendString:@"<meta charset=\"UTF-8\">\n"];
//                                  [html appendString:@"<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=yes;\">\n"];
//                                  [html appendString:@"<link rel=\"stylesheet\" href=\"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/resources/read.css\" />\n"];
//                                  [html appendString:@"<script src=\"https://lib.sinaapp.com/js/jquery/2.0.3/jquery-2.0.3.min.js\"></script>\n"];
//                                  [html appendString:@"<script src=\"//cdn.jandan.net/static/js/jquery.lazyload.min.js?v=201603020\"></script>\n"];
//                                  [html appendString:@"</head>\n"];
//                                  [html appendString:@"<body>\n"];
//                                  HTMLDocument *document =  [HTMLDocument documentWithString:[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil]];
//                                  HTMLElement *postInfo = [document nodesMatchingSelector:@".postinfo"][0];
//                                  HTMLElement *entry = [document nodesMatchingSelector:@".entry"][0];
//                                  
//                                  [html appendString:[postInfo innerHTML]];
//                                  [html appendString:[entry innerHTML]];
//                                  [html appendString:@"\n"];
//                                  [html appendString:@"<script src=\"http://wl-store-0001.oss-cn-beijing.aliyuncs.com/html/weex/jandan/resources/read.js\"></script>\n"];
//                                  [html appendString:@"</body>\n"];
//                                  [html appendString:@"</html>\n"];
//                                  return [GCDWebServerDataResponse responseWithHTML:html];
                              }];
    [self.webServer startWithPort:9090 bonjourName:nil];
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
    [MobClick event:@"applicationDidBecomeActive"];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
