//
//  Course.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/14.
//  Copyright © 2016年 黄亚男. All rights reserved.
//
#import "Course.h"
#import <SVProgressHUD.h>
#import "HYNNetWorkTool.h"
#import <GDataXMLNode.h>
@interface Course ()
@end
@implementation Course
/**
 *  调课结果请求
*/
+ (void)courseResultWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
//            GDataXMLElement *rootElement = [document rootElement];
//            NSLog(@"调课结果element=%@",rootElement);
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"result"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *spans = [document nodesForXPath:@"//span" error:nil];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *spanStr = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjg"]) {
                        [courselist addObject:spanStr];
                    }
                }
                NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
                if (error) {
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
                if (trs.count > 1) {
                    for (int i = 1; i < trs.count; i++) {
                        GDataXMLElement *trElement = trs[i];
                        NSArray *tds = [trElement elementsForName:@"td"];
                        GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:&error] objectAtIndex:i-1];
                        NSString *href = [[aElement attributeForName:@"href"] stringValue];
                        if (error) {
                            NSLog(@"--Error%@",error);
                            return ;
                        }
                        if (tds.count == 6) {
                            Course *course = [Course new];
                            for (int j = 0; j < tds.count; j++) {
                                GDataXMLElement *tdElement = tds[j];
                                NSString *result = [tdElement stringValue];
                                switch (j) {
                                    case 0:
                                        course.bjmc = result;
                                        break;
                                    case 1:
                                        course.kcmc = result;
                                        break;
                                    case 2:
                                        course.skrq = result;
                                        break;
                                    case 3:
                                        course.zjc = result;
                                        break;
                                    case 4:
                                        course.sqjs = result;
                                        break;
                                    case 5:{
                                        course.href = href;
                                    }
                                    default:
                                        break;
                                }
                            }
                            [courselist addObject:course];
                           
                            }
                        if(i == trs.count - 1){
                            GDataXMLElement *lastTrElement = [trs lastObject];
                            GDataXMLElement *tdElement = [[lastTrElement elementsForName:@"td"] objectAtIndex:0];
                            GDataXMLElement *fontElement = [[tdElement elementsForName:@"font"] objectAtIndex:0];
                            GDataXMLElement *aElement =[[fontElement elementsForName:@"a"] lastObject];
                            if (aElement == nil) {
                                [courselist addObject:@""];
                            }else{
                                NSString *href = [[aElement attributeForName:@"href"] stringValue];
                                NSString *str = [href substringWithRange:NSMakeRange(25, 21)];
                                NSString *newHref = [str stringByReplacingOccurrencesOfString:@"$" withString:@":"];
                                //NSLog(@"字符为：%@",newHref);
                                [courselist addObject:newHref];
                            }
                        }
                    }
                    //通过block返回给控制器
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求调课结果数据失败!!"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败!!"];
        }
    }];
}


/**
 *  更多调课结果请求
 */
+ (void)courseMoreResultWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params completeBlock:(CompleteBlock)completeBlock{
    [[HYNNetWorkTool sharedNetWorkTool] POSTWithURLString:URLString andWithParameters:params finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"result"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
                if (error) {
                    return ;
                }
                for (GDataXMLElement *inputElement in inputs) {
                    if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                        NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                        [courselist addObject:value];
                    }
                }
                NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
                if (error) {
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
                if (trs.count > 1) {
                    for (int i = 1; i < trs.count; i++) {
                        GDataXMLElement *trElement = trs[i];
                        GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:&error] objectAtIndex:i-1];
                        if (error) {
                            return ;
                        }
                        NSString *href = [[aElement attributeForName:@"href"] stringValue];
                        NSArray *tds = [trElement elementsForName:@"td"];
                        if (tds.count == 6) {
                            Course *course = [Course new];
                            for (int j = 0; j < tds.count; j++) {
                                GDataXMLElement *tdElement = tds[j];
                                NSString *result = [tdElement stringValue];
                                switch (j) {
                                    case 0:
                                        course.bjmc = result;
                                        break;
                                    case 1:
                                        course.kcmc = result;
                                        break;
                                    case 2:
                                        course.skrq = result;
                                        break;
                                    case 3:
                                        course.zjc = result;
                                        break;
                                    case 4:
                                        course.sqjs = result;
                                        break;
                                    case 5:{
                                        course.href = href;
                                    }
                                    default:
                                        break;
                                }
                            }
                            [courselist addObject:course];
                            
                            }
                        if(i == trs.count - 1){
                            NSString *str = [href substringWithRange:NSMakeRange(25, 21)];
                            NSString *newHref = [str stringByReplacingOccurrencesOfString:@"$" withString:@":"];
                            [courselist addObject:newHref? newHref:@""];
                        }
                    }
                    //通过block返回给控制器
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求调课结果数据失败!!"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败!!"];
        }
    }];
    
}

