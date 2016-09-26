//
//  TRMainViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRMainNavigationController.h"

@interface TRMainNavigationController ()

@end

@implementation TRMainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    //改变导航栏的颜色
    self.navigationBar.barTintColor = MainColor;

    //改变导航栏中按钮的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    
}

//设置状态栏（运行商 电量）为白色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
