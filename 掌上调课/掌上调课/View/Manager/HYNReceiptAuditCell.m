//
//  HYNReceiptAuditCell.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/25.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNReceiptAuditCell.h"


@interface HYNReceiptAuditCell ()
@property (weak, nonatomic) IBOutlet UILabel *sqjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;


@end
@implementation HYNReceiptAuditCell


- (void)setCourse:(Course *)course{
    _course = course;
    //设置班级名称
    self.bjmcLabel.text = course.bjmc;
    //设置课程名称
    self.sqjsLabel.text = course.sqjs;
}

+ (instancetype)createReceiptAuditCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ReceiptAuditCell";
    HYNReceiptAuditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYNReceiptAuditCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)receiptAuditCellButtonClick:(id)sender {
    // 发送一个名字为applicationAuditButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiptAuditCellButtonClick" object:self];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
