//
//  HYNChangePasswordViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNChangePasswordViewController.h"
#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
@interface HYNChangePasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *originalpasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *freshPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmFreshPasswordTF;

@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (nonatomic, copy) NSString *viewState;
@property (nonatomic, copy) NSString *message;
@end

@implementation HYNChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 获取图片
    UIImage* image = [UIImage imageNamed:@"RedButton"];
    // 中间1像素拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 设置按钮的背景图片
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    // 获取图片
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    // 中间1像素拉伸
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    // 设置按钮的背景图片
    [self.submitButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
}

/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
    __weak typeof(self) weakSelf = self;
    [netWotkTool getViewStateWithURLString: kChangePasswordUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
        }
    }];
}

/**
 *  更改密码
 */
- (IBAction)submitButtonClick:(id)sender {
    [self getviewState];
    
    if(self.originalpasswordTF.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入原密码!!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.freshPasswordTF.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"新密码不能为空!!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.confirmFreshPasswordTF.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请输入确认新密码!!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.freshPasswordTF.text.length > 10){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"密码长度不得超过10字符!!" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定提交更改密码?"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
        [params setValue:self.originalpasswordTF.text forKey:@"txtold"];
        [params setValue:self.freshPasswordTF.text forKey:@"txtpassword"];
        [params setValue:self.confirmFreshPasswordTF.text forKey:@"txtconfirm"];
        [params setValue:@"提　交" forKey:@"btnok"];
        //NSLog(@"====调课确认viewState=%@",self.viewState);
        HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
        __weak typeof(self) weakSelf = self;
        [SVProgressHUD showWithStatus:@"正在提交"];
        [netWorkTool POSTWithURLString:kChangePasswordUrl andWithParameters:params finishedBlock:^(id object) {
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
                NSLog(@"titleresult = %@",result);
                if ([result isEqualToString:@"changepassword"]) {
                    NSArray *spans = [document nodesForXPath:@"//span" error:&error];
                    if (error) {
                        return ;
                    }
                    for (GDataXMLElement *spanElement in spans) {
                      NSString *spanID = [[spanElement attributeForName:@"id"] stringValue];
                      NSString *spanStr = [spanElement stringValue];
                      if ([spanID isEqualToString:@"Msg"]) {
                          weakSelf.message = spanStr;
                             NSLog(@"message = %@",spanStr);
                      }
                    }
                    if ([weakSelf.message hasPrefix:@"密码长度不得超过"]) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [SVProgressHUD showErrorWithStatus:@"更改密码提交失败"];
                        });
                        return;
                    }else{
                        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:weakSelf.message preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction *confirm1 = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.originalpasswordTF.text = @"";
                            self.freshPasswordTF.text = @"";
                            self.confirmFreshPasswordTF.text = @"";
                        }];
                        [alert1 addAction:confirm1];
                        [weakSelf presentViewController:alert1 animated:YES completion:nil];
                    }
                }else{
                        [SVProgressHUD showErrorWithStatus:@"更改密码提交失败!!"];
                    }
            }else{
                    [SVProgressHUD showErrorWithStatus:@"连接服务器失败!!"];
                }
            }];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
