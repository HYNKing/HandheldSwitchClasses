//
//  Course.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/14.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^CompleteBlock)(NSMutableArray *courselist);
@interface Course : NSObject

/**
 *  申请教师
 */
@property (nonatomic, copy) NSString *sqjs;

/**
 *  班级名称
 */
@property (nonatomic, copy) NSString *bjmc;

/**
 *  课程名称
 */
@property (nonatomic, copy) NSString *kcmc;

/**
 *  上课日期
 */
@property (nonatomic, copy) NSString *skrq;

/**
 *  周节次
 */
@property (nonatomic, copy) NSString *zjc;

/**
 *  申请时间
 */
@property (nonatomic, copy) NSString *sqrq;

/**
 *  调课原因
 */
@property (nonatomic, copy) NSString *tkyy;

/**
 *  调课结果
 */
@property (nonatomic, copy) NSString *tkjg;

/**
 *  补课回执
 */
@property (nonatomic, copy) NSString *bkhz;

/**
 *  系审批人
 */
@property (nonatomic, copy) NSString *xspr;

/**
 *  系审批结果
 */
@property (nonatomic, copy) NSString *xspjg;

/**
 * 系审批时间
 */
@property (nonatomic, copy) NSString *xspsj;

/**
 *  教务处审批人
 */
@property (nonatomic, copy) NSString *jspr;

/**
 *  教务处审批结果
 */
@property (nonatomic, copy) NSString *jspjg;

/**
 *  教务处审批时间
 */
@property (nonatomic, copy) NSString *jspsj;

/**
 *  详细课程地址
 */
@property (nonatomic, copy) NSString *href;

/**
 *  控制器给course一个URLString,模型course拿着这个URLString去网络上加载数据,当数据加载完毕之后,
    通过block将结果返回给调用者(控制器)
 *  @param completeBlock 回调的block
 */
/**
 *  调课结果请求
 */
+ (void)courseResultWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;
/**
 *  调课结果更多请求
 */
+ (void)courseMoreResultWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params completeBlock:(CompleteBlock)completeBlock;
/**
 *  调课结果查看请求
 */
+ (void)courseDetailsWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;
/**
 *  补课回执请求
 */
+ (void)courseReceiptWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;

/**
 *  补课回执更多请求
 */
+ (void)courseMoreReceiptWithURLString:(NSString *)URLString andWithParameters:(NSDictionary *)params completeBlock:(CompleteBlock)completeBlock;
/**
 *  补课回执填写请求
 */
+ (void)courseReceiptFillInWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;
/**
 *  调课审核请求
 */
+ (void)courseApplicationAuditWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;

/**
 *  调课审批填写请求
 */
+ (void)courseApplicationAuditFillInURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;

/**
 *  补课审核请求
 */
+ (void)courseReceiptAuditWithURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;

/**
 *  补课审批填写请求
 */
+ (void)courseReceiptAuditFillInURLString:(NSString *)URLString completeBlock:(CompleteBlock)completeBlock;

@end
