//
//  HYNApplicationViewController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/4/24.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNApplicationViewController.h"
#import "HYNConfirmController.h"
#import "Course.h"
#import "HYNNetWorkTool.h"
#import <GDataXMLNode.h>
#import <SVProgressHUD.h>
#import "AppDelegate.h"
@interface HYNApplicationViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextViewDelegate>
//班级名
@property (weak, nonatomic) IBOutlet UITextField *bjmcTextField;
//课程名
@property (weak, nonatomic) IBOutlet UITextField *kcmcTextField;
//日期
@property (weak, nonatomic) IBOutlet UITextField *skrqTextField;
//周次
@property (weak, nonatomic) IBOutlet UITextField *zcTextField;
//星期
@property (weak, nonatomic) IBOutlet UITextField *xqTextField;
//节次
@property (weak, nonatomic) IBOutlet UITextField *jcTextField;
//原因
@property (weak, nonatomic) IBOutlet UITextView *tkyyTextView;
//结果
@property (weak, nonatomic) IBOutlet UITextView *tkjgTextView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
//提交
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
//日期选择控件
@property (nonatomic, strong) UIDatePicker *datePicker;
//选择控件
@property(nonatomic, strong) UIPickerView *pickerView;
//工具条
@property (nonatomic, strong) UIToolbar *toolbar;

@property (nonatomic, strong) NSArray *picks;

@property (nonatomic, strong) Course *course;
//请求参数
@property (nonatomic, copy) NSString *viewState;
@end

@implementation HYNApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage* image = [UIImage imageNamed:@"RedButton"];
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    // 设置按钮的背景图片
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    UIImage* imagePressed = [UIImage imageNamed:@"RedButtonPressed"];
    imagePressed = [imagePressed stretchableImageWithLeftCapWidth:imagePressed.size.width * 0.5 topCapHeight:imagePressed.size.height * 0.5];
    [self.submitButton setBackgroundImage:imagePressed forState:UIControlStateHighlighted];
    self.tkyyTextView.textColor = [UIColor lightGrayColor];
    self.tkjgTextView.textColor = [UIColor lightGrayColor];
    
    //设置 textView 边框
    self.tkyyTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.tkyyTextView.layer.borderWidth = 0.6f;
    self.tkyyTextView.layer.cornerRadius = 6.0f;
    self.tkyyTextView.layer.masksToBounds = YES;
    
    self.tkjgTextView.layer.borderColor = [[UIColor colorWithRed:215.0 / 255.0 green:215.0 / 255.0 blue:215.0 / 255.0 alpha:1] CGColor];
    self.tkjgTextView.layer.borderWidth = 0.6f;
    self.tkjgTextView.layer.cornerRadius = 6.0f;
    self.tkjgTextView.layer.masksToBounds = YES;
    
    self.zcTextField.inputView = self.pickerView;
    self.xqTextField.inputView = self.pickerView;
    self.jcTextField.inputView = self.pickerView;
    // 设置文本框的输入界面为datePicker
    self.skrqTextField.inputView = self.datePicker;
    // 设置工具条
    self.skrqTextField.inputAccessoryView = self.toolbar;
    self.zcTextField.inputAccessoryView = self.toolbar;
    self.xqTextField.inputAccessoryView = self.toolbar;
    self.jcTextField.inputAccessoryView = self.toolbar;
    
    //设置代理
    self.tkyyTextView.delegate = self;
    self.tkjgTextView.delegate = self;
    self.tkyyTextView.tag = 1001;
    self.tkjgTextView.tag = 1002;
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearAllText) name:@"clearText" object:nil];
      [self getviewState];
}

/**
 *  获取课程数据
 */
- (void)getCourseData{
    Course *course = [[Course alloc] init];
    course.bjmc = self.bjmcTextField.text;
    course.kcmc = self.kcmcTextField.text;
    course.skrq = self.skrqTextField.text;
    course.zjc = [NSString stringWithFormat:@"%@ %@ %@",self.zcTextField.text,self.xqTextField.text,self.jcTextField.text];
    course.tkyy = self.tkyyTextView.text;
    course.tkjg = self.tkjgTextView.text;
    self.course = course;
}

/**
 *  获取请求参数
 */
