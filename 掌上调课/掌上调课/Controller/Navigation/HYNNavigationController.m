//
//  HYNNavigationController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/15.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNNavigationController.h"

@interface HYNNavigationController ()

@end
@implementation HYNNavigationController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    // 设置导航栏图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    // 设置文字为白色
    [self.navigationBar setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] }];
    // 设置渲染的颜色
    [self.navigationBar setTintColor:[UIColor whiteColor]];

}


// 状态栏颜色
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


@end
