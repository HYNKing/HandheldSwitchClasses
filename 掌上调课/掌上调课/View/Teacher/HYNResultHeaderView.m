//
//  HYNResultHeaderView.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/11.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNResultHeaderView.h"

@implementation HYNResultHeaderView

+ (instancetype)createResultheaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HYNResultHeaderView" owner:nil options:nil] lastObject];
}

@end
