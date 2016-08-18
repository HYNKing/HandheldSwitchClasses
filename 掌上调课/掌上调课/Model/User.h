//
//  User.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/13.
//  Copyright © 2016年 黄亚男. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef void(^UserBlock)(id object);
@interface User : NSObject
/**
 *  姓名
 */
@property (nonatomic, copy) NSString *name;

/**
 *  账号
 */
@property (nonatomic, copy) NSString *account;

/**
 *  密码
 */
@property (nonatomic, copy) NSString *password;

/**
 *  行别
 */
@property (nonatomic, copy) NSString *sex;

/**
 *  系部
 */
@property (nonatomic, copy) NSString *department;

+ (void)userWithURLString:(NSString *)URLString userBlock:(UserBlock)userBlock;

@end
