//
//  TRStoreCell.h
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRStoreCell : UICollectionViewCell
@property (nonatomic,strong)UIImageView *imageView;
@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *scoreLabel;
@property (nonatomic, strong)UILabel *moneyLabel;
@property (nonatomic, strong)BmobObject *storeObj;
@end
