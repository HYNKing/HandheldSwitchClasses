//
//  HYNReceiptCell.m
//  
//
//  Created by 黄亚男 on 16/5/12.
//
//

#import "HYNReceiptCell.h"

@interface HYNReceiptCell ()
@property (weak, nonatomic) IBOutlet UILabel *bjmcLabel;
@property (weak, nonatomic) IBOutlet UILabel *kcmcLabel;

@end
@implementation HYNReceiptCell

- (void)setCourse:(Course *)course{
    _course = course;
    self.bjmcLabel.text = course.bjmc;
    self.kcmcLabel.text = course.kcmc;
}

+ (instancetype)createReceiptCellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"ReceiptCell";
    HYNReceiptCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"HYNReceiptCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (IBAction)fillInButtonClick:(id)sender {
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"fillInButtonClick" object:self];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


@end
