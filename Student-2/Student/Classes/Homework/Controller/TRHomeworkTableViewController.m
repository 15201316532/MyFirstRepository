//
//  HomeworkTableViewController.m
//  Student
//
//  Created by tarena on 16/9/18.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRHomeworkDetailViewController.h"
#import "TRITObject.h"
#import "TRHomeworkTableViewController.h"
#import "TRHomeworkCell.h"
#import <SVPullToRefresh.h>
@interface TRHomeworkTableViewController ()
@property (nonatomic, strong)NSMutableArray *homeworks;
@property (nonatomic, strong)NSMutableArray *finishedHomeworks;

@end

@implementation TRHomeworkTableViewController
 - (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.tableView registerNib:[UINib nibWithNibName:@"TRHomeworkCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    
     //要在下拉刷新事件之前添加 让内容往下显示
     self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    __weak typeof(self) weakSelf = self;
     [self.tableView addPullToRefreshWithActionHandler:^{
         [weakSelf loadHomeworks];
         [self loadFinishedHomeworks];
     }];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView triggerPullToRefresh];
    
}
-(void)loadFinishedHomeworks{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Homework"];
    //查询条件 跟自己班级有关的作业
    [bq whereKey:@"classes" containedIn:[TRUser currentUser].classes];
    //查询用户注册日期以后的作业
    [bq whereKey:@"createdAt" greaterThanOrEqualTo:[TRUser currentUser].bmobUser.createdAt];
    
    [bq orderByDescending:@"createdAt"];
    //查询完成学生数组中出现自己的作业
    [bq whereKey:@"finishedStudents" containedIn:@[[TRUser currentUser].username]];
    
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
      
        self.finishedHomeworks = [NSMutableArray array];
        for (BmobObject *obj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:obj];
            [self.finishedHomeworks addObject:itObj];
            
        }
        [self.tableView reloadData];
         [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
    
}


-(void)loadHomeworks{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Homework"];
    //查询条件 跟自己班级有关的作业
    [bq whereKey:@"classes" containedIn:[TRUser currentUser].classes];
    
    //查询用户注册日期以后的作业
    [bq whereKey:@"createdAt" greaterThanOrEqualTo:[TRUser currentUser].bmobUser.createdAt];
    
    //查询完成学生数组中没有出现自己的作业  查询的是未完成的作业
     [bq whereKey:@"finishedStudents" notContainedIn:@[[TRUser currentUser].username]];
//    时间倒序
    [bq orderByDescending:@"createdAt"];

    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
         self.homeworks = [NSMutableArray array];
        for (BmobObject *obj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:obj];
            [self.homeworks addObject:itObj];
            
        }
 
        

        [self.tableView reloadData];
        
        [self.tableView.pullToRefreshView stopAnimating];
    }];
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {//新作业
        
        return self.homeworks.count;
    }
    return self.finishedHomeworks.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRHomeworkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
      
    if (indexPath.section==0) {
        cell.itObj = self.homeworks[indexPath.row];
        cell.objView.titleTV.textColor = MainColor;
    }else{
        cell.itObj = self.finishedHomeworks[indexPath.row];
        cell.objView.titleTV.textColor = [UIColor blackColor];
    }
    
   
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRHomeworkDetailViewController *vc = [TRHomeworkDetailViewController new];
    
 
    if (indexPath.section ==0) {
        vc.itObj = self.homeworks[indexPath.row];
    }else{
        vc.itObj = self.finishedHomeworks[indexPath.row];
        vc.isFinished = YES;
    }

    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
 
    
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    
    if (section==0) {
        return @"未完成";
    }else return @"历史作业";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //计算每行的高度
    TRITObject *itObj = nil;
    if (indexPath.section == 0) {
        itObj = self.homeworks[indexPath.row];;
    }else{
         itObj = self.finishedHomeworks[indexPath.row];;
    }
    
    
    
    return itObj.contentHeight + 20+kMargin;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
