//
//  User.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/13.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "User.h"
#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
@implementation User

/**
 *  用户信息请求
 */
+ (void)userWithURLString:(NSString *)URLString userBlock:(UserBlock)userBlock{
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (error) {
                return ;
            }
            User *user = [[User alloc] init];
            for (GDataXMLElement *spanElement in spans) {
                NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                NSString *value = [spanElement stringValue];
                if ([spanID isEqualToString:@"xh"]) {
                    user.account = value;
                }
                if ([spanID isEqualToString:@"xm"]){
                    user.name = value;
                }
                if ([spanID isEqualToString:@"sex"]){
                    user.sex = value;
                }
                if ([spanID isEqualToString:@"xb"]){
                    user.department = value;
                }
                //通过block返回给控制器
                if (userBlock) {
                            userBlock(user);
                        }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}

//告诉编译器需要归档哪些属性
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_department forKey:@"department"];

}

//告诉编译器需要解档哪些属性
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _name = [coder decodeObjectForKey:@"name"];
        _department = [coder decodeObjectForKey:@"department"];
    }
    return self;
}

@end
