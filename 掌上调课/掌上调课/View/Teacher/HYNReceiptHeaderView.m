//
//  HYNReceiptHeaderView.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/12.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNReceiptHeaderView.h"

@implementation HYNReceiptHeaderView

+ (instancetype)createReceiptheaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HYNReceiptHeaderView" owner:nil options:nil] lastObject];
}

@end
