//
//  NSString+TRPassword.m
//  Student
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "NSString+TRPassword.h"

@implementation NSString (TRPassword)
- (BOOL)checkPassword
{
    NSString *pattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    
    BOOL isMatch = [pred evaluateWithObject:self];
    return isMatch;
    
}
@end
