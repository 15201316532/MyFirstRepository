//
//  AppDelegate.m
//  Student
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRWelcomeViewController.h"
#import "AppDelegate.h"
#import "TRMainTabbarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
 
    //初始化Bmob
    NSString *appKey = @"c9d6b622035d5bcfd9093ee91d7217b9";
    [Bmob registerWithAppKey:appKey];

    
    
    //判断是否登录过
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    NSString *password = [[NSUserDefaults standardUserDefaults]objectForKey:@"password"];
    if (username||password) {//登录过
        [self showHomeVC];
       
        
    }else{//没有登录过
        [self showWelcomeVC];
        
        
        
    }
     [self.window makeKeyAndVisible];
    
    return YES;
}
-(void)showHomeVC{
    
    //初始化单例user
    [TRUser currentUser];
    
    
    TRMainTabbarViewController *tvc = [TRMainTabbarViewController new];
    self.window.rootViewController = tvc;
//    做动画
    self.window.alpha = 0;
    self.window.transform = CGAffineTransformMakeScale(2, 2);
    [UIView animateWithDuration:.5 animations:^{
        self.window.alpha = 1;
        self.window.transform = CGAffineTransformIdentity;
    }];
    
   
    
}
-(void)showWelcomeVC{
    TRWelcomeViewController *vc = [TRWelcomeViewController new];
    self.window.rootViewController = [[UINavigationController alloc]initWithRootViewController:vc];
    //做动画
    self.window.alpha = 0;
    self.window.transform = CGAffineTransformMakeScale(2, 2);
    [UIView animateWithDuration:.5 animations:^{
        self.window.alpha = 1;
        self.window.transform = CGAffineTransformIdentity;
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
