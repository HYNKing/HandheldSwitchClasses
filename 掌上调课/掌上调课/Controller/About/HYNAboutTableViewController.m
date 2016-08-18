//
//  HYNAboutTableViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/12.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNAboutTableViewController.h"
#import "HYNAboutHeaderView.h"
#import "HYNInstructionController.h"
#import "HYNLogInViewController.h"
#import "HYNFileService.h"
#import "HYNNetWorkTool.h"
#import <SVProgressHUD.h>
#import <GDataXMLNode.h>
#import <MessageUI/MessageUI.h>
@interface HYNAboutTableViewController ()<MFMessageComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIButton *logOutButton;
@property (nonatomic, copy) NSString *viewState;
@end

@implementation HYNAboutTableViewController

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
    [self.logOutButton setBackgroundImage:image forState:UIControlStateNormal];
    
    // 获取图片
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    // 中间1像素拉伸
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    // 设置按钮的背景图片
    [self.logOutButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    self.tableView.separatorColor = [UIColor blackColor];
    //创建headerView
    HYNAboutHeaderView *headerView = [HYNAboutHeaderView createAboutHeaderView];
    //设置大小
    headerView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 150);
    self.tableView.tableHeaderView = headerView;
//    //隐藏没有数据的表格
//    self.tableView.tableFooterView = [[UIView alloc] init];
//
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}

- (IBAction)userinfoButtonClick:(id)sender {
    // 发送一个名字为userinfoButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoButtonClick" object:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 0:
            [self goToProductController];
            break;
        case 1:
            [self goToInstructionController];
            break;
        case 2:
            [self wipeCache];
            break;
        case 3:
            [self feedback];
            break;
        case 4:
            [self makeCall];
            break;
        default:
            break;
    }
}
//掌上调课
- (void)goToProductController{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"About" bundle:nil];
    HYNInstructionController *InstructionVC = [board instantiateViewControllerWithIdentifier:@"HYNProductController"];
    [self.navigationController pushViewController:InstructionVC animated:YES];
}

//使用说明
- (void)goToInstructionController{
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"About" bundle:nil];
    HYNInstructionController *InstructionVC = [board instantiateViewControllerWithIdentifier:@"HYNInstructionController"];
    [self.navigationController pushViewController:InstructionVC animated:YES];
}

//清除缓存
-(void)wipeCache{
     NSString *sandBoxPath = NSHomeDirectory();
    CGFloat size = [HYNFileService folderSizeAtPath:sandBoxPath];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"缓存大小为%0.2fk,确定要清除缓存么？",size] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"清除" style: UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:false forKey:kAutoLogInKey];
        [userDefault setBool:false forKey:kRemPasswordKey];
        [HYNFileService clearCache:sandBoxPath];
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

// 意见反馈


// 短信发送完成的时候调用
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    NSLog(@"%zd",result);
    
}


-(void)feedback{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否编辑短信给我们意见反馈？"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 获取 app
            UIApplication * app =[UIApplication sharedApplication];
            // 协议头是  sms
            NSURL * url = [NSURL URLWithString:@"sms://15737977253"];
            [app openURL:url]; // 通过 open url 发短信
        
//
//        MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
//        picker.messageComposeDelegate = self;
//        picker.navigationBar.tintColor = [UIColor blackColor];
//        picker.body = @"test";
//        picker.recipients = [NSArray arrayWithObject:@"15737977253"];
//        [self presentViewController:picker animated:YES completion:nil];
    }];
    
    [alert addAction:cancel];
    [alert addAction:confirm];
    
    [self presentViewController:alert animated:YES completion:nil];
}

// 联系我们
-(void)makeCall{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确认联系我们？"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 获取 app
        UIApplication * app =[UIApplication sharedApplication];
        // 协议头是 tel
        NSURL * url = [NSURL URLWithString:@"tel://15737977253"];
        [app openURL:url]; // 通过 open url 打电话
    }];
    [alert addAction:cancel];
    [alert addAction:confirm];
    [self presentViewController:alert animated:YES completion:nil];
}

/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWotkTool = [HYNNetWorkTool sharedNetWorkTool];
    __weak typeof(self) weakSelf = self;
        [netWotkTool getViewStateWithURLString: kLogoutUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
        }
    }];
}


/**
 *  退出登录
 */
- (IBAction)logOutButtonClick:(id)sender {
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"是否确定退出当前账号？"preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self getviewState];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setBool:false forKey:kAutoLogInKey];
        UIAlertController *alert2 = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"注销成功!!系统将于15秒内自动返回登陆界面!!"preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *reLogin = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
            HYNLogInViewController *logInVC = [board instantiateInitialViewController];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = logInVC;
            });
        }];
        
        UIAlertAction *logout = [UIAlertAction actionWithTitle:@"退出系统" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:self.viewState forKey:@"__VIEWSTATE"];
            [params setValue:@"退出登录" forKey:@"Button1"];
            HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
            [SVProgressHUD showWithStatus:@"正在注销"];
            [netWorkTool POSTWithURLString:kLogoutUrl andWithParameters:params finishedBlock:^(id object) {
                [SVProgressHUD dismiss];
                if (object != nil) {
                    NSError *error = nil;
                    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
                    GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
                    if (error) {
                        return ;
                    }
                    NSString *result = [titleElement stringValue];
                    if ([result isEqualToString:@"注销成功"]) {
                        UIStoryboard *board = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
                        HYNLogInViewController *logInVC = [board instantiateInitialViewController];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [UIApplication sharedApplication].keyWindow.rootViewController = logInVC;
                        });

                    }else{
                        [SVProgressHUD showErrorWithStatus:@"注销失败!!"];
                    }
                }else{
                    [SVProgressHUD showErrorWithStatus:@"连接服务器失败!!"];
                }
            }];
        }];
        
        [alert2 addAction:reLogin];
        [alert2 addAction:logout];
        [self presentViewController:alert2 animated:YES completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"LogIn" bundle:nil];
            HYNLogInViewController *logInVC = [board instantiateInitialViewController];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIApplication sharedApplication].keyWindow.rootViewController = logInVC;
            });
        });
    }];
    [alert1 addAction:cancel];
    [alert1 addAction:confirm];
    [self presentViewController:alert1 animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getFillPath{
    NSString *sandBoxPath = NSHomeDirectory();
    NSLog(@"沙盒路径：%@",sandBoxPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *arr = [fm contentsOfDirectoryAtPath:sandBoxPath error:nil];
    NSLog(@"%@",arr);
     //2）Documents目录
    //返回绝对路径NSSearchPathForDirectoriesInDomains(要查中的目录, 是否使用主目录, 是否获取全路径)
     NSArray *arr2 = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
     NSLog(@"%@",arr2);
    
     //3）Cache目录
     NSArray *arr3 = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",arr3);
    
    //4）Library目录
     NSArray *arr4 = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSLog(@"%@",arr4);
    
    //4）访问Preference目录,因为这个目录是无法用像上述方式获取的
    //先获取Libray的目录路径，再拼接
    NSString *libraryPath = [arr4 lastObject];
    NSString *preferencePath = [libraryPath stringByAppendingPathComponent:@"Preference"];
     NSLog(@"Preference path = %@",preferencePath);
    return sandBoxPath;
}

@end
