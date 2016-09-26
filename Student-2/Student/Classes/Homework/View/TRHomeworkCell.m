//
//  TRHomeworkCell.m
//  Student
//
//  Created by tarena on 16/9/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRHomeworkCell.h"

@implementation TRHomeworkCell

- (void)awakeFromNib {
    //创建itobjView
    self.objView = [[TRITObjectView alloc]initWithFrame:CGRectMake(0, 20, LYSW, 0)];
    
    [self addSubview:self.objView];
}

-(void)setItObj:(TRITObject *)itObj{
    _itObj = itObj;
 
    self.audioBtn.hidden = itObj.voicePath? NO:YES;
    
    NSArray *students = [itObj.bObj objectForKey:@"finishedStudents"];
    self.finishCountLabel.text = @(students.count).stringValue;
    
    self.timeLabel.text = [itObj createdTime];
    
    self.objView.itObj = itObj;
    
    self.objView.height = self.objView.titleTV.bounds.size.height+self.objView.detailTV.bounds.size.height+itObj.imagesHeight; 
}


@end
