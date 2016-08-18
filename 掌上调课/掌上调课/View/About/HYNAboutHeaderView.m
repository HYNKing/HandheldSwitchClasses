//
//  HYNAboutHeaderView.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/12.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNAboutHeaderView.h"
#import "User.h"

@interface HYNAboutHeaderView ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@end

@implementation HYNAboutHeaderView

+ (instancetype)createAboutHeaderView {
    return [[[NSBundle mainBundle] loadNibNamed:@"HYNAboutHeaderView" owner:nil options:nil] lastObject];
}

- (void)awakeFromNib {
    //解档用户信息
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:kuserFilePath];
    self.nameLabel.text = user.name;
    self.departmentLabel.text = user.department;
}


@end
