//
//  HYNApplicationAuditFillInController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/25.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNApplicationAuditFillInController.h"
#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
#import "Course.h"
@interface HYNApplicationAuditFillInController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *sqjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqsjLabel;
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *skrqLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjcLabel;
@property (weak, nonatomic) IBOutlet UILabel *tkyyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tkjgLabel;
@property (weak, nonatomic) IBOutlet UILabel *xsprLabel;
@property (weak, nonatomic) IBOutlet UILabel *xspsjLabel;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITextView *applicationAuditTextView;

@property (nonatomic, strong) Course *course;
@property (nonatomic, copy) NSString *viewState;

@property (nonatomic, assign, getter=isSelect) BOOL select;

@property (nonatomic, copy) NSString *dropStr;
@end


@implementation HYNApplicationAuditFillInController
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
    self.applicationAuditTextView.textColor = [UIColor lightGrayColor];
    self.applicationAuditTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.applicationAuditTextView.layer.borderWidth = 0.6f;
    self.applicationAuditTextView.layer.cornerRadius = 6.0f;
    self.applicationAuditTextView.layer.masksToBounds = YES;
    
    self.applicationAuditTextView.delegate = self;
    self.tableView.separatorColor = [UIColor blackColor];
    self.navigationItem.title = @"审批进度";
    [self httpLoadCourseData];
}

/**
 *  加载课程数据
 */
- (void)httpLoadCourseData{
//    NSLog(@"-------%@",self.href);
    NSString *url = [NSString stringWithFormat:@"/tk/%@",self.href];
    __weak typeof(self) weakSelf = self;
    [Course courseApplicationAuditFillInURLString:url completeBlock:^(NSArray *courselist) {
        Course *course = [courselist objectAtIndex:0];
        //NSLog(@"%@--%@--%@--%@--%@--%@--%@--%@",course.sqjs,course.bjmc,course.kcmc,course.sqrq,course.skrq,course.zjc,course.tkyy,course.tkjg);
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
    self.tkyyLabel.text = course.tkyy;
    self.tkjgLabel.text = course.tkjg;
    self.xsprLabel.text = course.xspr;
    self.xspsjLabel.text = course.xspsj;
}

/**
 *  快速审批选择
 */
- (IBAction)selectButtonClick:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"同意" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        self.select = YES;
//        NSLog(@"========viewState%@",self.viewState);
        [params setValue:@"同意"  forKey:@"DropDownList1"];
        [params setValue:@"" forKey:@"__EVENTARGUMENT"];
        [params setValue:@"DropDownList1" forKey:@"__EVENTTARGET"];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
        [params setValue:@"" forKey:@"spyj"];
//        NSLog(@"========params%@",params);
        HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
        NSString *tkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
//        NSLog(@"=======提交.href%@",tkspUrl);
        __weak typeof(self) weakSelf = self;
        [netWorkTool POSTWithURLString:tkspUrl andWithParameters:params finishedBlock:^(id object) {
            if (object != nil) {
                NSError *error = nil;
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
//                GDataXMLElement *rootElement = [document rootElement];
//                NSLog(@"element=%@",rootElement);
                NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
                if (error) {
                    return ;
                }
                for (GDataXMLElement *inputElement in inputs) {
                    NSLog(@"inputElement===%@",inputElement);
                    if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                        NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                        weakSelf.viewState = value;
//                        NSLog(@"%@",weakSelf.viewState);
                    }
                }
            }
            weakSelf.applicationAuditTextView.text = @"同意调课！";
            weakSelf.applicationAuditTextView.textColor = [UIColor blackColor];
            weakSelf.dropStr = @"同意";
        }];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不同意" style: UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        self.select = YES;
//        NSLog(@"========viewState%@",self.viewState);
        [params setValue:@"不同意"  forKey:@"DropDownList1"];
        [params setValue:@"" forKey:@"__EVENTARGUMENT"];
        [params setValue:@"DropDownList1" forKey:@"__EVENTTARGET"];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
        [params setValue:@"" forKey:@"spyj"];
//        NSLog(@"========params%@",params);
        HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
        NSString *tkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
//        NSLog(@"=======提交.href%@",tkspUrl);
        __weak typeof(self) weakSelf = self;
        [netWorkTool POSTWithURLString:tkspUrl andWithParameters:params finishedBlock:^(id object) {
            if (object != nil) {
                NSError *error = nil;
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
//                GDataXMLElement *rootElement = [document rootElement];
//                NSLog(@"element=%@",rootElement);
                NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
                if (error) {
                    return ;
                }
                for (GDataXMLElement *inputElement in inputs) {
//                    NSLog(@"inputElement===%@",inputElement);
                    if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                        NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                        weakSelf.viewState = value;
                    }
                }
            }
            weakSelf.applicationAuditTextView.text = @"不同意调课！";
            weakSelf.applicationAuditTextView.textColor = [UIColor blackColor];
            weakSelf.dropStr = @"不同意";
        }];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addAction:action3];
    [self presentViewController:alertController animated:YES completion:nil];
}

