//
//  HYNDetailsController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/11.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNDetailsController.h"
#import "HYNDetailsCell.h"
#import "Course.h"
@interface HYNDetailsController ()
@property (nonatomic, strong) NSArray *courseList;

@end

@implementation HYNDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.separatorColor = [UIColor blackColor];
    //隐藏没有数据的表格
    self.tableView.tableFooterView = [[UIView alloc] init];;
    self.navigationItem.title = @"审批进度";
    [self httpLoadDetailsData];
}

- (void)httpLoadDetailsData{
    NSString *url = [NSString stringWithFormat:@"/tk/%@",self.href];
    __weak typeof(self) weakSelf = self;
    [Course courseDetailsWithURLString:url completeBlock:^(NSMutableArray *courselist) {
        weakSelf.courseList = courselist;
        //刷新数据
        [weakSelf.tableView reloadData];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 7;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 3;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HYNDetailsCell *cell = [HYNDetailsCell createDetailsCellWithTableView:tableView];
    Course *course = [self.courseList objectAtIndex:0];
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = @"申请教师";
                    cell.contentLabel.text = course.sqjs;
                    return cell;
                    break;
                case 1:
                    cell.titleLabel.text = @"申请时间";
                    cell.contentLabel.text = course.sqrq;
                    return cell;
                    break;
                case 2:
                    cell.titleLabel.text = @"班级名称";
                    cell.contentLabel.text = course.bjmc;
                    return cell;
                    break;
                case 3:
                    cell.titleLabel.text = @"课程名称";
                    cell.contentLabel.text = course.kcmc;
                    return cell;
                    break;
                case 4:
                    cell.titleLabel.text = @"上课日期";
                    cell.contentLabel.text = course.skrq;
                    return cell;
                    break;
                case 5:
                    cell.titleLabel.text = @"周 节 次";
                    cell.contentLabel.text = course.zjc;
                    return cell;
                    break;
                case 6:
                    cell.titleLabel.text = @"调课原因";
                    cell.contentLabel.text = course.tkyy;
                    return cell;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = @"审批结果";
                    cell.contentLabel.text = course.xspjg;
                    return cell;
                    break;
                case 1:
                    cell.titleLabel.text = @"审 批 人";
                    cell.contentLabel.text = course.xspr;
                    return cell;
                    break;
                case 2:
                    cell.titleLabel.text = @"审批时间";
                    cell.contentLabel.text = course.xspsj;
                    return cell;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.titleLabel.text = @"审批结果";
                    cell.contentLabel.text = course.jspjg;
                    return cell;
                    break;
                case 1:
                    cell.titleLabel.text = @"审 批 人";
                    cell.contentLabel.text = course.jspr;
                    return cell;
                    break;
                case 2:
                    cell.titleLabel.text = @"审批时间";
                    cell.contentLabel.text = course.jspsj;
                    return cell;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            cell.titleLabel.text = @"补课回执";
            cell.contentLabel.text = course.bkhz;
            return cell;
            break;
        default:
            break;
    }
    return nil;
    
}

/**
 *  设置行高
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 6) {
            return 70;
        }
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 70;
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            return 70;
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            return 120;
        }
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 3? 88:0;
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
    cell.backgroundColor = [UIColor clearColor];
    // 设置cell的上下行线的位置
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]){
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
           return @"调课信息";
            break;
        case 1:
           return @"系（部）审批";
            break;
        case 2:
            return @"教务处审批";
            break;
        case 3:
            return @"补课回执";
            break;
        default:
            break;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    switch (section) {
        case 0:{
            [view setTintColor: [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0]];
            UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
            [header.textLabel setTextColor:[UIColor redColor]];
        }
        break;
        case 1:{
            [view setTintColor:[UIColor colorWithRed:253/255.0 green:134/255.0 blue:39/255.0 alpha:1.0]];
            UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
            [header.textLabel setTextColor:[UIColor blueColor]];
        }
        break;
        case 2:{
            [view setTintColor:[UIColor colorWithRed:18/255.0 green:139/255.0 blue:39/255.0 alpha:1.0]];
            UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
            [header.textLabel setTextColor:[UIColor whiteColor]];
        }
        break;
        case 3:{
            [view setTintColor:[UIColor colorWithRed:39/255.0 green:78/255.0 blue:192/255.0 alpha:1.0]];
            UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
            [header.textLabel setTextColor:[UIColor orangeColor]];
        }
        break;
        default:
        break;
    }
   // view.tintColor = [UIColor blueColor];
    // 另一种方法设置背景颜色
    // header.contentView.backgroundColor = [UIColor blackColor];
}

- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor clearColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
