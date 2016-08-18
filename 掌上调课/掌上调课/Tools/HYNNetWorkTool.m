//
//  HYNNetWorkTool.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/7.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
@implementation HYNNetWorkTool

static HYNNetWorkTool *_instance;

+ (instancetype)sharedNetWorkTool{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        [_instance.requestSerializer setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8"forHTTPHeaderField:@"Accept"];
        _instance.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        [_instance.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
        //请求的序列化方式
        _instance.requestSerializer = [AFHTTPRequestSerializer serializer];
        //响应的反序列化方式
        _instance.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
//    NSDictionary *heard = [_instance.requestSerializer HTTPRequestHeaders];
//    NSLog(@"提交请求头信息%@",heard);
    [_instance afnReachability];
    return _instance;
}

- (void)GETWithURLString:(NSString *)URLString finishedBlock:(FinishedBlock)finishedBlock{
    [SVProgressHUD showWithStatus:@"正在加载"];
    [self GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        if (finishedBlock) {
            finishedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      [SVProgressHUD showErrorWithStatus:@"网络异常,连接服务器失败"];
    }];
}

- (void)POSTWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params finishedBlock:(FinishedBlock)finishedBlock{
    [self POST:URLString parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (finishedBlock) {
            finishedBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络异常,连接服务器失败"];
    }];
}


- (void)getViewStateWithURLString:(NSString *)URLString finishedBlock:(FinishedBlock)finishedBlock{
    [self GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:responseObject encoding:NSUTF8StringEncoding error:&error];
            NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
            if (error) {
                return ;
            }
            for (GDataXMLElement *inputElement in inputs) {
                if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                    NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                    if (finishedBlock) {
                        finishedBlock(value);
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"网络异常,连接服务器失败"];
    }];
}


-(void)afnReachability
{
    // 1.创建网络监听管理者
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络变化的回调
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        //只要用户的网络发生改变,就会调用这个block
        
        /*
         
         AFNetworkReachabilityStatusUnknown=不能识别,
         
         AFNetworkReachabilityStatusNotReachable=没有网络,
         
         AFNetworkReachabilityStatusReachableViaWWAN =蜂窝网,
         
         AFNetworkReachabilityStatusReachableViaWiFi =局域网,
         
         */
        
        switch(status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                break;
            case AFNetworkReachabilityStatusNotReachable:
                [SVProgressHUD showErrorWithStatus:@"请您先连接网络"];
                break;
                
            default:
                 [SVProgressHUD showErrorWithStatus:@"请您先连接网络"];
                break;
        }
    }];
    
    // 3.开始监听
    [manager startMonitoring];
}



@end
