//
//  HYNReceiptAuditTableViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNReceiptAuditTableViewController.h"
#import "HYNReceiptAuditHeaderView.h"
#import "HYNReceiptAuditCell.h"
#import "HYNReceiptFillInController.h"
#import "Course.h"
#import <MJRefresh.h>
@interface HYNReceiptAuditTableViewController ()
@property (nonatomic, strong) NSArray *courseList;
@end

@implementation HYNReceiptAuditTableViewController

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
    HYNReceiptAuditHeaderView *headerView = [HYNReceiptAuditHeaderView createReceiptAuditHeaderView];
    headerView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //设置大小
    headerView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    self.tableView.tableHeaderView = headerView;
    //隐藏没有数据的表格
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 监听名字为openGroup的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToReceiptAuditeFillInController:) name:@"receiptAuditCellButtonClick" object:nil];
    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf httpLoadReceiptData];
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
        
    }];
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpLoadReceiptData];
        [weakSelf.tableView.mj_footer endRefreshing];
    }];

    [self httpLoadReceiptData];
}


/**
 *  加载数据
 */
- (void)httpLoadReceiptData{
    __weak typeof(self) weakSelf = self;
    [Course courseReceiptAuditWithURLString:kBKSHUrl completeBlock:^(NSArray *courselist) {
        weakSelf.courseList = courselist;
        //刷新数据
        [weakSelf.tableView reloadData];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:courselist[0]preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:confirm1];
        [weakSelf presentViewController:alert1 animated:YES completion:nil];
    }];
}

#pragma mark - Table view data source
/**
 *  组数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

/**
 *  行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.courseList.count - 1;
}

/**
 *  返回 cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //创建cell
    HYNReceiptAuditCell *cell = [HYNReceiptAuditCell createReceiptAuditCellWithTableView:tableView];
    Course *course = self.courseList[indexPath.row + 1];
    cell.course = course;
    //返回cell
    return cell;
}



- (IBAction)userinfoButtonClick:(id)sender {
    // 发送一个名字为userinfoButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoButtonClick" object:self];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}

/**
 *  跳转到补课回执填写控制器
 */
- (void)goToReceiptAuditeFillInController:(NSNotification *)note{
    HYNReceiptAuditCell *cell = note.object;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"ReceiptAuditFillIn" bundle:nil];
    HYNReceiptFillInController *fillInVC = [board instantiateInitialViewController];
    fillInVC.href = cell.course.href;
    [self.navigationController pushViewController:fillInVC animated:YES];
    
    //[self presentViewController:DetailsVC animated:YES completion:nil];
}

/**
 *  设置cell左边界
 */
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

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma matrk - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
