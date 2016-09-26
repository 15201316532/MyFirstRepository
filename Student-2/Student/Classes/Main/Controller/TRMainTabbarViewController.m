//
//  TRMainTabbarViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "Utils.h"
#import "TRRedBag.h"
#import "NSString+TRPassword.h"
#import "TRMainNavigationController.h"
#import "TRMainTabbarViewController.h"
#import "TRHomeViewController.h"
#import "TRStoreTableViewController.h"
#import "TRHomeworkTableViewController.h"
#import "TRSettingsViewController.h"
#import "TRUserInfoViewController.h"
#import "AppDelegate.h"
#import "TRRankingViewController.h"
@interface TRMainTabbarViewController ()
@property (nonatomic, strong)TRHomeworkTableViewController *homeworkVC;
@end

@implementation TRMainTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    TRHomeViewController *homeVC = [TRHomeViewController new];
    TRHomeworkTableViewController *homeworkVC = [TRHomeworkTableViewController new];
    TRStoreTableViewController *storeVC = [TRStoreTableViewController new];
    
    TRRankingViewController *rankingVC = [TRRankingViewController new];
    TRUserInfoViewController *userVC = [TRUserInfoViewController new];
    
    homeVC.title = @"朋友圈";
    homeworkVC.title = @"作业";
    userVC.title = @"用户";
    storeVC.title = @"商品";
    rankingVC.title = @"排行榜";
    
    
    
    
    homeVC.tabBarItem.image = [UIImage imageNamed:@"推荐_默认"];
 
    homeworkVC.tabBarItem.image = [UIImage imageNamed:@"homework"];
 
    
    userVC.tabBarItem.image = [UIImage imageNamed:@"我的_默认"];
 
    self.homeworkVC = homeworkVC;
    storeVC.tabBarItem.image = [UIImage imageNamed:@"栏目_默认"];
 
    
    rankingVC.tabBarItem.image = [UIImage imageNamed:@"ranking"];

    
    self.viewControllers = @[[[TRMainNavigationController alloc] initWithRootViewController:homeVC],[[TRMainNavigationController alloc] initWithRootViewController:homeworkVC],[[TRMainNavigationController alloc] initWithRootViewController:rankingVC],[[TRMainNavigationController alloc] initWithRootViewController:userVC],[[TRMainNavigationController alloc] initWithRootViewController:storeVC]];
    
    self.tabBar.tintColor = MainColor;
    
    [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkingHomework) userInfo:nil repeats:YES];
    [self checkingHomework];
}
-(void)checkingHomework{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Homework"];
    //查询条件 跟自己班级有关的作业
    [bq whereKey:@"classes" containedIn:[TRUser currentUser].classes];
    
    //查询用户注册日期以后的作业
    [bq whereKey:@"createdAt" greaterThanOrEqualTo:[TRUser currentUser].createdAt];
    
    //查询完成学生数组中没有出现自己的作业  查询的是未完成的作业
    [bq whereKey:@"finishedStudents" notContainedIn:@[[TRUser currentUser].username]];
    
    //统计数量的请求
    [bq countObjectsInBackgroundWithBlock:^(int number,NSError  *error){
        if (number>0) {
             self.homeworkVC.tabBarItem.badgeValue = @(number).stringValue;
        }else{
             self.homeworkVC.tabBarItem.badgeValue = nil;
        }
        
    }];
    
  
   
    //请求是否有自己的红包
    BmobQuery *query = [BmobQuery queryWithClassName:@"RedBag"];
    [query whereKey:@"username" equalTo:[TRUser currentUser].username];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        for (BmobObject *obj in array) {
            
            TRRedBag *rb = [[TRRedBag alloc]initWithFrame:CGRectMake(arc4random()%((int)LYSW-80), arc4random()%((int)LYSH - 80), 80, 80)];
            rb.score = [[obj objectForKey:@"score"]intValue];
            rb.money = [[obj objectForKey:@"money"]intValue];
            [self.view addSubview:rb];
            
            
            if (rb.score>0) {
                [Utils addScore:rb.score];
            }
            
            if (rb.money>0) {
                [Utils addMoney:rb.money];
            }
            
            
            
            //红包从表中删除
            [obj deleteInBackground];
        }
        
        
    }];
  
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //判断如果用户密码为1-8则需要修改
    NSString *pw = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    if ([pw isEqualToString:@"12345678"]) {
        
        [self changePW];
        
    }
    
    
    
  
}



-(void)changePW{
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请修改初始密码数字+字母长度6-18位" preferredStyle:UIAlertControllerStyleAlert];
//    Status
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"密码";
    }];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"确认密码";
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *pw1 = ac.textFields[0].text;
        NSString *pw2 = ac.textFields[1].text;
        if ([pw1 isEqualToString:pw2]) {//两次相等
            
            //验证格式是否正确
            if (![pw1 checkPassword]) {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码格式不对" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self changePW];
                }];
                [ac addAction:action1];
            
                
                [self presentViewController:ac animated:YES completion:nil];
                
                
                return ;
            }
            
            
            //修改用户的密码
            NSString *username = [[NSUserDefaults standardUserDefaults]objectForKey:@"username"];
            BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
            [bq whereKey:@"username" equalTo:username];
            
            [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (array.count>0) {
                    BmobObject *userObj = [array firstObject];
                    
                    [userObj setObject:pw1 forKey:@"password"];
                    [userObj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                           
                            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                            [ud setObject:pw1 forKey:@"password"];

                            [ud synchronize];
                            
                            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码修改完成" preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                
                                AppDelegate *app = [UIApplication sharedApplication].delegate;
                                
                                //删除之前登录的信息
                                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                                [ud removeObjectForKey:@"username"];
                                [ud removeObjectForKey:@"password"];
                                [ud synchronize];
                                
                                //显示欢迎页面
                                [app showWelcomeVC];
                                
                                
                            }];
                            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                            [ac addAction:action1];
                            [ac addAction:action2];
                            
                            [self presentViewController:ac animated:YES completion:nil];
                            
                        }
                        
                        
                    }];
                    
                    
                    
                }
                
                
            }];
            
            
            
            
            
            
        }else{//两次输入不相等
            
            
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"两次输入不一致" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self changePW];
            }];
            [ac addAction:action1];
         
            
            [self presentViewController:ac animated:YES completion:nil];
            
            
        }
        
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action1];
    [ac addAction:action2];
    
    [self presentViewController:ac animated:YES completion:nil];
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
