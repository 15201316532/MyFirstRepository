//
//  LYLoginViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/10.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRLoginViewController.h"
#import "AppDelegate.h"

@interface TRLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation TRLoginViewController
- (IBAction)loginAction:(id)sender {

    //创建查询请求
    BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
//    设置查询条件用户名 为用户输入的用户名
    [bq whereKey:@"username" equalTo:self.userNameTF.text];
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
//       判断是否查询到
        if (array.count>0) {
//            得到查询到的用户对象
            BmobObject *userObj = [array firstObject];
            //得到该用户的密码
            NSString *pw = [userObj objectForKey:@"password"];
            //判断用户输入的和真正密码是否相等
            if ([pw isEqualToString:self.pwTF.text]) {//登录成功 显示首页
                
                
                //保存用户登录信息
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                [ud setObject:self.userNameTF.text forKey:@"username"];
                [ud setObject:pw forKey:@"password"];
                
                [ud synchronize];
                
              
                AppDelegate *app = [UIApplication sharedApplication].delegate;
                [app showHomeVC];
                
                
            }else{//密码错误
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"密码错误" preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                
                [ac addAction:action1];
                
                
                [self presentViewController:ac animated:YES completion:nil];
                
                
            }
            
            
        }else{//用户名错误
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"用户名错误" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            
            [ac addAction:action1];
     
            
            [self presentViewController:ac animated:YES completion:nil];
        }
        
        
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置bar的颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    self.title = @"登陆";

      [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)keyboardFrameChange:(NSNotification*)noti{
    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
 
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        if (keyboardF.origin.y==LYSH) {//收键盘
            self.loginBtn.transform = CGAffineTransformIdentity;
            
        }else{//软件盘弹出的时候 把表情隐藏
            self.loginBtn.transform = CGAffineTransformMakeTranslation(0, -keyboardH);
            
            
        }
    }];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
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
