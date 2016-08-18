//
//  HYNNetWorkTool.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/7.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

typedef void(^FinishedBlock)(id object);

@interface HYNNetWorkTool : AFHTTPSessionManager

+ (instancetype)sharedNetWorkTool;

/**
 *  GET请求方法
 *  @param URLString     请求地址
 *  @param finishedBlock 完成block回调
 */
- (void)GETWithURLString:(NSString *)URLString finishedBlock:(FinishedBlock)finishedBlock;
/**
 *  POST 请求方法
 *  @param URLString     请求地址
 *  @param params        请求参数
 *  @param finishedBlock 完成 block回调
 */
- (void)POSTWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params finishedBlock:(FinishedBlock)finishedBlock;

/**
 *  获取请求参数 __VIEWSTATE
 *
 *  @param URLString     请求地址
 */
- (void)getViewStateWithURLString:(NSString *)URLString finishedBlock:(FinishedBlock)finishedBlock;

@end