- (void)getviewState{
    HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
    __weak typeof(self) weakSelf = self;
     [netWorkTool.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
    [netWorkTool getViewStateWithURLString: kTKTJUrl finishedBlock:^(id object) {
        if (object!=nil) {
            weakSelf.viewState = object;
//            NSLog(@"提交self.viewState=%@",weakSelf.viewState);
        }
    }];
}

/**
 *  提交
 */
- (IBAction)submitButtonClick {
    if(self.bjmcTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"班级名称不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.kcmcTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"课程名称不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.skrqTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"上课日期不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.zcTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"上课周次不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
   else if(self.xqTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"上课星期不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.jcTextField.text.length == 0){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"上课节次不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.tkyyTextView.textColor == [UIColor lightGrayColor]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"调课原因不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if(self.tkjgTextView.textColor == [UIColor lightGrayColor]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"调课结果不能为空！" preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else{
        [self getCourseData];
        //申请日期
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [NSDateFormatter new];
        df.dateFormat = @"yyyy-M-d ";
        NSString *dateStr = [df stringFromDate:date];
        //上课日期
        NSDate *skrqDate = [df  dateFromString:self.skrqTextField.text];
        df.dateFormat = @"d";
        NSString *day = [df stringFromDate:skrqDate];
        df.dateFormat = @"M";
        NSString *month = [df stringFromDate:skrqDate];
        df.dateFormat = @"yyyy";
        NSString *year = [df stringFromDate:skrqDate];
       
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:self.bjmcTextField.text forKey:@"txtbjmc"];
        [params setValue:self.kcmcTextField.text forKey:@"txtkcmc"];
        [params setValue:dateStr forKey:@"txtsksj"];
        [params setValue:day forKey:@"txtsksj_day"];
        [params setValue:month forKey:@"txtsksj_month"];
        [params setValue:year forKey:@"txtsksj_year"];
        [params setValue:self.zcTextField.text forKey:@" txtskzc"];
        [params setValue:self.xqTextField.text forKey:@"txtxq"];
        [params setValue:self.jcTextField.text forKey:@"txtskjc"];
        [params setValue:self.tkyyTextView.text forKey:@"txttkyy"];
        [params setValue:self.tkjgTextView.text forKey:@"txttkjg"];
        [params setValue:@"提 交" forKey:@" btnsave"];
        [params setValue:self.viewState forKey:@"__VIEWSTATE"];
//        NSLog(@"申请__VIEWSTATE%@",[params valueForKey:@"__VIEWSTATE"]);
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Confirm" bundle:nil];
        HYNConfirmController *confirmVC = [board instantiateViewControllerWithIdentifier:@"HYNApplicationConfirmController"];
        confirmVC.course = self.course;
        [SVProgressHUD showWithStatus:@"正在提交"];
//        NSLog(@"========params%@",params);
        HYNNetWorkTool *netWorkTool = [HYNNetWorkTool sharedNetWorkTool];
        [netWorkTool.requestSerializer setValue:@"keep-alive" forHTTPHeaderField:@"Connection"];
//        NSDictionary *heard = [netWorkTool.requestSerializer HTTPRequestHeaders];
//        NSLog(@"提交请求头信息%@",heard);
        __weak typeof(self) weakSelf = self;
        [netWorkTool POSTWithURLString:kTKTJUrl andWithParameters:params finishedBlock:^(id object) {
            [SVProgressHUD dismiss];
            if (object != nil) {
                NSError *error = nil;
                GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:object encoding:NSUTF8StringEncoding error:&error];
//                GDataXMLElement *rootElement = [document rootElement];
//                NSLog(@"申请提交element=%@",rootElement);
//                NSArray *inputs = [document nodesForXPath:@"//input" error:&error];
//                if (error) {
//                    return ;
//                }
//                for (GDataXMLElement *inputElement in inputs) {
////                    NSLog(@"Course+++inputElement===%@",inputElement);
//                    if ([[[inputElement attributeForName:@"name"] stringValue] isEqualToString:@"__VIEWSTATE"]) {
//                        NSString *value = [[inputElement attributeForName:@"value"] stringValue];
//                        confirmVC.viewState = value;
//                    }
//                }
                GDataXMLElement *titleElement = [[document nodesForXPath:@"//title" error:&error] objectAtIndex:0];
                if (error) {
                    return ;
                }
                NSString *title = [titleElement stringValue];
                if ([title isEqualToString:@"start"]) {
                    [weakSelf.navigationController pushViewController:confirmVC animated:YES];
                }else{
                    [SVProgressHUD showErrorWithStatus:@"提交失败"];
                }
            }else{
                 [SVProgressHUD showErrorWithStatus:@"提交失败"];
            }
        }];
    }
}

