//
//  TRMainTabbarViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRRankingViewController.h"
#import "TRMainNavigationController.h"
#import "TRMainTabbarViewController.h"
#import "TRHomeViewController.h"
#import "TRStoreTableViewController.h"
#import "TRStudentsTableViewController.h"
#import "TRSettingsTableViewController.h"

@interface TRMainTabbarViewController ()

@end

@implementation TRMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TRHomeViewController *homeVC = [TRHomeViewController new];
    TRStudentsTableViewController *studentVC = [TRStudentsTableViewController new];
    
    TRRankingViewController *rankingVC = [TRRankingViewController new];
    
    TRStoreTableViewController *storeVC = [TRStoreTableViewController new];
    
    TRSettingsTableViewController *setttingsVC = [TRSettingsTableViewController new];
    
    homeVC.title = @"作业";
    studentVC.title = @"学生";
    rankingVC.title = @"排行榜";
    storeVC.title = @"商品";
    setttingsVC.title = @"设置";
    
 
    
    
    homeVC.tabBarItem.image = [UIImage imageNamed:@"推荐_默认"];
 
    
    studentVC.tabBarItem.image = [UIImage imageNamed:@"我的_默认"];
   
    rankingVC.tabBarItem.image = [UIImage imageNamed:@"ranking"];
    
    storeVC.tabBarItem.image = [UIImage imageNamed:@"栏目_默认"];
  
    
    setttingsVC.tabBarItem.image = [UIImage imageNamed:@"系统设置"];
 
    
    self.viewControllers = @[[[TRMainNavigationController alloc] initWithRootViewController:homeVC],[[TRMainNavigationController alloc] initWithRootViewController:studentVC],[[TRMainNavigationController alloc] initWithRootViewController:rankingVC],[[TRMainNavigationController alloc] initWithRootViewController:storeVC],[[TRMainNavigationController alloc] initWithRootViewController:setttingsVC]];
    
    
    self.tabBar.tintColor = MainColor;
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
