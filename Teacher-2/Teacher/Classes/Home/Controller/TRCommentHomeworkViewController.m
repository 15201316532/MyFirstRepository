//
//  TRCommentHomeworkViewController.m
//  Teacher
//
//  Created by tarena on 16/9/20.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRDetailViewController.h"
#import "TRCommentHomeworkViewController.h"
#import <SVPullToRefresh.h>
#import "TRITObject.h"
#import "LYHomeCell.h"
@interface TRCommentHomeworkViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *homeworks;
@end

@implementation TRCommentHomeworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"待审核列表";
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
 
    
    //要在下拉刷新事件之前添加 让内容往下显示
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    [tableView registerNib:[UINib nibWithNibName:@"LYHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    //添加刷新事件
    [tableView addPullToRefreshWithActionHandler:^{
        
        [self loadHomeworks];
        
    }];
    
    
    
    //触发下拉刷新事件
    [tableView triggerPullToRefresh];
    
    //添加 上拉加载事件
    [tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreHomeworks];
    }];
    
}
- (void)loadMoreHomeworks{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
    
    //设置请求条数
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    //设置查询 作业类型
    [query whereKey:@"isHomework" equalTo:@(YES)];
    //未点评
    [query whereKey:@"isCommented" notEqualTo:@(YES)];
    
    //跳过已有数据的个数
    query.skip = self.homeworks.count;
    //包含user对象
    [query includeKey:@"user"];
 
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.homeworks addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.infiniteScrollingView stopAnimating];
    }];

}
- (void)loadHomeworks{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
    
    //设置请求条数
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    //设置查询 作业类型
 
    [query whereKey:@"isHomework" equalTo:@(YES)];
    //未点评
    [query whereKey:@"isCommented" notEqualTo:@(YES)];
    
    //包含user对象
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        //请求到数据后 初始化数组
        self.homeworks = [NSMutableArray array];
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.homeworks addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];

}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
 
    
    
    return self.homeworks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    
    
    cell.itObj = self.homeworks[indexPath.row];
    
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //计算每行的高度
    TRITObject *itObj = self.homeworks[indexPath.row];
    
    
    
    return itObj.contentHeight + 64;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    TRDetailViewController *vc = [TRDetailViewController new];
    
    vc.itObj = self.homeworks[indexPath.row];
    
    [vc.itObj addShowCount];
    //隐藏tabbar
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}

 
@end
