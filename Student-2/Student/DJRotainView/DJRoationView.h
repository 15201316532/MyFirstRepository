//
//  DJRoationView.h
//  DJRotainVIew
//
//  Created by Jason on 28/12/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DJRoationView : UIView
/**
 *  速度最高20
 */
@property (nonatomic,assign) int speed;
- (void)rotatingDidFinishBlock:(void(^)(NSInteger index,CGFloat score))block;
@end
