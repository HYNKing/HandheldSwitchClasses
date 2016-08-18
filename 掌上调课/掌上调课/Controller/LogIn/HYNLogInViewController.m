//
//  HYNLogInViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/4/2.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNLogInViewController.h"
#import "HYNTeacherController.h"
#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
#import "NSString+Regex.h"
#import "User.h"
#import "AppDelegate.h"

@interface HYNLogInViewController ()

@property (weak, nonatomic) IBOutlet UITextField *accountField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *logInButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic, copy) NSString *viewState;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, strong) NSMutableDictionary *Mdict;
@end

@implementation HYNLogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"RedButton"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    [self.loginButton setBackgroundImage:image forState:UIControlStateNormal];
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    [self.loginButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];

    //给文本框添加监听事件 文本框编辑改变触发事件
    [self.accountField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(textFieldChange) forControlEvents:UIControlEventEditingChanged];
    [self.logInButton addTarget:self action:@selector(logInBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //读取数据
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.remPasswordSwitch.on = [defaults boolForKey:kRemPasswordKey];
    self.autoLogInSwitch.on = [defaults boolForKey:kAutoLogInKey];
    if (self.remPasswordSwitch.isOn) {
        self.accountField.text = [defaults objectForKey:kAccountKey];
        self.passwordField.text = [defaults objectForKey:kPasswordKey];
    }
    [self textFieldChange];
     [self getviewState];
    if (self.autoLogInSwitch.isOn) {
        [self logInBtnClick];
    }
}





//- (void)getCookie{
//    HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
//    [netWorkTool GETWithURLString:kHomeUrl finishedBlock:^(id object) {
//        if (object!=nil) {
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            NSArray  *cookies = [storage cookies];
////            for (NSString *cookie in cookies ) {
////                NSLog(@"=====cookie%@",cookie);
////            }
////            NSLog(@"+++++++%@",cookies);
//            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//            myDelegate.cookie = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies][@"Cookie"];
//            
//            NSLog(@"----------Cookie%@",myDelegate.cookie);
//        }
//    }];
//}
//



/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
     __weak typeof(self) weakSelf = self;
    [netWotkTool getViewStateWithURLString:kLoginUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
        }
    }];
}


/**
 *  登录
 */
- (void)logInBtnClick{
    [SVProgressHUD showWithStatus:@"正在登录"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.accountField.text forKey:@"txtxh"];
    [params setValue:self.passwordField.text forKey:@"txtpassword"];
    [params setValue:@"登 陆" forKey:@"btnlogin"];
    [params setValue:nil forKey:@"__EVENTARGUMENT"];
    [params setValue:nil forKey:@"__EVENTTARGET"];
    [params setValue:self.viewState forKey:@"__VIEWSTATE"];
    HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
    AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
    NSString *cookie = myDelegate.cookie;
    [netWorkTool.requestSerializer setValue: cookie forHTTPHeaderField:@"Cookie"];
     __weak typeof(self) weakSelf = self;
    [netWorkTool POSTWithURLString:kLoginUrl andWithParameters:params finishedBlock:^(id object) {
        [SVProgressHUD dismiss];
        if (object!=nil) {
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            NSArray  *cookies = [storage cookies];
//            AppDelegate *myDelegate = [[UIApplication sharedApplication] delegate];
//            myDelegate.cookie = [NSHTTPCookie requestHeaderFieldsWithCookies:cookies][@"Cookie"];
//            NSLog(@"----------登录Cookie%@",myDelegate.cookie);

           NSError *error = nil;
            GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
            if (error) {
                return ;
            }
            GDataXMLElement *titlrElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
            NSString *title = [titlrElement stringValue];
            NSArray *frames = [document nodesForXPath:@"//frame" error:&error];
            if (error) {
                NSLog(@"--Error%@",error);
                return ;
            }
            for(GDataXMLElement *frameElement in frames){
                if([[[frameElement attributeForName:@"src"] stringValue] isEqualToString:@"left.aspx"]){
                    weakSelf.result = @"teacher";
                }
                if([[[frameElement attributeForName:@"src"] stringValue] isEqualToString:@"shleft.aspx"]){
                    weakSelf.result = @"manager";
                }
            }
            if([title isEqualToString:@"login"]){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"账号或密码错误,请在试一次!" preferredStyle: UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                weakSelf.accountField.text = @"";
                weakSelf.passwordField.text = @"";
                [weakSelf presentViewController:alert animated:YES completion:nil];
            }else{
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:weakSelf.accountField.text forKey:kAccountKey];
                [defaults setObject:weakSelf.passwordField.text forKey:kPasswordKey];
                [defaults setBool:weakSelf.remPasswordSwitch.isOn forKey:kRemPasswordKey];
                [defaults setBool:weakSelf.autoLogInSwitch.isOn forKey:kAutoLogInKey];
                [defaults synchronize];
                UIStoryboard *teacherBoard = [UIStoryboard storyboardWithName:@"Teacher" bundle:nil];
                HYNTeacherController *teacherVC = [teacherBoard instantiateInitialViewController];
                UIStoryboard *managerBoard = [UIStoryboard storyboardWithName:@"Manager" bundle:nil];
                HYNTeacherController *managerVC = [managerBoard instantiateInitialViewController];
                if([weakSelf.result isEqualToString:@"teacher"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication sharedApplication].keyWindow.rootViewController = teacherVC;
                        });
                }
                else if([weakSelf.result isEqualToString:@"manager"]){
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication sharedApplication].keyWindow.rootViewController = managerVC;
                        });
                }else{
                    [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:@"请求服务器数据失败"];
        }
    }];
}

/**
 *  打开关闭记住密码开关调用此方法
 */
- (IBAction)remPasswordSwitchChange:(UISwitch *)sender {
    if (!sender.isOn) {
        [self.autoLogInSwitch setOn:NO animated:YES];
    }
}

/**
 *  打开关闭自动登录开关调用此方法
 */
- (IBAction)autoLogInSwitchChange:(UISwitch *)sender {
    if (sender.isOn) {
        [self.remPasswordSwitch setOn:YES animated:YES];
    }
}

- (void)textFieldChange{
    self.logInButton.enabled = self.accountField.text.length > 0 && self.passwordField.text.length > 0;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
