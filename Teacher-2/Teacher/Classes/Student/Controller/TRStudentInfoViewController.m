//
//  TRStudentInfoViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import <MBProgressHUD.h>
#import "TRStudentInfoViewController.h"
@interface TRStudentInfoViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)NSArray *classes;
@property (weak, nonatomic) IBOutlet UITextField *pwTF;
@property (weak, nonatomic) IBOutlet UITextField *nickTF;
@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (nonatomic, strong)NSData *imageData;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIPickerView *dataPicker;
@property (nonatomic, strong)NSMutableArray *selectedClasses;
@property (nonatomic, strong)NSMutableArray *classesBtns;
@end

@implementation TRStudentInfoViewController
- (IBAction)tapAction:(id)sender {
    UIImagePickerController *pc = [UIImagePickerController new];
    pc.delegate = self;
    pc.allowsEditing = YES;
    [self presentViewController:pc animated:YES completion:nil];
}
- (IBAction)classAction:(id)sender {
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"新建学生";
    //用来装班级按钮的数组 为了实现删除班级做动画
    self.classesBtns = [NSMutableArray array];
    //添加已选择班级的数组
    self.selectedClasses = [NSMutableArray array];

 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
    
 
    
    [self loadClasses];
    
    
    //如果user有值则为编辑功能
    if (self.user) {
        self.title = @"编辑信息";
        self.usernameTF.text = [self.user objectForKey:@"username"];
         self.pwTF.text = [self.user objectForKey:@"password"];
         self.nickTF.text = [self.user objectForKey:@"nick"];
        [self.headIV sd_setImageWithURL:[NSURL URLWithString:[self.user objectForKey:@"headPath"]] placeholderImage:LoadingImage];
        
        //把班级信息取出
        NSArray *classes = [self.user objectForKey:@"classes"];
        
        for (int i=0; i<classes.count; i++) {
            NSString *className = classes[i];
            
            [self addClassBtnWithClassName:className];
        }

    }
    
    
}
- (void)saveAction{
    
    if (self.usernameTF.text.length==0||self.nickTF.text.length==0||self.pwTF.text.length==0||self.selectedClasses.count==0) {
        
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请完善学生信息" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [ac addAction:action1];
        [ac addAction:action2];
        
        [self presentViewController:ac animated:YES completion:nil];
        return;
    }
    
    
    
    
    //判断是否是编辑功能
    if (self.user) {
        
        [self.user setObject:self.usernameTF.text forKey:@"username"];
        [self.user setObject:self.pwTF.text forKey:@"password"];
        [self.user setObject:self.nickTF.text forKey:@"nick"];
        [self.user setObject:self.selectedClasses forKey:@"classes"];
        
        //更新用户数据
        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            //是否修改过图片
            if (self.imageData) {
                
                
                //显示上传进度
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                hud.label.text = @"正在上传头像。。。";
                
            
                //创建上传文件的对象
                BmobFile *bf = [[BmobFile alloc]initWithFileName:@"head.jpg" withFileData:self.imageData];
                [bf saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //如果上传成功把图片设置给新建的学生对象
                        [self.user setObject:bf.url forKey:@"headPath"];
                        
                        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"图片添加成功");
                                [hud hideAnimated:YES];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        
                    }
                } withProgressBlock:^(CGFloat progress) {
                    hud.progress = progress;
                }];

                
                
            }else{//没有修改图片则直接返回页面
                  [self.navigationController popViewControllerAnimated:YES];
            }
            
            
        }];
        
        return;
    }
    
    //代码继续往下执行说明是新建功能
    
    BmobObject *user = [[BmobObject alloc]initWithClassName:@"TRUser"];
    [user setObject:self.usernameTF.text forKey:@"username"];
    [user setObject:self.pwTF.text forKey:@"password"];
    [user setObject:self.nickTF.text forKey:@"nick"];
    [user setObject:self.selectedClasses forKey:@"classes"];
    [user saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        
        if (isSuccessful) {
            NSLog(@"注册新用户成功！");
            //判断是否有图片
            if (self.headIV.image) {
                
                //显示上传进度
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                hud.label.text = @"正在上传头像。。。";
                
                //得到要上传的图片数据
                NSData *data = UIImageJPEGRepresentation(self.headIV.image, .5);
                //创建上传文件的对象
                BmobFile *bf = [[BmobFile alloc]initWithFileName:@"head.jpg" withFileData:data];
                [bf saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        //如果上传成功把图片设置给新建的学生对象
                        [user setObject:bf.url forKey:@"headPath"];
                        
                        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                            if (isSuccessful) {
                                NSLog(@"图片添加成功");
                                [hud hideAnimated:YES];
                                
                                [self.navigationController popViewControllerAnimated:YES];
                            }
                        }];
                        
                    }
                } withProgressBlock:^(CGFloat progress) {
                    hud.progress = progress;
                }];
                
            }else{//如果没有图片直接返回页面
                [self.navigationController popViewControllerAnimated:YES];
            }

        }
        
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Navigation
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
 
 // returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.classes.count;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *label = (UILabel *)view;
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        
    }
    BmobObject *classObj = self.classes[row];
    label.text = [classObj objectForKey:@"className"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    BmobObject *classObj = self.classes[row];
    
    NSString *className = [classObj objectForKey:@"className"];
    //判断不包含的时候添加
    if (![self.selectedClasses containsObject:className]) {
      
        
        [self addClassBtnWithClassName:className];
    }
    
    
}

-(void)addClassBtnWithClassName:(NSString *)className{
    UIButton *classBtn = [[UIButton alloc]initWithFrame:CGRectMake(20+self.selectedClasses.count*90, 320, 80, 30)];
    [classBtn setTitle:className forState:UIControlStateNormal];
    classBtn.layer.borderColor = MainColor.CGColor;
    classBtn.backgroundColor = MainColor;
    classBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    classBtn.layer.borderWidth = 2;
    [self.view addSubview:classBtn];
    [classBtn addTarget:self action:@selector(removeClassAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.selectedClasses addObject:className];
    //添加到这个数组为了删除的时候改变位置
    [self.classesBtns addObject:classBtn];
}
//点击班级时删除班级按钮
-(void)removeClassAction:(UIButton *)classBtn{
    //从数组中删除
    [self.selectedClasses removeObject: [classBtn titleForState:UIControlStateNormal]];
    
    [classBtn removeFromSuperview];
    //从按钮数组中删除
    [self.classesBtns removeObject:classBtn];
    
    for (int i=0; i<self.classesBtns.count; i++) {
        UIButton *btn = self.classesBtns[i];
        [UIView animateWithDuration:.5 animations:^{
               btn.frame = CGRectMake(20+i*90, 320, 80, 30);
        }];
     
    }
}

-(void)loadClasses{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Classes"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        self.classes = array;
        [self.dataPicker reloadAllComponents];
        
    }];
    
}

#pragma mark 选择图片协议
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.headIV.image = image;
    self.imageData = UIImageJPEGRepresentation(self.headIV.image, .5);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
