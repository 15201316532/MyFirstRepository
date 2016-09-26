//
//  TRStoreCell.m
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRStoreCell.h"

@implementation TRStoreCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-40)];
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.imageView.bounds.size.height, frame.size.width, 20)];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.nameLabel.frame), frame.size.width/2, 20)];
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.scoreLabel.frame), CGRectGetMaxY(self.nameLabel.frame), frame.size.width/2, 20)];
        
        self.scoreLabel.font = self.moneyLabel.font = [UIFont systemFontOfSize:12];
        self.scoreLabel.textColor = self.moneyLabel.textColor = MainColor;
        
        [self addSubview:self.imageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.scoreLabel];
        [self addSubview:self.moneyLabel];

    }
    return self;
}

-(void)setStoreObj:(BmobObject *)storeObj{
    _storeObj = storeObj;
    
    NSArray *imagePaths = [storeObj objectForKey:@"imagePaths"];
    //判断是否有图片
    if (imagePaths.count>0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePaths[0]] placeholderImage:LoadingImage];
    }else{
        self.imageView.image = LoadingImage;
    }
    
    self.nameLabel.text = [storeObj objectForKey:@"name"];
    self.scoreLabel.text = [NSString stringWithFormat:@"积分：%@",@([[storeObj objectForKey:@"score"] intValue])];
    self.moneyLabel.text = [NSString stringWithFormat:@"金币：%@",@([[storeObj objectForKey:@"money"] intValue])];
    
    
    
}

@end
