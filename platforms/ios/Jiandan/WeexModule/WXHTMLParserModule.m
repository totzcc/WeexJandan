//
//  WXHTMLParserModule.m
//  Jiandan
//
//  Created by 周程 on 2017/4/17.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//
#import <HTMLReader/HTMLReader.h>
#import <MJExtension/MJExtension.h>

#import "WXHTMLParserModule.h"
@implementation WXHTMLParserModule
WX_EXPORT_METHOD(@selector(css:css:callback:))
WX_EXPORT_METHOD(@selector(cssEx:css:ex:callback:))
WX_EXPORT_METHOD(@selector(parse:callback:))
WX_EXPORT_METHOD(@selector(parseTree:callback:))
- (void) css:(NSString *)html css:(NSString *)css callback:(WXModuleCallback) callback {
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    NSArray<HTMLNode*> *nodes = [document nodesMatchingSelector:css];
    NSMutableArray<NSString*> *nodesHTML = [NSMutableArray new];
    [nodes enumerateObjectsUsingBlock:^(HTMLNode * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [nodesHTML addObject:[obj serializedFragment]];
    }];
    callback(nodesHTML);
}

- (void) cssEx:(NSString *)html css:(NSString *)css ex:(NSArray<NSString*>*) exIncludes callback:(WXModuleCallback) callback {
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    [exIncludes enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[document nodesMatchingSelector:obj] enumerateObjectsUsingBlock:^(HTMLElement * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj removeFromParentNode];
        }];
    }];
    html = document.innerHTML;
    [self css:html css:css callback:callback];
}
- (void) parse:(NSString *)html callback:(WXModuleCallback) callback {
    HTMLDocument *document = [HTMLDocument documentWithString:html];
    HTMLElement *element = document.bodyElement.childElementNodes.firstObject;
    NSMutableDictionary *dictionary = element.attributes.mutableCopy;
    if (dictionary == nil) {
        dictionary = [NSMutableDictionary new];
    }
    dictionary[@"text"] = [document textContent];
    callback(dictionary);
}
- (void) parseTree:(NSString *) html callback:(WXModuleCallback) callback {
    NSMutableArray<NSDictionary *> *nodes = [[NSMutableArray alloc] init];;
    HTMLDocument *doc = [HTMLDocument documentWithString:html];
    HTMLElement *body = doc.bodyElement;
    NSArray<HTMLElement *> *elements =  body.childElementNodes;
    for (HTMLElement *element in elements) {
        [self findImg:element nodes:nodes];
        for (HTMLElement *subElement in element.childElementNodes) {
            HtmlModuleObject *obj = [[HtmlModuleObject alloc] init];
            obj.name = element.tagName;
            obj.text = [subElement.textContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [nodes addObject:obj.mj_keyValues];
        }
    }
    callback(nodes);
}
- (void) findImg:(HTMLElement *) element nodes:(NSMutableArray<NSDictionary *> *) nodes{
    NSArray<HTMLElement *> *elements =  element.childElementNodes;
    for (HTMLElement *child in elements) {
        [self findImg:child nodes:nodes];
    }
    if ([[element.tagName lowercaseString] isEqualToString:@"img"]) {
        HtmlModuleObject *obj = [[HtmlModuleObject alloc] init];
        obj.name = element.tagName;
        obj.src = [element attributes][@"src"];
        if(!obj.src) {
            obj.src = [element attributes][@"data-original"];
        }
        [nodes addObject:obj.mj_keyValues];
    }
}
@end

@implementation HtmlModuleObject
@end

