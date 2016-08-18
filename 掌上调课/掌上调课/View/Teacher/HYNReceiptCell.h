//
//  HYNReceiptCell.h
//  
//
//  Created by 黄亚男 on 16/5/12.
//
//

#import <UIKit/UIKit.h>
#import "Course.h"
@interface HYNReceiptCell : UITableViewCell

/**
 *  课程模型
 */
@property (nonatomic, strong) Course *course;
//创建ReceiptCell的方法
+ (instancetype)createReceiptCellWithTableView:(UITableView *)tableView;
@end
