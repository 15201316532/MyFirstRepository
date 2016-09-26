//
//  TRStudentCell.m
//  Teacher
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRUserInfoViewController.h"
#import "TRStudentCell.h"

@implementation TRStudentCell
- (IBAction)scoreAction:(id)sender {
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入修改的积分" preferredStyle:UIAlertControllerStyleAlert];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = @([[self.user objectForKey:@"score"] intValue]).stringValue;
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        int score = [ac.textFields[0].text intValue];
        [self.user setObject:@(score).stringValue forKey:@"score"];

        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"修改成功");
                self.scoreLabel.text = @([[self.user objectForKey:@"score"] intValue]).stringValue;
            }
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action1];
    [ac addAction:action2];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:nil];
    
}

- (void)awakeFromNib {
    self.scoreBtn.layer.cornerRadius = 5;
    self.scoreBtn.layer.masksToBounds = YES;

    //头像的点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.headIV addGestureRecognizer:tap];
    self.headIV.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *nameTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userInfoAction)];
    [self.nickLabel addGestureRecognizer:nameTap];
    self.nickLabel.userInteractionEnabled = YES;
    
}
-(void)userInfoAction{
    
    if (self.user) {
        //点击用户头像做的事儿
        TRUserInfoViewController *vc = [TRUserInfoViewController new];
        
        vc.user = self.user;
        vc.hidesBottomBarWhenPushed = YES;
        
        //得到当前显示的导航控制器跳转
        UITabBarController *tbc = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
        UINavigationController *nc = tbc.selectedViewController;
        [nc pushViewController:vc animated:YES];
    }
    
    
    
}


-(void)setUser:(BmobObject *)user{
    _user = user;
    
    self.usernameLabel.text = [user objectForKey:@"username"];
    self.nickLabel.text = [user objectForKey:@"nick"];
    self.scoreLabel.text = @([[user objectForKey:@"score"]intValue]).stringValue ;
    [self.headIV sd_setImageWithURL:[NSURL URLWithString:[user objectForKey:@"headPath"]] placeholderImage:LoadingImage];
    
    NSDateFormatter *f = [[NSDateFormatter alloc]init];
    [f setDateFormat:@"yy年MM月dd日 HH:mm"];
    self.timeLabel.text = [f stringFromDate:user.createdAt];
    
    
    
}

@end
