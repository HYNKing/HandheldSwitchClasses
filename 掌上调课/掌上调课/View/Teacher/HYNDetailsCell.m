//
//  HYNDetailsCell.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/20.
//  Copyright © 2016年 黄亚男. All rights reserved.
//
//Title Content
#import "HYNDetailsCell.h"

@interface HYNDetailsCell ()

@end
@implementation HYNDetailsCell

+ (instancetype)createDetailsCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"DetailsCell";
    HYNDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYNDetailsCell" owner:nil options:nil] lastObject];
    }
    return cell;
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
