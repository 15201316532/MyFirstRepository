//
//  ZCRankingCell.h
//  Student
//
//  Created by tarena on 16/9/22.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, RANKTYPE) {
    RANKTYPESCORE,
    RANKTYPECOIN,
};
@interface TRRankingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *medalIV;
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UIImageView *crownIV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (nonatomic, strong) BmobObject *user;
@property (nonatomic) RANKTYPE rankType;
@end
