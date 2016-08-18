//
//  HYNResultCell.h
//  掌上调课
//
//  Created by 黄亚男 on 16/4/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
@interface HYNResultCell : UITableViewCell
/**
 *  课程模型
 */
@property (nonatomic, strong) Course *course;
/**
 *  创建ResultCell的方法
 */
+ (instancetype)createResultCellWithTableView:(UITableView *)tableView;
@end
