//
//  HYNReceiptAuditFillInController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/25.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNReceiptAuditFillInController.h"
#import "HYNNetWorkTool.h"
#import "Course.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>

@interface HYNReceiptAuditFillInController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sqjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *skrqLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjcLabel;
@property (weak, nonatomic) IBOutlet UILabel *bkhzLabel;
@property (weak, nonatomic) IBOutlet UILabel *xsprLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextView *receiptAuditTextView;

@property (nonatomic, strong) Course *course;
@property (nonatomic, copy) NSString *viewState;
@end

@implementation HYNReceiptAuditFillInController
- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    // 获取图片
    UIImage* image = [UIImage imageNamed:@"RedButton"];
    // 中间1像素拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 设置按钮的背景图片
    [self.confirmButton setBackgroundImage:image forState:UIControlStateNormal];
    // 获取图片
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    // 中间1像素拉伸
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    // 设置按钮的背景图片
    [self.confirmButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    self.receiptAuditTextView.textColor = [UIColor lightGrayColor];
    self.receiptAuditTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.receiptAuditTextView.layer.borderWidth = 0.6f;
    self.receiptAuditTextView.layer.cornerRadius = 6.0f;
    self.receiptAuditTextView.layer.masksToBounds = YES;
    
    self.receiptAuditTextView.delegate = self;
    self.tableView.separatorColor = [UIColor blackColor];
    self.navigationItem.title = @"审批进度";
    [self httpLoadCourseData];
}

/**
 *  加载课程数据
 */
- (void)httpLoadCourseData{
//    NSLog(@"-------%@",self.href);
    NSString *bkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
    __weak typeof(self) weakSelf = self;
    [Course courseReceiptAuditFillInURLString:bkspUrl completeBlock:^(NSArray *courselist) {
        Course *course = [courselist objectAtIndex:0];
//        NSLog(@"%@--%@--%@--%@--%@--%@--%@--%@",course.sqjs,course.bjmc,course.kcmc,course.sqrq,course.skrq,course.zjc,course.tkyy,course.tkjg);
        weakSelf.course = course;
        [weakSelf setCourseDataWith:course];
    }];
}

/**
 * 设置课程数据
 */
- (void)setCourseDataWith:(Course *)course{
    self.sqjsLabel.text = course.sqjs;
    self.sqsjLabel.text = course.sqrq;
    self.bjmcLabel.text = course.bjmc;
    self.kcmcLabel.text = course.kcmc;
    self.skrqLabel.text = course.skrq;
    self.zjcLabel.text = course.zjc;
    self.bkhzLabel.text = course.bkhz;
    self.xsprLabel.text = course.xspr;
}

/**
 *  快速审批
 */
- (IBAction)selectButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.receiptAuditTextView.text = @"同意补课！";
        self.receiptAuditTextView.textColor = [UIColor blackColor];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不同意" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.receiptAuditTextView.text = @"不同意补课！";
        self.receiptAuditTextView.textColor = [UIColor blackColor];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
    __weak typeof(self) weakSelf = self;
//    NSLog(@"======%@",self.href);
    NSString *bkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
    [netWotkTool getViewStateWithURLString: bkspUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
        }
    }];
}

/**
 *  提交补课审批
 */
- (IBAction)confirmButtonClick:(id)sender {
    [self getviewState];
    if (self.receiptAuditTextView.textColor == [UIColor blackColor]) {
        self.course.xspjg = self.receiptAuditTextView.text;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定提交补课审批结果?"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:@""  forKey:@"DropDownList1"];
            [params setValue:@"" forKey:@"__EVENTARGUMENT"];
            [params setValue:@"" forKey:@"__EVENTTARGET"];
            [params setValue:self.viewState forKey:@"__VIEWSTATE"];
            [params setValue:self.receiptAuditTextView.text forKey:@"spyj"];
            [params setValue:@"确 认" forKey:@"btnsave"];
            HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
            NSString *bkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
            __weak typeof(self) weakSelf = self;
            [SVProgressHUD showWithStatus:@"正在提交"];
            [netWorkTool POSTWithURLString:bkspUrl andWithParameters:params finishedBlock:^(id object) {
                [SVProgressHUD dismiss];
                if (object != nil) {
                    NSError *error = nil;
                    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
                    GDataXMLElement *rootElement = [document rootElement];
                    NSLog(@"element=%@",rootElement);
                    GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
                    if (error) {
                        return ;
                    }
                    NSString *result = [titleElement stringValue];
                    if ([result isEqualToString:@"bkxshok"]) {
                        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"需经教务处审核批准才能成功完成,请联系!!"preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"审核成功,点击返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.receiptAuditTextView.text = @"";
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert1 addAction:confirm1];
                        [weakSelf presentViewController:alert1 animated:YES completion:nil];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"审核提交失败!!"];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"连接服务器失败!!"];
                }
            }];
        }];
        [alert addAction:cancel];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"补课审批不能为空,请填写补课审批信息!!"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 *  开始编辑 自动向上滚
 */
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.receiptAuditTextView.textColor == [UIColor lightGrayColor]) {
        self.receiptAuditTextView.text = @"";
        self.receiptAuditTextView.textColor = [UIColor blackColor];
    }
    // 先取出当前的偏移量
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = 200;
    //动画滚动
    [self.tableView setContentOffset:contentOffset animated:YES];
}

/**
 *  结束编辑 自动向下滚
 */
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.receiptAuditTextView.text = @"请您在此处填写补课审批结果";
        self.receiptAuditTextView.textColor = [UIColor lightGrayColor];
    }
    // 先取出当前的偏移量
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = 0;
    //动画滚动
    [self.tableView setContentOffset:contentOffset animated:YES];
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
    cell.backgroundColor = [UIColor clearColor];
}

@end
