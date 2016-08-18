//
//  HYNConfirmController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/12.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNConfirmController.h"
#import "HYNNetWorkTool.h"
#import <GDataXMLNode.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
@interface HYNConfirmController ()
@property (weak, nonatomic) IBOutlet UILabel *sqjsLabel;
@property (weak, nonatomic) IBOutlet UILabel *sqrqLabel;
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *skrqLabel;
@property (weak, nonatomic) IBOutlet UILabel *zjcLabel;
@property (weak, nonatomic) IBOutlet UILabel *tkyyLabel;
@property (weak, nonatomic) IBOutlet UILabel *tkjgLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

//@property (nonatomic, copy) NSString *viewState;
@property (nonatomic, copy) NSString *errmsg;
@end

@implementation HYNConfirmController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"Background"]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    //设置按钮图片
    UIImage* image = [UIImage imageNamed:@"RedButton"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [self.confirmButton setBackgroundImage:image forState:UIControlStateNormal];
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    [self.confirmButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor blackColor];
    self.navigationItem.title = @"调课申请确认 ";
    [self getCourse];
    //[self setCourse];
}

/**
 *  设置课程数据
 */
- (void)setCourse{
    self.sqjsLabel.text = self.course.sqjs;
    self.sqrqLabel.text = self.course.sqrq;
    self.bjmcLabel.text = self.course.bjmc;
    self.kcmcLabel.text = self.course.kcmc;
    self.skrqLabel.text = self.course.skrq;
    self.zjcLabel.text = self.course.zjc;
    self.tkyyLabel.text = self.course.tkyy;
    self.tkjgLabel.text = self.course.tkjg;
}

/**
 *  获取参数
 */
- (void)getCourse{
    [SVProgressHUD showWithStatus:@"正在加载数据"];
    HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
//     AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//    NSString *cookie = myDelegate.cookie;
//    [netWorkTool.requestSerializer setValue: cookie forHTTPHeaderField:@"Cookie"];
//    [netWorkTool.requestSerializer setValue:@"http://202.196.192.25/tk/start.aspx" forHTTPHeaderField:@"Referer"];
    
    __weak typeof(self) weakSelf = self;
    [netWorkTool GETWithURLString:kTKQRUrl finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
            NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
//            GDataXMLElement *rootElement = [document rootElement];
//            NSLog(@"getCourse======element=%@",rootElement);
            NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
            if (error) {
                return ;
            }
            for (GDataXMLElement *inputElement in inputs) {
//                NSLog(@"Course+++inputElement===%@",inputElement);
                if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
                    NSString *value = [[inputElement attributeForName:@"value"] stringValue];
                    weakSelf.viewState = value;
                }
            }
            NSArray *spans = [document nodesForXPath:@"//span" error:&error];
            if (error) {
                return ;
            }
            for (GDataXMLElement *spanElement in spans) {
                NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                NSString *result = [spanElement stringValue];
                if ([spanID isEqualToString:@"tkjs"]) {
                    weakSelf.course.sqjs = result;
                    }
                if ([spanID isEqualToString:@"sqrq"]) {
                    weakSelf.course.sqrq = result;
                }
            }
        }
        [weakSelf setCourse];
    }];
}

///**
// *  获取请求参数
// */
//- (void)getviewState{
//    HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
//    __weak typeof(self) weakSelf = self;
//    [netWorkTool getViewStateWithURLString: kTKQRUrl finishedBlock:^(id object) {
//        if (object!=nil) {
//            weakSelf.viewState = object;
//            NSLog(@"请求参数self.viewState=%@",weakSelf.viewState);
//        }
//    }];
//}

/**
 *  申请确认
 */
- (IBAction)confirmButtonClick:(id)sender {
   // [self getviewState];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"提交之后将不能修改,是否确认提交调课申请?"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
        [params setValue:@"确 认" forKey:@"btnsave"];
        
//        NSLog(@"确认========params%@",params);
        HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
        __weak typeof(self) weakSelf = self;
        [netWorkTool POSTWithURLString:kTKQRUrl andWithParameters:params finishedBlock:^(id object) {
            if (object != nil) {
                NSError *error = nil;
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
//                
//                GDataXMLElement *rootElement = [document rootElement];
//                NSLog(@"确认element=%@",rootElement);
                
                GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
                if (error) {
                    return ;
                }
                NSString *title = [titleElement stringValue];
                if ([title isEqualToString:@"confirm"]) {
                    NSArray *spans = [document nodesForXPath:@"//span" error:&error];
                    if (error) {
                        return ;
                    }
                    for (GDataXMLElement *spanElement in spans) {
                        NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                        NSString *spanStr = [spanElement stringValue];
                        if ([spanID isEqualToString:@"errmsg"]) {
                            weakSelf.errmsg = spanStr;
                        }
                    }
//                    if ([weakSelf.errmsg hasPrefix:@"错误"]) {
//                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"此时间段,你已经提交过调课申请了,不能重复进行!!" preferredStyle: UIAlertControllerStyleAlert];
//                        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
//                        [alert addAction:action];
//                        [weakSelf presentViewController:alert animated:YES completion:nil];
//                    }else{
                        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示!" message:@"调课需经系（部）、教务处审核批准才能成功完成! 均同意后,您必须及时通知到任课班级学生,否则将按未申请调课旷课处理!!"preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"保存成功,点击返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"clearText" object:weakSelf];
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                        [alert1 addAction:confirm1];
                        [weakSelf presentViewController:alert1 animated:YES completion:nil];
//                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"确认提交失败"];
                }
            }else{
                [SVProgressHUD showErrorWithStatus:@"连接服务器失败"];
            }
        }];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 *  设置 header颜色
 */
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    view.tintColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0];
}

/**
 *  设置 cell 左边边界
 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
