//
//  WXHTMLParserModule.m
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import "WXHTMLParserModule.h"

@implementation WXHTMLParserModule
WX_EXPORT_METHOD(@selector(css:css:callback:))
WX_EXPORT_METHOD(@selector(parse:callback:))
- (void) css:(NSString *)html css:(NSString *)css callback:(WXModuleCallback) callback{
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    NSArray<HTMLNode*> *nodes = [document nodesMatchingSelector:css];
    NSMutableArray<NSString*> *nodesHTML = [NSMutableArray new];
    [nodes enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nodesHTML addObject:[obj serializedFragment]];
    }];
    callback(nodesHTML);
}
- (void) parse:(NSString *)html callback:(WXModuleCallback) callback {
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    HTMLElement *element = document.bodyElement.childElementNodes.firstObject;
    NSMutableDictionary *dictionary = element.attributes.mutableCopy;
    dictionary[@"text"] = [document textContent];
    callback(dictionary);
}
@end
