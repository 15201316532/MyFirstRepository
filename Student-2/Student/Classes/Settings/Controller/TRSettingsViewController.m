//
//  SettingsViewController.m
//  Student
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRSettingsViewController.h"
#import "AppDelegate.h"
@interface TRSettingsViewController ()

@end

@implementation TRSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //登出操作
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:@"username"];
    [ud removeObjectForKey:@"password"];
    //把单例重置
    [[TRUser currentUser] logout];
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    [app showWelcomeVC];
    
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
