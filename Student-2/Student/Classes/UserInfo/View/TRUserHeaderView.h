//
//  TRUserHeaderView.h
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRUserHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *classesLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgIV;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
 
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIView *labelView;

@property (nonatomic, strong)BmobObject *user;


-(void)updateSubViewsWithOffset:(float)offset;
@end