///**
// *  获取请求参数
// */
//- (void)getviewState{
//    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
//    __weak typeof(self) weakSelf = self;
//    NSLog(@"=======填写.href%@",self.href);
//    NSString *tkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
//    [netWotkTool getViewStateWithURLString: tkspUrl finishedBlock:^(id object) {
//        if (object!=nil) {
//            weakSelf.viewState = object;
//        }
//    }];
//}

/**
 *  提交调课审批
 */
- (IBAction)confirmButtonClick:(id)sender {
    if (self.applicationAuditTextView.textColor == [UIColor blackColor]) {
        self.course.xspjg = self.applicationAuditTextView.text;
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定提交调课审批结果?"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            if (!self.isSelect) {
                self.dropStr = @"";
            }
//            NSLog(@"========viewState%@",self.viewState);
            [params setValue:self.dropStr  forKey:@"DropDownList1"];
            [params setValue:@"" forKey:@"__EVENTARGUMENT"];
            [params setValue:@"" forKey:@"__EVENTTARGET"];
            [params setValue:self.viewState forKey:@"__VIEWSTATE"];
            [params setValue:self.applicationAuditTextView.text forKey:@"spyj"];
            [params setValue:@"确 认" forKey:@"btnsave"];
//            NSLog(@"========params%@",params);
            //NSLog(@"====调课确认viewState=%@",self.viewState);
            HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
            NSString *tkspUrl = [NSString stringWithFormat:@"/tk/%@",self.href];
//             NSLog(@"=======提交.href%@",tkspUrl);
            __weak typeof(self) weakSelf = self;
            [SVProgressHUD showWithStatus:@"正在提交!!"];
            [netWorkTool POSTWithURLString:tkspUrl andWithParameters:params finishedBlock:^(id object) {
                [SVProgressHUD dismiss];
                if (object != nil) {
                    NSError *error = nil;
                    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
//                    GDataXMLElement *rootElement = [document rootElement];
//                    NSLog(@"element=%@",rootElement);
                    GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
                    if (error) {
                        return ;
                    }
                    NSString *result = [titleElement stringValue];
//                    NSLog(@"result = %@",result);
                    if ([result isEqualToString:@"save"]) {
                        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"需经教务处审核批准才能成功完成,请联系!!"preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"审核成功,点击返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.select = NO;
                            self.applicationAuditTextView.text = @"";
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert1 addAction:confirm1];
                        [weakSelf presentViewController:alert1 animated:YES completion:nil];
                    }else{
                        [SVProgressHUD showErrorWithStatus:@"确认提交失败!!"];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"调课审批不能为空,请填写调课审批信息!"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:confirm];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

/**
 *  开始编辑 自动向上滚
 */
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.applicationAuditTextView.textColor == [UIColor lightGrayColor]) {
        self.applicationAuditTextView.text = @"";
        self.applicationAuditTextView.textColor = [UIColor blackColor];
    }
    // 先取出当前的偏移量
    CGPoint contentOffset = self.tableView.contentOffset;
    contentOffset.y = 240;
    //动画滚动
    [self.tableView setContentOffset:contentOffset animated:YES];
}

/**
 *  结束编辑 自动向下滚
 */
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        self.applicationAuditTextView.text = @"请您在此处填写调课审批结果";
        self.applicationAuditTextView.textColor = [UIColor lightGrayColor];
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
