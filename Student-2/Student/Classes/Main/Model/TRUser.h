//
//  TRUser.h
//  Student
//
//  Created by tarena on 16/9/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BmobSDK/Bmob.h>
@interface TRUser : NSObject

+(TRUser *)currentUser;
@property (nonatomic, strong)BmobObject *bmobUser;
@property (nonatomic, copy)NSString *nick;
@property (nonatomic, copy)NSString *username;
@property (nonatomic, copy)NSString *headPath;
@property (nonatomic, strong)NSArray *classes;
@property (nonatomic, strong)NSDate *createdAt;

-(void)logout;

@end
