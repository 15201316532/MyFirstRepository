//
//  TRITObject.h
//  ITSNS
//
//  Created by tarena on 16/8/26.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TRITObject : NSObject<NSCoding>
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *detail;
@property (nonatomic, strong)BmobObject *user;
@property (nonatomic, copy)NSString *userNick;
@property (nonatomic, copy)NSString *userHeadPath;
@property (nonatomic, copy)NSString *voicePath;
@property (nonatomic, strong)NSArray *imagePaths;
@property (nonatomic, strong)NSDate *date;
@property (nonatomic, strong)BmobGeoPoint *location;
@property (nonatomic)float contentHeight;
@property (nonatomic)float imagesHeight;
@property (nonatomic)int showCount;
@property (nonatomic)int commentCount;

@property (nonatomic, strong)BmobObject *bObj;
-(instancetype)initWithBmobObject:(BmobObject *)bObj;

-(NSString *)createdTime;

-(void)addShowCount;
-(void)addCommentCount;
@end
