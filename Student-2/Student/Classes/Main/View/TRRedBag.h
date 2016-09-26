//
//  TRRedBag.h
//  Student
//
//  Created by tarena on 16/9/23.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRRedBag : UIButton
@property (nonatomic, strong)BmobObject *obj;
@property (nonatomic, strong)NSTimer *timer;
@property (nonatomic)float offsetX;
@property (nonatomic)float offsetY;
@property (nonatomic)int money;
@property (nonatomic)int score;

@end
