//
//  TRSotreInfoViewController.m
//  Teacher
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import <MBProgressHUD.h>
#import "TRStoreInfoViewController.h"

@interface TRStoreInfoViewController ()<UITableViewDataSource, UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSC;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *moneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;

@property (nonatomic, strong)NSMutableArray *images;
@end

@implementation TRStoreInfoViewController
- (IBAction)imageAction:(id)sender {
    
    UIImagePickerController *vc = [UIImagePickerController new];
    vc.delegate = self;
    vc.allowsEditing = YES;
    [self presentViewController:vc animated:YES completion:nil];
 
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAction)];
}
- (void)saveAction{
    
    //必须添加价格
    if (self.moneyLabel.text.intValue<0) {
        UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入价格" preferredStyle:UIAlertControllerStyleAlert];
        
       
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        
        [ac addAction:action2];
        
        [self presentViewController:ac animated:YES completion:nil];
    }
    
    
    BmobObject *obj = [BmobObject objectWithClassName:@"Store"];
    [obj setObject:self.nameLabel.text forKey:@"name"];
    if (self.typeSC.selectedSegmentIndex==0) {//积分
        [obj setObject:@(self.moneyLabel.text.intValue) forKey:@"score"];
    }else{//金币
          [obj setObject:@(self.moneyLabel.text.intValue) forKey:@"money"];
    }

  
    
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            if (self.images.count>0) {
                NSMutableArray *imageInfos = [NSMutableArray array];
                for (UIImage *image in self.images) {
                    NSData *data = UIImageJPEGRepresentation(image, .5);
                     NSDictionary *dic = @{@"filename":@"a.jpg",@"data":data};
                    [imageInfos addObject:dic];
                }
                
                
                //显示上传进度
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                hud.label.text = @"正在上传图片。。。";

                
                
                  [BmobFile filesUploadBatchWithDataArray:imageInfos progressBlock:^(int index, float progress) {
                      
                      hud.label.text = [NSString stringWithFormat:@"%d/%ld",index+1,self.images.count];
                      hud.progress = progress;
                  } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
                      if (isSuccessful) {
                          
                          NSMutableArray *imagePaths = [NSMutableArray array];
                          for (BmobFile *file in array) {
                              [imagePaths addObject:file.url];
                              
                          }
                          
                          [obj setObject:imagePaths forKey:@"imagePaths"];
                          [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                              [hud hideAnimated:YES];
                              if (isSuccessful) {
                                  NSLog(@"图片上传完成！");
                                  [self.navigationController popViewControllerAnimated:YES];
                              }
                          }];
                          
                      }
                      
                  }];
                
            }
          
            
        }
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.images = [NSMutableArray array];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return self.images.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    
    cell.imageView.image = self.images[indexPath.row];
    
    return cell;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self.images addObject:image];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

@end
