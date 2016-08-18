//
//  HYNApplicationAuditCell.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNApplicationAuditCell.h"
#import "Course.h"

@interface HYNApplicationAuditCell ()
@property (weak, nonatomic) IBOutlet UILabel *sqjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;


@end
@implementation HYNApplicationAuditCell


- (void)setCourse:(Course *)course{
    _course = course;
    //设置班级名称
    self.bjmcLabel.text = course.bjmc;
    //设置课程名称
    self.sqjsLabel.text = course.sqjs;
}

+ (instancetype)createApplicationAuditCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ApplicationAuditCell";
    HYNApplicationAuditCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYNApplicationAuditCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)applicationAuditButtonClick:(id)sender {
    // 发送一个名字为applicationAuditButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationAuditButtonClick" object:self];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