/**
 *  调课结果查看请求
 */
+ (void)courseDetailsWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
      [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            NSMutableArray *courselist = [NSMutableArray array];
            NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (trs.count > 1) {
                Course *course = [Course new];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *result = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjs"]) {
                        course.sqjs = result;
                    }
                    if ([spanID isEqualToString:@"sqsj"]) {
                        course.sqrq = result;
                    }
                    if ([spanID isEqualToString:@"tkbj"]) {
                        course.bjmc = result;
                    }
                    if ([spanID isEqualToString:@"tkkc"]) {
                        course.kcmc = result;
                    }
                    if ([spanID isEqualToString:@"skrq"]) {
                        course.skrq = result;
                    }
                    if ([spanID isEqualToString:@"tkjc"]) {
                        course.zjc = result;
                    }
                    if ([spanID isEqualToString:@"xzr"]) {
                        course.xspr = result;
                    }
                    if ([spanID isEqualToString:@"xspsj"]) {
                        course.xspsj = result;
                    }
                    if ([spanID isEqualToString:@"jwc"]) {
                        course.jspr = result;
                    }
                    if ([spanID isEqualToString:@"cspsj"]) {
                        course.jspsj = result;
                    }
                    if ([spanID isEqualToString:@"bkhz"]) {
                        course.bkhz = result;
                    }
                }
                GDataXMLElement *tdElement1 = [[trs[4] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement1 = [[tdElement1 elementsForName:@"p"] objectAtIndex:0];
                course.tkyy = [[pElement1 stringValue] substringFromIndex:13];
                
                GDataXMLElement *tdElement2 = [[trs[6] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement2 = [[tdElement2 elementsForName:@"p"] objectAtIndex:0];
                course.xspjg =  [[pElement2 stringValue] substringFromIndex:13];
                
                GDataXMLElement *tdElement3 = [[trs[10] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement3 = [[tdElement3 elementsForName:@"p"] objectAtIndex:0];
                course.jspjg = [[pElement3 stringValue] substringFromIndex:13];
                
                [courselist addObject:course];
                if (completeBlock) {
                    completeBlock(courselist);
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务请求数据失败!!"];
        }
    }];
}

/**
 *  补课回执请求
 */
+ (void)courseReceiptWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
//            GDataXMLElement *rootElement = [document rootElement];
//            NSLog(@"element=%@",rootElement);
//
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"bkhz"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *spans = [document nodesForXPath:@"//span" error:nil];
                
               for (GDataXMLElement *spanElement in spans) {
                   NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                   NSString *spanStr = [spanElement stringValue];
                   if ([spanID isEqualToString:@"tkjg"]) {
                       [courselist addObject:spanStr];
                       }
               }
            NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
            if (error) {
                if (completeBlock) {
                    completeBlock(courselist);
                }
            }
            if (trs.count > 1) {
                for (int i = 1; i < trs.count; i++) {
                    GDataXMLElement *trElement = trs[i];
                    NSArray *tds = [trElement elementsForName:@"td"];
                    if (tds.count == 6) {
                        Course *course = [Course new];
                        GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:nil] objectAtIndex:i-1];
                        NSString *href = [[aElement attributeForName:@"href"] stringValue];
                        for (int j = 0; j < tds.count; j++) {
                            GDataXMLElement *tdElement = tds[j];
                            NSString *result = [tdElement stringValue];
                            switch (j) {
                                case 0:
                                    course.bjmc = result;
                                    break;
                                case 1:
                                    course.kcmc = result;
                                    break;
                                case 2:
                                    course.skrq = result;
                                    break;
                                case 3:
                                    course.zjc = result;
                                    break;
                                case 4:
                                    course.sqjs = result;
                                    break;
                                case 5:{
                                    course.href = href;
                                }
                                default:
                                    break;
                            }
                        }
                        [courselist addObject:course];
                    }
                    if(i == trs.count - 1){
                        GDataXMLElement *lastTrElement = [trs lastObject];
                        GDataXMLElement *tdElement = [[lastTrElement elementsForName:@"td"] objectAtIndex:0];
                        GDataXMLElement *fontElement = [[tdElement elementsForName:@"font"] objectAtIndex:0];
                        GDataXMLElement *aElement =[[fontElement elementsForName:@"a"] lastObject];
                        if (aElement == nil) {
                            [courselist addObject:@""];
                        }else{
                            NSString *href = [[aElement attributeForName:@"href"] stringValue];
                            NSString *str = [href substringWithRange:NSMakeRange(25, 21)];
                            NSString *newHref = [str stringByReplacingOccurrencesOfString:@"$" withString:@":"];
                            [courselist addObject:newHref];
                        }
                    }
                }
                if (completeBlock) {
                    completeBlock(courselist);
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求补课回执数据失败"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}


/**
 *  更多补课回执请求
 */
+ (void)courseMoreReceiptWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params completeBlock:(CompleteBlock)completeBlock{
    [[HYNNetWorkTool sharedNetWorkTool] POSTWithURLString:URLString andWithParameters:params finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"bkhz"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
                if (error) {
                    return ;
                }
                for (GDataXMLElement *inputElement in inputs) {
                    if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                        NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                        [courselist addObject:value];
                    }
                }
                NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
                if (error) {
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
                if (trs.count > 1) {
                    for (int i = 1; i < trs.count; i++) {
                        GDataXMLElement *trElement = trs[i];
                        GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:&error] objectAtIndex:i-1];
                        if (error) {
                            return ;
                        }
                        NSString *href = [[aElement attributeForName:@"href"] stringValue];
                        NSArray *tds = [trElement elementsForName:@"td"];
                        if (tds.count == 6) {
                            Course *course = [Course new];
                            for (int j = 0; j < tds.count; j++) {
                                GDataXMLElement *tdElement = tds[j];
                                NSString *result = [tdElement stringValue];
                                switch (j) {
                                    case 0:
                                        course.bjmc = result;
                                        break;
                                    case 1:
                                        course.kcmc = result;
                                        break;
                                    case 2:
                                        course.skrq = result;
                                        break;
                                    case 3:
                                        course.zjc = result;
                                        break;
                                    case 4:
                                        course.sqjs = result;
                                        break;
                                    case 5:{
                                        course.href = href;
                                    }
                                    default:
                                        break;
                                }
                            }
                            [courselist addObject:course];
                        }
                        if(i == trs.count - 1){
                            NSString *str = [href substringWithRange:NSMakeRange(25, 21)];
                            NSString *newHref = [str stringByReplacingOccurrencesOfString:@"$" withString:@":"];
                            [courselist addObject:newHref? newHref:@""];
                        }
                    }
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"请求补课回执数据失败"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
    
}

/**
 *  补课回执填写请求
 */
+ (void)courseReceiptFillInWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            NSMutableArray *courselist = [NSMutableArray array];
            NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (error) {
                return ;
            }
            if (trs.count > 1) {
                Course *course = [Course new];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *result = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjs"]) {
                        course.sqjs = result;
                    }
                    if ([spanID isEqualToString:@"sqsj"]) {
                        course.sqrq = result;
                    }
                    if ([spanID isEqualToString:@"tkbj"]) {
                        course.bjmc = result;
                    }
                    if ([spanID isEqualToString:@"tkkc"]) {
                        course.kcmc = result;
                    }
                    if ([spanID isEqualToString:@"skrq"]) {
                        course.skrq = result;
                    }
                    if ([spanID isEqualToString:@"tkjc"]) {
                        course.zjc = result;
                    }
                    GDataXMLElement *tdElement1 = [[trs[4] elementsForName:@"td"] lastObject];
                    GDataXMLElement *pElement1 = [[tdElement1 elementsForName:@"p"] objectAtIndex:0];
                    course.tkyy =  [[pElement1 stringValue] substringFromIndex:13];
                     GDataXMLElement *tdElement2 = [[trs[5] elementsForName:@"td"] lastObject];
                    GDataXMLElement *pElement2 = [[tdElement2 elementsForName:@"p"] objectAtIndex:0];
                    course.tkjg =  [[pElement2 stringValue] substringFromIndex:13];
                }
                [courselist addObject:course];
            }
             if (completeBlock) {
                 completeBlock(courselist);
             }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}

