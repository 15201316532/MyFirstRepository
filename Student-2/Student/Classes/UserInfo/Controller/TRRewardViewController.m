//
//  ViewController.m
//  DJRotainVIew
//
//  Created by Jason on 28/12/15.
//  Copyright © 2015年 Jason. All rights reserved.
//
#import "Utils.h"
#import "TRRewardViewController.h"
#import "DJRoationView.h"
#define AppWidth [[UIScreen mainScreen] bounds].size.width
#define AppHeight [[UIScreen mainScreen] bounds].size.height
@interface TRRewardViewController ()

@end

@implementation TRRewardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"领取积分奖励";
    self.view.backgroundColor = kRGBA(230, 230, 230, 1);
    
    UIImageView *iv = [[UIImageView alloc]initWithFrame:self.view.bounds];
    iv.image = [UIImage imageNamed:@"mmm"];
    [self.view addSubview:iv];
    DJRoationView *roationView = [[DJRoationView alloc] initWithFrame:CGRectMake(40, 140, AppWidth-80, AppWidth-80)];
    roationView.speed = 20;//调速度 最快20;
   
    [self.view addSubview:roationView];
 
    [roationView rotatingDidFinishBlock:^(NSInteger index, CGFloat score) {
        NSLog(@"indx=%ld,score=%.f",index,score);
      
        
        NSString *message = [NSString stringWithFormat:@"恭喜你获得%d个积分\n分享到朋友圈即可获得双倍积分",(int)score];
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"只拿%d分",(int)score] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [Utils addScore:score];
            //标记已领取奖励
            [self.obj setObject:@(YES) forKey:@"isReward"];
            //对象类型需要重新赋值
            [self.obj setObject:[self.obj objectForKey:@"user"] forKey:@"user"];
            [self.obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"领取成功！");
                }
            }];
            
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"分享获得双倍%d分",(int)score*2] style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            [Utils addScore:score*2];
            [self.obj setObject:@(YES) forKey:@"isReward"];
             [self.obj setObject:[self.obj objectForKey:@"user"] forKey:@"user"];
            [self.obj updateInBackground];

             [self dismissViewControllerAnimated:YES completion:nil];
        }];
        [ac addAction:action1];
        [ac addAction:action2];
        
        [self presentViewController:ac animated:YES completion:nil];
        
        
    }];//动画停止后回调


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
