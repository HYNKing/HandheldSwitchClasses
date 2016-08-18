//
//  HYNApplicationAuditTableViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNApplicationAuditTableViewController.h"
#import "HYNApplicationAuditHeaderView.h"
#import "HYNApplicationAuditCell.h"
#import "HYNApplicationAuditFillInController.h"
#import "HYNNetWorkTool.h"
#import "Course.h"
#import <MJRefresh.h>
@interface HYNApplicationAuditTableViewController ()

@property (nonatomic, strong) NSArray *courseList;

@end

@implementation HYNApplicationAuditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.rowHeight = 44;
    //创建headerView
    HYNApplicationAuditHeaderView *headerView = [HYNApplicationAuditHeaderView createApplicionAuditHeaderView];
    headerView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //设置大小
    headerView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    self.tableView.tableHeaderView = headerView;
    //隐藏没有数据的表格
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 监听名字为checkButtonClick的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToApplicationAuditFillInController:) name:@"applicationAuditButtonClick" object:nil];
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf httpLoadApplicationAuditData];
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpLoadApplicationAuditData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

    [self httpLoadApplicationAuditData];
}

- (void)httpLoadApplicationAuditData{
    __weak typeof(self) weakSelf = self;
    [Course courseApplicationAuditWithURLString:kTKSHUrl completeBlock:^(NSArray *courselist) {
        weakSelf.courseList = courselist;
        //刷新数据
        [weakSelf.tableView reloadData];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:courselist[0]preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:confirm1];
        [weakSelf presentViewController:alert1 animated:YES completion:nil];
    }];
}

- (IBAction)userinfoButtonClick:(id)sender {
    //发送一个名字为userinfoButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoButtonClick" object:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//返回有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//返回有多少行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.courseList.count - 1;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Course *course = self.courseList[indexPath.row + 1];
    //创建cell
    HYNApplicationAuditCell *cell = [HYNApplicationAuditCell createApplicationAuditCellWithTableView:tableView];
    cell.course = course;
    //返回cell
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)goToApplicationAuditFillInController:(NSNotification *)note{
    
    HYNApplicationAuditCell *cell = note.object;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"ApplicationAuditFillIn" bundle:nil];
    HYNApplicationAuditFillInController *applicationAuditFillInVC = [board instantiateInitialViewController];
    applicationAuditFillInVC.href = cell.course.href;
//    NSLog(@"=======applicationAuditFillInVC.href%@",applicationAuditFillInVC.href);
    [self.navigationController pushViewController:applicationAuditFillInVC animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
}

#pragma matrk - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