/**
 *  调课审核请求
 */
+ (void)courseApplicationAuditWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
//            GDataXMLElement *rootElement = [document rootElement];
//            NSLog(@"element=%@",rootElement);
            
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"result"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *spans = [document nodesForXPath:@"//span" error:nil];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *spanStr = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjg"]) {
                        [courselist addObject:spanStr];
                    }
                }
                NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
                if (trs.count > 1) {
                    for (int i = 1; i < trs.count; i++) {
                        GDataXMLElement *trElement = trs[i];
                        NSArray *tds = [trElement elementsForName:@"td"];
                        if (tds.count == 7) {
                            Course *course = [Course new];
                            GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:&error] objectAtIndex:i-1];
                            if (error) {
                                NSLog(@"--Error%@",error);
                                return ;
                            }
                            NSString *href = [[aElement attributeForName:@"href"] stringValue];
                            for (int j = 0; j < tds.count; j++) {
                                GDataXMLElement *tdElement = tds[j];
                                NSString *result = [tdElement stringValue];
                                switch (j) {
                                    case 0:
                                        course.sqjs = result;
                                        break;
                                    case 1:
                                        course.bjmc = result;
                                        break;
                                    case 2:
                                        course.kcmc = result;
                                        break;
                                    case 3:
                                        course.skrq = result;
                                        break;
                                    case 4:
                                        course.zjc = result;
                                        break;
                                    case 5:
                                        course.sqrq = result;
                                        break;
                                    case 6:{
                                        course.href = href;
                                    }
                                    default:
                                        break;
                                }
                            }
                            [courselist addObject:course];
                        }
                    }
                    //通过block返回给控制器
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }else{
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
            }else{
                 [SVProgressHUD showErrorWithStatus:@"请求调课审核数据失败"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}

/**
 *  调课审批填写请求
 */
+ (void)courseApplicationAuditFillInURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            NSMutableArray *courselist = [NSMutableArray array];
            NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            if (trs.count > 1) {
                Course *course = [Course new];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *result = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjs"]) {
                        course.sqjs = result;
                    }
                    if ([spanID isEqualToString:@"sqsj"]) {
                        course.sqrq = result;
                    }
                    if ([spanID isEqualToString:@"tkbj"]) {
                        course.bjmc = result;
                    }
                    if ([spanID isEqualToString:@"tkkc"]) {
                        course.kcmc = result;
                    }
                    if ([spanID isEqualToString:@"skrq"]) {
                        course.skrq = result;
                    }
                    if ([spanID isEqualToString:@"tkjc"]) {
                        course.zjc = result;
                    }
                    if ([spanID isEqualToString:@"xzr"]) {
                        course.xspr = result;
                    }
                    if ([spanID isEqualToString:@"xspsj"]) {
                        course.xspsj = result;
                    }
                }
                GDataXMLElement *tdElement1 = [[trs[4] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement1 = [[tdElement1 elementsForName:@"p"] objectAtIndex:0];
                course.tkyy =  [[pElement1 stringValue] substringFromIndex:13];
                GDataXMLElement *tdElement2 = [[trs[5] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement2 = [[tdElement2 elementsForName:@"p"] objectAtIndex:0];
                course.tkjg =  [[pElement2 stringValue] substringFromIndex:13];
                [courselist addObject:course];
                //通过block返回给控制器
                if (completeBlock) {
                    completeBlock(courselist);
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务请求数据失败"];
        }
    }];
}

/**
 *  补课审核请求
 */
+ (void)courseReceiptAuditWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titleElement stringValue];
            if ([title isEqualToString:@"bksh"]) {
                NSMutableArray *courselist = [NSMutableArray array];
                NSArray *spans = [document nodesForXPath:@"//span" error:nil];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *spanStr = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjg"]) {
                        if (completeBlock) {
                            [courselist addObject:spanStr];
                            completeBlock(courselist.copy);
                        }
                    }
                }
                NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
                if (error) {
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
                if (trs.count > 1) {
                    for (int i = 1; i < trs.count; i++) {
                        GDataXMLElement *trElement = trs[i];
                        NSArray *tds = [trElement elementsForName:@"td"];
                        if (tds.count == 7) {
                            Course *course = [Course new];
                            GDataXMLElement *aElement =[[trElement nodesForXPath:@"//a" error:&error] objectAtIndex:i-1];
                            if (error) {
                                return ;
                            }
                            NSString *href = [[aElement attributeForName:@"href"] stringValue];
                            for (int j = 0; j < tds.count; j++) {
                                GDataXMLElement *tdElement = tds[j];
                                NSString *result = [tdElement stringValue];
                                switch (j) {
                                    case 0:
                                        course.sqjs = result;
                                        break;
                                    case 1:
                                        course.bjmc = result;
                                        break;
                                    case 2:
                                        course.kcmc = result;
                                        break;
                                    case 3:
                                        course.skrq = result;
                                        break;
                                    case 4:
                                        course.zjc = result;
                                        break;
                                    case 5:
                                        course.sqrq = result;
                                        break;
                                    case 6:{
                                        course.href = href;
                                    }
                                    default:
                                        break;
                                }
                            }
                            [courselist addObject:course];
                        }
                    }
                    //通过block返回给控制器
                    if (completeBlock) {
                        completeBlock(courselist);
                    }
                }
            }else{
                 [SVProgressHUD showErrorWithStatus:@"请求补课审核数据失败"];
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}

