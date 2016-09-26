//
//  TRClassesSV.m
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRClassesSV.h"

@implementation TRClassesSV
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedClasses = [NSMutableArray array];
        self.classesBtns = [NSMutableArray array];
    }
    return self;
}
//每次获取时计算当前选中的班级有哪些
-(NSArray *)selectedClasses{
    
    if (self.allbtn.selected) {
        return self.classes;
    }
    NSMutableArray *selectedArr = [NSMutableArray array];
    for (UIButton *classBtn in self.classesBtns) {
        if (classBtn.selected) {
            NSString *className = [classBtn titleForState:UIControlStateNormal];
            [selectedArr addObject:className];
        }
    }
    
    return selectedArr;
}

-(void)setClasses:(NSArray *)classes{
    _classes = classes;
    //添加显示全部按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(0, 10, 90, 20);
    [btn setTintColor:MainColor];
    [btn setTitle:@"全部学生" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickedAllClassAction:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = MainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.selected = YES;
    [self addSubview:btn];
    self.allbtn = btn;
    
    
    for (int i=0; i<classes.count; i++) {
        
        NSString *className = classes[i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(100+i*100, 10, 90, 20);
        [btn setTitle:className forState:UIControlStateNormal];
        [btn setTintColor:MainColor];
        [btn addTarget:self action:@selector(clickedClassAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        [self.classesBtns addObject:btn];
    }
    self.contentSize = CGSizeMake(100*(classes.count+1), 0);
}

//全部学生按钮
-(void)clickedAllClassAction:(UIButton *)btn{
    
 
    btn.backgroundColor = MainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.selected = YES;
    
    //遍历所有的班级按钮 清除选中效果
    for (UIButton *classBtn in self.classesBtns) {
        classBtn.backgroundColor = [UIColor whiteColor];
        [classBtn setTitleColor:MainColor forState:UIControlStateNormal];
        classBtn.selected = NO;
    }
    
    
}
-(void)clickedClassAction:(UIButton *)btn{
    //全部学生的按钮 设置不选中状态
    self.allbtn.backgroundColor = [UIColor clearColor];
    [self.allbtn setTitleColor:MainColor forState:UIControlStateNormal];
    self.allbtn.selected = NO;
    
    
    //让选中按钮效果不一样
    if (btn.selected) {//如果已经选中
        btn.backgroundColor = [UIColor clearColor];
        [btn setTitleColor:MainColor forState:UIControlStateNormal];
        btn.selected = NO;
        
    }else{
        btn.backgroundColor = MainColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.selected = YES;
        
    }
    
    
    
    
    
    
    
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
