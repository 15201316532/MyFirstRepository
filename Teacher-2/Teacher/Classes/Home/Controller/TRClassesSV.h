//
//  TRClassesSV.h
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRClassesSV : UIScrollView
@property (nonatomic, strong)NSArray *classes;
@property (nonatomic, strong)NSArray *selectedClasses;
@property (nonatomic, strong)NSMutableArray *classesBtns;
@property (nonatomic, strong)UIButton *allbtn;
@end
