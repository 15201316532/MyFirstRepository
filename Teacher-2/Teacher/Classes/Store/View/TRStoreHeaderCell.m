//
//  TRStoreHeaderCell.m
//  Teacher
//
//  Created by tarena on 16/9/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRStoreHeaderCell.h"

@implementation TRStoreHeaderCell
- (IBAction)sortTypeChangeAction:(UISegmentedControl *)sender {
   [self.delegate typeChangeAction:self.typeSC.selectedSegmentIndex andSortType:self.sortSC.selectedSegmentIndex];
}
- (IBAction)typeAction:(UISegmentedControl *)sender {
    //点击全部的话 排序功能失效
//    if (sender.selectedSegmentIndex==StoreTypeAll) {
//        self.sortSC.enabled = NO;
//    }else{
//        self.sortSC.enabled = YES;
//    }
    self.sortSC.enabled = sender.selectedSegmentIndex==StoreTypeAll?NO:YES;
   
    
    [self.delegate typeChangeAction:self.typeSC.selectedSegmentIndex andSortType:self.sortSC.selectedSegmentIndex];
}

- (void)awakeFromNib {
    // Initialization code
}

@end
