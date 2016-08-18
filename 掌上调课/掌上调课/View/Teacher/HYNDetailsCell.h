//
//  HYNDetailsCell.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/20.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
@interface HYNDetailsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

/**
 *  创建DetailsCell的方法
 */
+ (instancetype)createDetailsCellWithTableView:(UITableView *)tableView;
@end
