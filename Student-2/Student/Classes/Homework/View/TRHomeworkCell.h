//
//  TRHomeworkCell.h
//  Student
//
//  Created by tarena on 16/9/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TRITObject.h"
#import "TRITObjectView.h"
@interface TRHomeworkCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *finishCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (nonatomic, strong)TRITObject *itObj;
@property (nonatomic, strong)TRITObjectView *objView;
@end
