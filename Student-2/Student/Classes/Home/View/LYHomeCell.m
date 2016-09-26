//
//  LYQuestionCell.m
//  ITSNS
//
//  Created by Ivan on 16/1/13.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRMainNavigationController.h"
#import "TRRewardViewController.h"
 #import "AppDelegate.h"
#import "LYHomeCell.h"
#import "TRUserInfoViewController.h"
@implementation LYHomeCell
//初始化方法
-(void)awakeFromNib{
    //设置Cell选中背景颜色
    self.selectedBackgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.selectedBackgroundView.backgroundColor = MainColor;
  
    
    self.backgroundColor = kRGBA(230, 230, 230, 1);
    self.contentView.backgroundColor = [UIColor whiteColor];
    //创建itobjView
    self.objView = [[TRITObjectView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headIV.frame), LYSW, 0)];
    
    [self addSubview:self.objView];
  //头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.headIV addGestureRecognizer:tap];
    self.headIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.nameLabel addGestureRecognizer:nameTap];
    self.nameLabel.userInteractionEnabled = YES;
    
    

    
 
}
-(void)userInfoAction{
    //点击用户头像做的事儿
    TRUserInfoViewController *vc = [TRUserInfoViewController new];
    
    vc.user = self.itObj.user;
    vc.hidesBottomBarWhenPushed = YES;
    //得到当前显示的导航控制器跳转
    UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nc = tbc.selectedViewController;
    [nc pushViewController:vc animated:YES];
    
}




-(void)setItObj:(TRITObject *)itObj{
    _itObj = itObj;
    //隐藏 图片 位置 录音的按钮
    self.audioBtn.hidden = self.imageBtn.hidden  = YES;
   
    if (itObj.voicePath) {
        self.audioBtn.hidden = NO;
    }
    if (itObj.imagePaths.count>0) {
        self.imageBtn.hidden = NO;
    }
    //设置昵称
    self.nameLabel.text = itObj.userNick;
    NSString *headPath = itObj.userHeadPath;
    //设置头像
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:headPath] placeholderImage:[UIImage imageNamed:@"loadingImage.png"]];
    //设置时间
    self.timeLabel.text = [itObj createdTime];
    
 
    //设置真正消息内容
    self.objView.itObj = itObj;
    
    self.objView.height = self.objView.titleTV.bounds.size.height+self.objView.detailTV.bounds.size.height+3*LYMargin+itObj.imagesHeight;
//    NSLog(@"%f",self.objView.height);
    
 
    //显示浏览量
    [self.showCountBtn setTitle:[NSString stringWithFormat:@"%d",itObj.showCount] forState:UIControlStateNormal];
    self.showCountBtn.hidden = itObj.showCount==0?YES:NO;
    //显示评论量
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%d",itObj.commentCount] forState:UIControlStateNormal];
     self.commentBtn.hidden = itObj.commentCount==0?YES:NO;
}

//每次显示cell的时候都会执行
-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.contentView.height = self.height-5;
    
}

 
- (IBAction)scoreAction:(UIButton *)sender {
    
    
    self.scoreBtn.backgroundColor = [UIColor lightGrayColor];
    [self.scoreBtn setTitle:@"已领取" forState:UIControlStateNormal];
    self.scoreBtn.enabled = NO;
    
    TRRewardViewController *vc = [TRRewardViewController new];
    vc.obj = self.itObj.bObj;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:[[TRMainNavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
}
@end
