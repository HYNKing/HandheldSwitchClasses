//
//  HYNResultTableViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/4/23.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNResultTableViewController.h"
#import "HYNResultHeaderView.h"
#import "HYNResultCell.h"
#import "HYNDetailsController.h"
#import "HYNNetWorkTool.h"
#import <MJRefresh.h>
@interface HYNResultTableViewController ()

@property (nonatomic, strong) NSArray *courseList;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *href;
@property (nonatomic, copy) NSString *nextHref;
@property (nonatomic, copy) NSString *viewState;
@end

@implementation HYNResultTableViewController

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
    HYNResultHeaderView *headerView = [HYNResultHeaderView createResultheaderView];
     headerView.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
    //设置大小
    headerView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    self.tableView.tableHeaderView = headerView;
    //隐藏没有数据的表格
    self.tableView.tableFooterView = [[UIView alloc] init];
    // 监听名字为checkButtonClick的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goToDetailsController:) name:@"checkButtonClick" object:nil];

    __unsafe_unretained __typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf httpLoadResultData];
        // 结束刷新
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf httpLoadMoreResultData];
        //上拉加载
        [weakSelf.tableView.mj_footer endRefreshing];
    }];
    
    [self getviewState];
    [self httpLoadResultData];
}

- (void)httpLoadResultData{
    __weak typeof(self) weakSelf = self;
    [Course courseResultWithURLString:kResultUrl completeBlock:^(NSMutableArray *courselist) {
        weakSelf.message = [courselist firstObject];
        weakSelf.nextHref = [courselist lastObject];
        weakSelf.href = [courselist lastObject];
        [courselist removeObjectAtIndex:0];
        [courselist removeLastObject];
        weakSelf.courseList = courselist;
        //刷新数据
        [weakSelf.tableView reloadData];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:weakSelf.message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:confirm1];
        [weakSelf presentViewController:alert1 animated:YES completion:nil];
    }];
}

/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
    __weak typeof(self) weakSelf = self;
    [netWotkTool getViewStateWithURLString:kResultUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
        }
    }];
}

- (void)httpLoadMoreResultData{
    if ([self.nextHref isEqualToString:@""]) {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"没有更多数据" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:confirm1];
        [self presentViewController:alert1 animated:YES completion:nil];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:nil forKey:@"__EVENTARGUMENT"];
        [params setValue:self.nextHref forKey:@"__EVENTTARGET"];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
        __weak typeof(self) weakSelf = self;
        [Course courseMoreResultWithURLString:kResultUrl andWithParameters:params completeBlock:^(NSMutableArray *courselist) {
            if ([self.href isEqualToString:[courselist lastObject]]) {
                UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"没有更多数据" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert1 addAction:confirm1];
                [self presentViewController:alert1 animated:YES completion:nil];
            }else{
                weakSelf.viewState = [courselist firstObject];
                weakSelf.nextHref = [courselist lastObject];
                [courselist removeObjectAtIndex:0];
                
                [courselist removeLastObject];
                weakSelf.courseList = [weakSelf.courseList arrayByAddingObjectsFromArray:courselist];
                //刷新数据
                [weakSelf.tableView reloadData];
            }
        }];
    }
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
    return self.courseList.count;
}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
     Course *course = self.courseList[indexPath.row];
    //创建cell
    HYNResultCell *cell = [HYNResultCell createResultCellWithTableView:tableView];
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

- (void)goToDetailsController:(NSNotification *)note{
    HYNResultCell *cell = note.object;
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
    HYNDetailsController *detailsVC = [board instantiateViewControllerWithIdentifier:@"HYNDetailsController"];
    detailsVC.href = cell.course.href;
    [self.navigationController pushViewController:detailsVC animated:YES];
}


#pragma matrk - 隐藏状态栏
- (BOOL)prefersStatusBarHidden{
    return YES;
}

@end
