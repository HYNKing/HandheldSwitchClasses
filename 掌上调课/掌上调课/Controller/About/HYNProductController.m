//
//  HYNProductController.m
//  掌上调课
//
//  Created by 黄亚男 on 16/5/22.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import "HYNProductController.h"
@interface HYNProductController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation HYNProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGRect rect = [[self view] bounds];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:rect];
    [imageView setImage:[UIImage imageNamed:@"Background"]];
    //[self.view setBackgroundColor:[UIColor clearColor]];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = imageView;
    
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.rowHeight = 44;
//    //隐藏没有数据的表格
//    self.tableView.tableFooterView = [[UIView alloc] init];
    // NSLog(@"加载view");
    [self setIcon];
}


- (void)setIcon{
    //获取图片
    UIImage *image = [UIImage imageNamed:@"Icon-60"];
//    //设置圆环线宽
//    CGFloat arcLineWith = 1;
//    //设置图片类型的图形上下文的大小
//    CGSize contextRefSize = CGSizeMake(image.size.width + 2 * arcLineWith, image.size.height + 2 * arcLineWith);
//    //开启图片类型的图形上下文
//    UIGraphicsBeginImageContextWithOptions(contextRefSize, NO, 0);
//    //获取图形上下文
//    CGContextRef contextRef = UIGraphicsGetCurrentContext();
//    //计算圆心
//    CGPoint arcCenter = CGPointMake(contextRefSize.width * 0.5, contextRefSize.height * 0.5);
//    //计算显示图片区域圆的半径
//    CGFloat iconRadius = MIN(image.size.width, image.size.height) * 0.5;
//    //计算圆环的半径
//    CGFloat ringRadius = iconRadius + (arcLineWith  * 0.5);
//    //画圆环
//    CGContextAddArc(contextRef, arcCenter.x, arcCenter.y, ringRadius, 0, 2 * M_PI, 1);
//    //设置线宽
//    CGContextSetLineWidth(contextRef,arcLineWith);
//    //设置颜色
//    [[UIColor lightGrayColor] set];
//    //渲染圆环
//    CGContextStrokePath(contextRef);
//    //画图片显示区域
//    CGContextAddArc(contextRef, arcCenter.x, arcCenter.y, iconRadius, 0, 2 * M_PI, 1);
//    //裁剪显示区域
//    CGContextClip(contextRef);
//    //画图片
//    [image drawAtPoint:CGPointMake(arcLineWith, arcLineWith)];
//    //获取图形上下文当前图片
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    //关闭图片类型的图形上下文
//    UIGraphicsEndImageContext();
//    //把获取到的图形上下文当前图片添加到相框中
    self.iconImageView.image = image;
    self.iconImageView.layer.cornerRadius = 47;
    self.iconImageView.layer.masksToBounds = YES;

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor clearColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
