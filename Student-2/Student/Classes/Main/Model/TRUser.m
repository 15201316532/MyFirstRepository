//
//  TRUser.m
//  Student
//
//  Created by tarena on 16/9/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRUser.h"
static TRUser *_user;
@implementation TRUser
+(TRUser *)currentUser{
    
    if (!_user) {
        
        _user = [[TRUser alloc]init];
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        NSString *username = [ud objectForKey:@"username"];
        
        _user.username = username;
        _user.createdAt = [ud objectForKey:@"createdAt"];
        
        _user.headPath = [ud objectForKey:@"headPath"];
        _user.classes = [ud objectForKey:@"classes"];
        _user.nick = [ud objectForKey:@"nick"];
        
        BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
        
        [bq whereKey:@"username" equalTo:username];
        [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            if (array.count>0) {
                
                _user.bmobUser = [array firstObject];
                _user.nick = [_user.bmobUser objectForKey:@"nick"];
                _user.headPath = [_user.bmobUser objectForKey:@"headPath"];
                _user.username = [_user.bmobUser objectForKey:@"username"];
                _user.classes = [_user.bmobUser objectForKey:@"classes"];
                
                 _user.createdAt = _user.bmobUser.createdAt;
                //保存数据
                [ud setObject:_user.nick forKey:@"nick"];
                [ud setObject:_user.classes forKey:@"classes"];
                [ud setObject:_user.headPath forKey:@"headPath"];
                [ud setObject:_user.createdAt  forKey:@"createdAt"];
                [ud synchronize];
            }else{
                NSLog(@"账号异常");
            }
        }];
        
        
        
    }
    
    return _user;
}

-(void)logout{
    
    _user = nil;
}
@end
