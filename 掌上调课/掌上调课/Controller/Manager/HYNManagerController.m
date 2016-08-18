//
//  HYNManagerController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNManagerController.h"
#import "User.h"
#import "HYNNetWorkTool.h"
#import "HYNApplicationViewController.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>

@interface HYNManagerController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstant;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstant;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;

@property (nonatomic, copy) NSString *EVENTARGUMENT;
@property (nonatomic, copy) NSString *EVENTTARGET;
@property (nonatomic, copy) NSString *VIEWSTATE;

@property (nonatomic, strong) User *user;
@end

@implementation HYNManagerController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.topConstant.constant = 0;
    self.bottomConstant.constant = 0;
    self.widthConstant.constant = self.view.bounds.size.width;
    // 监听名字为userinfoButtonClick的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(rightSwipe:) name:@"userinfoButtonClick" object:nil];
    [self httploadUserinfo];
}

/**
 *  获取用户信息
 */
- (void)loadUserinfo{
    self.nameLabel.text = self.user.name;
    self.departmentLabel.text = self.user.department;
    //归档
    [NSKeyedArchiver archiveRootObject:self.user toFile:kuserFilePath];
}


//加载用户信息
- (void)httploadUserinfo{
    [User userWithURLString:kManagerUrl userBlock:^(id object) {
        if (object!= nil) {
            self.user = object;
            //归档
            [NSKeyedArchiver archiveRootObject:self.user toFile:kuserFilePath];
        }
    }];
}


/**
 *  右滑
 */
- (IBAction)rightSwipe:(id)sender {
    [self loadUserinfo];
    self.topConstant.constant = 40;
    self.bottomConstant.constant = 40;
    self.widthConstant.constant = self.view.bounds.size.width * 0.5;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

/**
 *  左滑
 */
- (IBAction)leftSwipe:(id)sender {
    
    self.topConstant.constant = 0;
    self.bottomConstant.constant = 0;
    self.widthConstant.constant = self.view.bounds.size.width;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    self.topConstant.constant = 0;
    self.bottomConstant.constant = 0;
    self.widthConstant.constant = self.view.bounds.size.width;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self setNeedsStatusBarAppearanceUpdate];
}


//设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle{
    if (self.widthConstant.constant == self.view.bounds.size.width) {
        return UIStatusBarStyleLightContent;
    }else{
        return UIStatusBarStyleDefault;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