/**
 *  补课审批填写请求
 */
+ (void)courseReceiptAuditFillInURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock{
    [SVProgressHUD showWithStatus:@"正在加载!!"];
    [[HYNNetWorkTool sharedNetWorkTool] GETWithURLString:URLString finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            NSMutableArray *courselist = [NSMutableArray array];
            NSArray *trs = [document nodesForXPath:@"//tr" error:&error];
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            if (trs.count > 1) {
                Course *course = [Course new];
                for (GDataXMLElement *spanElement in spans) {
                    NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                    NSString *result = [spanElement stringValue];
                    if ([spanID isEqualToString:@"tkjs"]) {
                        course.sqjs = result;
                    }
                    if ([spanID isEqualToString:@"sqsj"]) {
                        course.sqrq = result;
                    }
                    if ([spanID isEqualToString:@"tkbj"]) {
                        course.bjmc = result;
                    }
                    if ([spanID isEqualToString:@"tkkc"]) {
                        course.kcmc = result;
                    }
                    if ([spanID isEqualToString:@"skrq"]) {
                        course.skrq = result;
                    }
                    if ([spanID isEqualToString:@"tkjc"]) {
                        course.zjc = result;
                    }
                    if ([spanID isEqualToString:@"xzr"]) {
                        course.xspr = result;
                    }
                    if ([spanID isEqualToString:@"xspsj"]) {
                        course.xspsj = result;
                    }
                }
                GDataXMLElement *tdElement = [[trs[4] elementsForName:@"td"] lastObject];
                GDataXMLElement *pElement = [[tdElement elementsForName:@"p"] objectAtIndex:0];
                course.bkhz =  [[pElement stringValue] substringFromIndex:13];
                [courselist addObject:course];
                //通过block返回给控制器
                if (completeBlock) {
                    completeBlock(courselist);
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"服务请求数据失败"];
        }
    }];
}

@end
