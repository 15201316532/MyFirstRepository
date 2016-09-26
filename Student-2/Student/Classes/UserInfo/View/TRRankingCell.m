//
//  ZCRankingCell.m
//  Student
//
//  Created by tarena on 16/9/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRRankingCell.h"

@implementation TRRankingCell

-(void)setUser:(BmobObject *)user{
    _user = user;
    
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    self.nameLabel.text = [user objectForKey:@"nick"];
    NSInteger amount = self.rankType == RANKTYPESCORE?[[user objectForKey:@"score"] integerValue]:[[user objectForKey:@"money"] integerValue];
    self.amountLabel.text = @(amount).stringValue;
}

- (void)awakeFromNib {
    self.headIV.layer.cornerRadius = 10;
    self.headIV.layer.masksToBounds = YES;
    self.nameLabel.font = [UIFont boldSystemFontOfSize:12];
    self.nameLabel.textColor = [UIColor redColor];
    
    
}
//每次控件显示之前执行 执行此方法的时候 所有给控件赋值的代码都已经执行完
-(void)layoutSubviews{
    [super layoutSubviews];
    //得到排名
    int index = self.rankLabel.text.intValue;

//    self.crownIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"crown%d",index]];
    
    self.medalIV.image = [UIImage imageNamed:[NSString stringWithFormat:@"medal%d",index]];
}

@end
