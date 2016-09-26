//
//  LYWelcomeViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRWelcomeViewController.h"
#import "TRLoginViewController.h"
@interface TRWelcomeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
 

@end

@implementation TRWelcomeViewController
 
- (IBAction)loginAction:(id)sender {
    TRLoginViewController *vc = [[TRLoginViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   self.loginBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.loginBtn.layer.borderWidth = 1;
     self.loginBtn.layer.cornerRadius= self.loginBtn.bounds.size.height/2;
    self.loginBtn.layer.masksToBounds = self.loginBtn.layer.masksToBounds = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
