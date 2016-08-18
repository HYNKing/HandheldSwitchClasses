//
//  HYNInstructionController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/22.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNInstructionController.h"
@interface HYNInstructionController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation HYNInstructionController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置Nav
    [self setupNav];
    //加载HTML
    [self setupWebView];
}

/**
 *  设置Nav
 */
- (void)setupNav {
    self.navigationItem.title = @"使用说明";
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"login_back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
}

/**
 *  返回按钮
 */
- (void)goBack {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/**
 *  加载HTML
 */
- (void)setupWebView
{
    self.webView.scrollView.bounces = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"使用说明" ofType:@"html"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
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
