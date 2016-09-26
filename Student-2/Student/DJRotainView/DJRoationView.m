//
//  DJRoationView.m
//  DJRotainVIew
//
//  Created by Jason on 28/12/15.
//  Copyright © 2015年 Jason. All rights reserved.
//

#import "DJRoationView.h"
#import <AudioToolbox/AudioToolbox.h>
#import "DJRoundLayout.h"

@interface ScoreLabel : UILabel;

@end
@implementation ScoreLabel
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.textColor = [UIColor whiteColor];
        self.font = [UIFont boldSystemFontOfSize:14];
        self.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}
@end


@interface DJCollectViewCell : UICollectionViewCell
@property (nonatomic,strong)ScoreLabel *label;
@end

@implementation DJCollectViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        self.label = [[ScoreLabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:self.label];
//        self.label.center = self.contentView.center;
        
    }
    return self;
}


- (void)setTitle:(NSString *)str IndexPath:(NSIndexPath *)indexPath
{
    self.label.text = str;
    if (indexPath) {
        CGFloat angle = (-M_PI/8)+indexPath.row*(M_PI/4);
        self.transform = CGAffineTransformMakeRotation(angle);
    }
}
@end



typedef enum : NSUInteger {
    none,
    increasing,//递增
    diminishing,//递减
} VariableSpeedState;

typedef void(^RotationBlock)(NSInteger,CGFloat);
@interface DJRoationView () <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    SystemSoundID soundID;
    CGFloat al;//角度
    CFTimeInterval duration;//时间
    NSInteger titleCount;
    int roationCount;//旋转总次数
    int hasRoationCount;//已转的次数
    int lastIndex;//最后一次动画的index
}
@property (nonatomic,strong)UIImageView *turnView;
@property (nonatomic,strong)UIButton *button;
@property (nonatomic,assign)VariableSpeedState variableState;//变速方式
@property (nonatomic,copy)RotationBlock block;
@property (nonatomic,strong)NSMutableArray *titles;
@property (nonatomic,strong)UICollectionView *collect;
@end
@implementation DJRoationView
- (NSMutableArray *)titles
{
    if (!_titles) {
        _titles = @[@"1",@"2",@"3",@"4",@"2",@"3",@"4",@"5"].mutableCopy;
    }
    return _titles;
}
- (void)rotatingDidFinishBlock:(void (^)(NSInteger, CGFloat))block
{
    if (block) {
        self.block = block;
    }
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        [self initLayOutWithFrame:frame];
    }
    return self;
}

- (void)initLayOutWithFrame:(CGRect)frame
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"iPodClick" withExtension:@"aiff"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    self.speed = 20;
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    image.image = [UIImage imageNamed:@"icon-1"];
    [self addSubview:image];
    
    DJRoundLayout * layout = [[DJRoundLayout alloc]init];
    self.collect  = [[UICollectionView alloc]initWithFrame:CGRectMake(-8, -8, frame.size.width+16, frame.size.height+16) collectionViewLayout:layout];
    _collect.delegate=self;
    _collect.dataSource=self;
    _collect.backgroundColor = [UIColor clearColor];
    [_collect registerClass:[DJCollectViewCell class] forCellWithReuseIdentifier:@"cellid"];
    [self addSubview:_collect];
    
    
    UIImageView *image2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width*3/4, frame.size.height*3/4)];
    image2.image = [UIImage imageNamed:@"icon-2"];
    image2.center = image.center;
    [self addSubview:image2];
    self.turnView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.turnView.image = [UIImage imageNamed:@"icon-3"];
    [self addSubview:self.turnView];
    self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button setImage:[UIImage imageNamed:@"icon-4"] forState:UIControlStateNormal];
    self.button.frame = CGRectMake(0, 0, frame.size.width/2, frame.size.height/2);
    self.button.center = image.center;
    [self addSubview:self.button];
    [self.button addTarget:self action:@selector(startRotain:) forControlEvents:UIControlEventTouchUpInside];
    titleCount = self.titles.count;
    duration = 0.2f;
    al = 0;
}
- (void)setSpeed:(int)speed
{
    _speed = speed>20?20:speed<1?1:speed;
    NSLog(@"%d",_speed);
}

#pragma -mark CollectViewDelegate
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.titles.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DJCollectViewCell * cell  = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    [cell setTitle:[self.titles objectAtIndex:indexPath.row] IndexPath:indexPath];
    /**
     *  不传indexPath 可以保持分数的位置；
     */
//    [cell setTitle:[self.titles objectAtIndex:indexPath.row] IndexPath:nil];
    return cell;
}

- (void)startRotain:(UIButton *)button
{
    [self reSet];
    self.button.enabled = NO;
    roationCount = arc4random()%145+64;//现在是8个分数，为了概率平衡，随机数范围应为8的倍数
    hasRoationCount = 0;
    duration = 0.2f;
    self.variableState = increasing;
//    roationCount = 1;
    [self startAnimatWithView:self.turnView];
}
- (void)startAnimatWithView:(UIView *)view
{
    CABasicAnimation *caAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    caAnimation.removedOnCompletion = NO;
    caAnimation.fillMode = kCAFillModeForwards;
    caAnimation.fromValue = @(al);
    CGFloat flot = al + M_PI/(titleCount/2);
    caAnimation.toValue = @(flot);
    caAnimation.duration = duration;
    caAnimation.repeatCount = 1;
    caAnimation.delegate = self;
//    caAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [view.layer addAnimation:caAnimation forKey:@"anim"];
    al = [caAnimation.toValue floatValue];
    
}
- (void)animationDidStart:(CAAnimation *)anim
{

    hasRoationCount += 1;

}
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    AudioServicesPlaySystemSound(soundID);
    if (hasRoationCount>=roationCount) {
        self.button.enabled = YES;
        int curIndex = (roationCount%titleCount+lastIndex)%titleCount;
        lastIndex = curIndex;
        
        for (int i = 0; i<self.titles.count; i++) {
            DJCollectViewCell *cell = (DJCollectViewCell *)[self.collect cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
            if (i==curIndex) {
                cell.label.textColor = [UIColor redColor];
                cell.label.font = [UIFont boldSystemFontOfSize:20];
            }else{
                cell.label.textColor = [UIColor whiteColor];
                cell.label.font = [UIFont boldSystemFontOfSize:14];
            }
        }
        
        if (self.block) {
            CGFloat score = [[self.titles objectAtIndex:curIndex] floatValue];
            self.block(curIndex,score);
        }
        return;
    }
    if (hasRoationCount>=self.speed&&hasRoationCount<=roationCount-self.speed) {
        [self startAnimatWithView:self.turnView];
        return;
    }
    if (hasRoationCount<self.speed) {
        self.variableState = increasing;
    }else if (hasRoationCount>roationCount-self.speed){
        self.variableState = diminishing;
    }
    if (self.variableState==increasing) {
        duration-=0.01;
    }else{
        duration+=0.01;
    }
    
    
    if (duration<0.01) {
        duration=0.01;
    }
//     NSLog(@"%f",duration);
    
    [self startAnimatWithView:self.turnView];
}

/**
 *  重置颜色
 */
- (void)reSet
{
    for (int i = 0; i<self.titles.count; i++) {
        DJCollectViewCell *cell = (DJCollectViewCell *)[self.collect cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        cell.label.textColor = [UIColor whiteColor];
        cell.label.font = [UIFont boldSystemFontOfSize:14];
    }
}

@end
