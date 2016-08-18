//
//  HYNReceiptAuditCell.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/25.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
@interface HYNReceiptAuditCell : UITableViewCell

@property (nonatomic, strong) Course *course;


+ (instancetype)createReceiptAuditCellWithTableView:(UITableView *)tableView;
@end