-(void)clearAllText{
    self.bjmcTextField.text = nil;
    self.kcmcTextField.text = @"";
    self.skrqTextField.text = @"";
    self.zcTextField.text = @"";
    self.xqTextField.text = @"";
    self.jcTextField.text = @"";
    self.tkyyTextView.text = @"填写调课原因，不能超出30个字";
    self.tkyyTextView.textColor = [UIColor lightGrayColor];
    self.tkjgTextView.text = @"输入格式1:调至2008年9月1日第一周（周二）3-4节AE101教室                       输入格式2:改上自习";
    self.tkjgTextView.textColor = [UIColor lightGrayColor];
}

/**
 *  开始编辑
 */
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (textView.tag == 1001) {
        if (self.tkyyTextView.textColor == [UIColor lightGrayColor]) {
            self.tkyyTextView.text = @"";
            self.tkyyTextView.textColor = [UIColor blackColor];
        }
    }
    if (textView.tag == 1002) {
        if (self.tkjgTextView.textColor == [UIColor lightGrayColor]) {
            self.tkjgTextView.text = @"";
            self.tkjgTextView.textColor = [UIColor blackColor];
        }
    }
    // 先取出当前的偏移量
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.y = 210;
    //动画滚动
    [self.scrollView setContentOffset:contentOffset animated:YES];
    //NSLog(@"开始编辑");
}

/**
 *  结束编辑
 */
- (void)textViewDidEndEditing:(UITextView *)textView{
    if (textView.text.length == 0) {
        if (textView.tag == 1001) {
            self.tkyyTextView.text = @"填写调课原因,不能超出30个字";
            self.tkyyTextView.textColor = [UIColor lightGrayColor];
        }
        if (textView.tag == 1002) {
            self.tkjgTextView.text = @"输入格式1:调至2008年9月1日第一周（周二）3-4节AE101教室                       输入格式2:改上自习";
            self.tkjgTextView.textColor = [UIColor lightGrayColor];
        }
    }else{
        if (textView.tag == 1001) {
            if (textView.text.length > 30) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"调课原因已超出30个字!" preferredStyle: UIAlertControllerStyleAlert];
                UIAlertAction *action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
    }
    // 先取出当前的偏移量
    CGPoint contentOffset = self.scrollView.contentOffset;
    contentOffset.y = 0;
    //动画滚动
    [self.scrollView setContentOffset:contentOffset animated:YES];
}

#pragma mark - 代理方法
// 选中某一组的某一行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSString *selpick = self.picks[component][row];
    switch (component) {
        case 0:
            self.zcTextField.text = selpick;
            break;
        case 1:
            self.xqTextField.text = selpick;
            break;
        case 2:
            self.jcTextField.text = selpick;
            break;
        default:
            break;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger) row forComponent:(NSInteger)component {
    return self.picks[component][row];
}

#pragma mark- 数据源方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return self.picks.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.picks[component] count];
}

#pragma mark - 懒加载
- (NSArray *)picks {
    
    if (_picks == nil) {
        _picks = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"picks.plist" ofType:nil]];
    }
    return _picks;
}

/**
 *  用户信息按钮
 */
- (IBAction)userinfoButtonClick:(id)sender {
    // 发送一个名字为userinfoButtonClick的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userinfoButtonClick" object:self];
}

/**
 *  tooBar 取消按钮
 */
- (void)cancelItemClick {
    self.zcTextField.text = @"";
    self.xqTextField.text = @"";
    self.jcTextField.text = @"";
    [self.view endEditing:YES];
}

/**
 *  tooBar 确认按钮
 */
- (void)doneItemClick {
    //获取选中的日期
    NSDate *date = self.datePicker.date;
    //将日期设置给文本框
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd"; // HH:mm:ss 时分秒
    NSString *str = [formatter stringFromDate:date];
    //赋值给文本框
    self.skrqTextField.text = str;
    //关闭键盘
  [self.view endEditing:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 懒加载控件
- (UIToolbar *)toolbar {
    if (!_toolbar) {
        //只需要高度就够了
        _toolbar = [[UIToolbar alloc] init];
        _toolbar.bounds = CGRectMake(0, 0, 0, 44);
        
        //创建按钮放到工具条里面
        //取消
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelItemClick)];
        //弹簧
        UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //确认
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(doneItemClick)];
        //items里面存放的按钮都是UIBarbuttonItem类型, 而且这些按钮最终是要现实到工具条上的
        _toolbar.items = @[cancelItem, flexSpace, doneItem];
    }
    return _toolbar;
}

- (UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}


- (UIDatePicker *)datePicker {
    
    if (!_datePicker) {
        //不需要设置frame 自动占据键盘的位置
        _datePicker = [[UIDatePicker alloc] init];
        //日期模式
        _datePicker.datePickerMode = UIDatePickerModeDate;
        //本地化local
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh-Hans"];
    }
    return _datePicker;
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
