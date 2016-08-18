//
//  HYNResultCell.m
//  掌上调课
//
//  Created by 黄亚男 on 16/4/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNResultCell.h"

@interface HYNResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;

@property (weak, nonatomic) IBOutlet UILabel *kcmcLabel;


@end
@implementation HYNResultCell


- (void)setCourse:(Course *)course{
    _course = course;
    //设置班级名称
    self.bjmcLabel.text = course.bjmc;
    //设置课程名称
    self.kcmcLabel.text = course.kcmc;
}

+ (instancetype)createResultCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ResultCell";
    HYNResultCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYNResultCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)checkButtonClick:(id)sender {
    // 发送一个名字为checkButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"checkButtonClick" object:self];
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
