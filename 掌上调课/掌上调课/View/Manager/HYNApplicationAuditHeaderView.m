//
//  HYNApplicationAuditHeaderView.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNApplicationAuditHeaderView.h"

@implementation HYNApplicationAuditHeaderView

+ (instancetype)createApplicionAuditHeaderView{
   return [[[NSBundle mainBundle] loadNibNamed:@"HYNApplicationAuditHeaderView" owner:nil options:nil] lastObject];
}

@end
