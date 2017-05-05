//
//  DataUtil.h
//  Jiandan
//
//  Created by 周程 on 2017/5/5.
//  Copyright © 2017年 Leo Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataUtil : NSObject
+ (NSString *) convertToReaderHTML:(NSString *) url;
+ (NSString *) md5:(NSString *) input;
@end
