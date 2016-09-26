//
//  TRRedBag.m
//  Student
//
//  Created by tarena on 16/9/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRRedBag.h"
#import "Utils.h"
@implementation TRRedBag
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.offsetX = 3;
        self.offsetY = -3;
        [self setImage:[UIImage imageNamed:@"redBag"] forState:UIControlStateNormal];
        
       self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/30 target:self selector:@selector(moveAction) userInfo:nil repeats:YES];
        
        
//        [self scaleAnimation];
        
        
        //添加点击事件
        [self addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}
-(void)tapAction{
    
    [self removeFromSuperview];
    [self.timer invalidate];
    


    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"恭喜你获得金币：%d，积分：%d",self.score,self.money] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [ac addAction:action1];
 
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    
}

-(void)scaleAnimation{
    [UIView animateWithDuration:2 animations:^{
        self.transform = CGAffineTransformMakeScale(.5, .5);
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:2 animations:^{
            self.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            
            [self scaleAnimation];
            
        }];
        
    }];
}

-(void)moveAction{
    
    self.center = CGPointMake(self.center.x+self.offsetX, self.center.y+self.offsetY);
    //左右边
    if (self.right>=LYSW||self.left<=0) {
        
        self.offsetX*=-1;
        
    }
    
//  上下
    if (self.top<=0||self.bottom>=LYSH) {
        self.offsetY*=-1;
    }
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
