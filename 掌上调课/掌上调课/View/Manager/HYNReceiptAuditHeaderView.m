//
//  HYNReceiptAuditHeaderView.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNReceiptAuditHeaderView.h"

@implementation HYNReceiptAuditHeaderView

+ (instancetype)createReceiptAuditHeaderView{
    return [[[NSBundle mainBundle] loadNibNamed:@"HYNReceiptAuditHeaderView" owner:nil options:nil] lastObject];
}

@end
