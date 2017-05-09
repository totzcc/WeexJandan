//
//  DataUtil.m
//  Jiandan
//
//  Created by 周程 on 2017/5/5.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <HTMLReader/HTMLReader.h>
#import <CommonCrypto/CommonDigest.h>
#import "DataUtil.h"

@implementation DataUtil
+ (NSString *) convertToReaderHTML:(NSString *) url {
    if (url == nil || [url isEqualToString:@"null"]) {
        return @"";
    }
    url = [url stringByReplacingOccurrencesOfString:@"http://www.jandan.net" withString:@"http://i.jandan.net"];
    url = [url stringByReplacingOccurrencesOfString:@"http://jandan.net" withString:@"http://i.jandan.net"];
    if ([self readCache:url] != nil) {
        return [self readCache:url];
    }
    NSMutableString *html = [[NSMutableString alloc] init];
    [html appendString:@"<!DOCTYPE html>\n"];
    [html appendString:@"<html>\n"];
    [html appendString:@"<head>\n"];
    [html appendString:@"<meta charset=\"UTF-8\">\n"];
    [html appendString:@"<meta name=\"viewport\" content=\"width=device-width; initial-scale=1.0; maximum-scale=1.0; user-scalable=yes;\">\n"];
    [html appendString:@"<link rel=\"stylesheet\" href=\"http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.1/resources/read.css\" />\n"];
    [html appendString:@"<script src=\"https://lib.sinaapp.com/js/jquery/2.0.3/jquery-2.0.3.min.js\"></script>\n"];
    [html appendString:@"<script src=\"//cdn.jandan.net/static/js/jquery.lazyload.min.js?v=201603020\"></script>\n"];
    [html appendString:@"</head>\n"];
    [html appendString:@"<body>\n"];
    HTMLDocument *document =  [HTMLDocument documentWithString:[NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:NSUTF8StringEncoding error:nil]];
    HTMLElement *postInfo = [document nodesMatchingSelector:@".postinfo"][0];
    HTMLElement *entry = [document nodesMatchingSelector:@".entry"][0];
    
    [html appendString:[postInfo innerHTML]];
    [html appendString:[entry innerHTML]];
    [html appendString:@"\n"];
    [html appendString:@"<script src=\"http://images-file.oss-cn-hangzhou.aliyuncs.com/weex/jandan/1.0.1/resources/read.js\"></script>\n"];
    [html appendString:@"</body>\n"];
    [html appendString:@"</html>\n"];
    [self writeCache:url html:html];
    return html;
}
+ (void) writeCache:(NSString *) url html:(NSString *) html {
    NSString *md5 = [self md5:url];
    [[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingString:@"article"] withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *cacheFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"article/%@.html", md5]];
    [html writeToFile:cacheFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
+ (NSString* )readCache:(NSString *) url {
    NSString *md5 = [self md5:url];
    NSString *cacheFilePath = [NSTemporaryDirectory() stringByAppendingString:[NSString stringWithFormat:@"article/%@.html", md5]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {
        return [NSString stringWithContentsOfFile:cacheFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    return nil;
}
+ (NSString *) md5:(NSString *) input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, (int) strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

@end
