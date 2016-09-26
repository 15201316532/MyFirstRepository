//
//  TRUserHeaderView.m
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRUserHeaderView.h"
#import "RNBlurModalView.h"

@implementation TRUserHeaderView

-(void)awakeFromNib{
    
    self.headIV.layer.cornerRadius = 10;
    
    self.headIV.layer.masksToBounds = YES;
    
}
-(void)setUser:(BmobUser *)user{
    _user = user;
    
    //显示积分
    int score = [[user objectForKey:@"score"]intValue];
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%d",score];
    
    //显示金币
    int money = [[user objectForKey:@"money"]intValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"金币：%d",money];
    
    self.nickTF.text = [user objectForKey:@"nick"];
    

    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
   
    [self.bgIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //把下载下来的图片模糊 并显示
        self.bgIV.image = [image boxblurImageWithBlur:.5];
        
    }];
    NSArray *classesArr = [user objectForKey:@"classes"];
    //显示班级
    self.classesLabel.text = [classesArr componentsJoinedByString:@"、"];
    
}

-(void)updateSubViewsWithOffset:(float)offset{
    
    offset+=64;
    
    
    NSLog(@"%f",offset);
    //让背景图片缩放
    if (offset<0&&offset>=-180) {
//        0    1
//        200  1.5
        float scale = 1+ -offset/400;
//        1 + offset/200
        
        self.bgIV.transform = CGAffineTransformMakeScale(scale, scale);
        
        
        
    }
    
    
    //让label隐藏
    if (offset>0&&offset<=100) {
//        0    100
//        1     0
        
        
        self.labelView.alpha =  1 - offset/100;
        
       
        
    }
    
    
    if (offset>0&&offset<=114) {
        [self bringSubviewToFront:self.headIV];
        float scale = 1 - offset/250;
        
        self.headIV.transform = CGAffineTransformMakeScale(scale, scale);
        NSLog(@"====%f",self.headIV.center.y);
    }
    
    if (offset>114&&offset<185) {
        
        [self bringSubviewToFront:self.bottomView];
        
        
        float y = offset - 114;
        
        self.headIV.center = CGPointMake(self.headIV.center.x, 154+y);
        
        
    }
    
    
}


@end
