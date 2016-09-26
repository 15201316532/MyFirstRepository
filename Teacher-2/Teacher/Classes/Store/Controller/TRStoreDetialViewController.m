//
//  TRStoreDetialViewController.m
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "PhotoBroswerVC.h"
#import "TRStoreDetialViewController.h"

@interface TRStoreDetialViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *imagesSV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong)NSArray *imagePaths;
@end

@implementation TRStoreDetialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"商品详情";
    self.nameLabel.text = [self.obj objectForKey:@"name"];
    NSArray *imagePaths = [self.obj objectForKey:@"imagePaths"];
    self.imagePaths = imagePaths;
    for (int i=0; i<imagePaths.count; i++) {
        UIImageView *iv = [[UIImageView alloc]initWithFrame:CGRectMake(0, (i*self.imagesSV.bounds.size.height+kMargin), self.imagesSV.bounds.size.width, self.imagesSV.bounds.size.height)];
        NSString *imagePath = imagePaths[i];
        [iv sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:LoadingImage];
        iv.userInteractionEnabled = YES;
        iv.tag = i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [iv addGestureRecognizer:tap];
        [self.imagesSV addSubview:iv];
    }
    
    self.imagesSV.contentSize = CGSizeMake(0, imagePaths.count*(self.imagesSV.bounds.size.height+kMargin));
    self.imagesSV.showsHorizontalScrollIndicator = NO;
    self.imagesSV.showsVerticalScrollIndicator = NO;
}
//*****************************
-(void)tapAction:(UITapGestureRecognizer *)tap{
    
    UIImageView *iv = (UIImageView *)tap.view;
    //[UIApplication sharedApplication].keyWindow.rootViewController 得到的是当前程序window的根页面
    [PhotoBroswerVC show:[UIApplication sharedApplication].keyWindow.rootViewController type:PhotoBroswerVCTypeZoom index:iv.tag photoModelBlock:^NSArray *{
        
        NSMutableArray *modelsM = [NSMutableArray arrayWithCapacity:self.imagePaths.count];
        
        
        for (NSUInteger i = 0; i< self.imagePaths.count; i++) {
            PhotoModel *pbModel=[[PhotoModel alloc] init];
            pbModel.mid = i + 1;
            
            NSString *path = self.imagePaths[i];
            
            //设置查看大图的时候的图片地址
            pbModel.image_HD_U = path;
            
            //源图片的frame
            UIImageView *imageV =(UIImageView *) self.imagesSV.subviews[i];
            pbModel.sourceImageView = imageV;
            [modelsM addObject:pbModel];
        }
        return modelsM;
        
    }];
    
}
//************************

@end
