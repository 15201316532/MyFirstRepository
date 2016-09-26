//
//  TRCommentCell.m
//  ITSNS
//
//  Created by tarena on 16/8/30.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRUserInfoViewController.h"
#import "TRCommentCell.h"
#import "Utils.h"
@implementation TRCommentCell

- (void)awakeFromNib {
  
    self.commentView = [[TRCommentView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headIV.frame), LYSW, 0)];
    [self addSubview:self.commentView];
    //头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.headIV addGestureRecognizer:tap];
    self.headIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.nameLabel addGestureRecognizer:nameTap];
    self.nameLabel.userInteractionEnabled = YES;
    
}
-(void)userInfoAction{
   
    if (self.comment.user) {
        //点击用户头像做的事儿
        TRUserInfoViewController *vc = [TRUserInfoViewController new];
        
        vc.user = self.comment.user;
        vc.hidesBottomBarWhenPushed = YES;

        //得到当前显示的导航控制器跳转
        UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nc = tbc.selectedViewController;
        [nc pushViewController:vc animated:YES];
    }
    
   
    
}



-(void)setComment:(TRComment *)comment{
    _comment = comment;
    
    self.nameLabel.text = [comment.user objectForKey:@"nick"];
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[comment.user objectForKey:@"headPath"]] placeholderImage:[UIImage imageNamed:@"loadingImage"]];
    
    self.timeLabel.text = comment.createdTime;
    
    self.audioBtn.hidden = comment.voicePath ? NO : YES;
    self.commentView.comment = comment;
    
    self.commentView.height = [comment contentHeight];
    
}
- (IBAction)playAction:(id)sender {
    [Utils playVoiceWithPath:self.comment.voicePath];
    
}
@end
