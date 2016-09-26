//
//  TRStoreHeaderCell.h
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//
typedef NS_ENUM(NSUInteger, StoreType) {
    StoreTypeAll,
    StoreTypeScore,
    StoreTypeMoney,
};
typedef NS_ENUM(NSUInteger, SortType) {
    SortTypeA,
    SortTypeD
};
@protocol TRStoreHeaderCellDelegate <NSObject>

-(void)typeChangeAction:(StoreType)storeType andSortType:(SortType)sortType;
 

@end
#import <UIKit/UIKit.h>

@interface TRStoreHeaderCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortSC;
@property (weak, nonatomic) IBOutlet UISegmentedControl *typeSC;

@property (nonatomic, weak)id<TRStoreHeaderCellDelegate> delegate;

@end
