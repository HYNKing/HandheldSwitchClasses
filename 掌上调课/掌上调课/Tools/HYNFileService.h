//
//  HYNFileService.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/18.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HYNFileService : NSObject

+(float)fileSizeAtPath:(NSString *)path;
+(float)folderSizeAtPath:(NSString *)path;
+(void)clearCache:(NSString *)path;

@end
