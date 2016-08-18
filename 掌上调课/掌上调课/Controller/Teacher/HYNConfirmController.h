//
//  HYNConfirmController.h
//  掌上调课
//
//  Created by 黄亚男 on 16/5/12.
//  Copyright © 2016年 黄亚男. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface HYNConfirmController : UITableViewController

@property (nonatomic, strong) Course *course;
@property (nonatomic, copy) NSString *viewState;
@end
