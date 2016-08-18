//
//  HYNApplicationAuditCell.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
@interface HYNApplicationAuditCell : UITableViewCell


@property (nonatomic, strong) Course *course;
/**
 *  创建ApplicationAuditCell的方法
 */
+ (instancetype)createApplicationAuditCellWithTableView:(UITableView *)tableView;
@end
