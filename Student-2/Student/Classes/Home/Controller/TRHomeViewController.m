//
//  LYHomeViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//
#import "TRSendingViewController.h"
#import "AFNetworkReachabilityManager.h"
#import "TRDetailViewController.h"
#import "LYHomeCell.h"
#import "TRHomeViewController.h"
#import "AppDelegate.h"
#import "TRITObject.h"
#import "SVPullToRefresh.h"
@interface TRHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *itObjs;
@property (nonatomic, strong)AFNetworkReachabilityManager *manager;

@property (nonatomic, strong)UISegmentedControl *typeSC;
@property (nonatomic, strong)UIView *headerView;
@end

@implementation TRHomeViewController

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, LYSW, 40)];
        [_headerView addSubview:self.typeSC];
    }
    return _headerView;
}
-(UISegmentedControl *)typeSC{
    if (!_typeSC) {
        _typeSC = [[UISegmentedControl alloc]initWithItems:@[@"全部",@"消息",@"作业"]];
        _typeSC.tintColor = MainColor;
        _typeSC.frame = CGRectMake(0, 0, LYSW/2, 25);
        _typeSC.center = CGPointMake(LYSW/2, 20);
        _typeSC.selectedSegmentIndex = 0;
        [_typeSC addTarget:self action:@selector(typeChangeAction) forControlEvents:UIControlEventValueChanged];
    }
    
    return _typeSC;
}
-(void)typeChangeAction{
    
    [self.tableView triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
 
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    self.tableView = tableView;
    tableView.tableHeaderView = self.headerView;
    
    //要在下拉刷新事件之前添加 让内容往下显示
    tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    
    [tableView registerNib:[UINib nibWithNibName:@"LYHomeCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    //添加刷新事件
    [tableView addPullToRefreshWithActionHandler:^{
       
        [self loadObjs];
        
    }];
    

    
    //触发下拉刷新事件
    [tableView triggerPullToRefresh];
    
    //添加 上拉加载事件
    [tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreObjs];
    }];
    
    
    
  
    
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"排行榜" style:UIBarButtonItemStyleDone target:self action:@selector(homeworkAction)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"新建消息" style:UIBarButtonItemStyleDone target:self action:@selector(sendAction)];
    
    [self checkingNetwork];
    
}

-(void)checkingNetwork{
    //检测网络状态
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    self.manager = manager;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch ((int)status) {
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无网络");
                //没网并且没有数据的时候才需要加装本地数据
                if (self.itObjs.count==0) {
                    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/itObjs.arch"];
                    NSData *data = [NSData dataWithContentsOfFile:path];
                    //如果有数据
                    if (data) {
                        self.itObjs = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                        
                        [self.tableView reloadData];
                        
                        
                    }
                    
                    
                    
                    
                }
                
                
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"移动网络");
                //检测有网后 加载数据
                if (self.itObjs.count==0) {
                    [self.tableView triggerPullToRefresh];
                }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                //检测有网后 加载数据
                NSLog(@"wifi网络");
                
                if (self.itObjs.count==0) {
                    [self.tableView triggerPullToRefresh];
                }
                
                break;
        }
        
        
        
    }];
    //开始监测
    [manager startMonitoring];
}

- (void)sendAction {
    
    TRSendingViewController *vc = [TRSendingViewController new];
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:vc] animated:YES completion:nil];
    
    
}

- (void)homeworkAction {
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //实现浏览量功能 返回页面时刷新选中的某一行
    //判断是否有选中
    if (self.tableView.indexPathForSelectedRow) {
        
        [self.tableView reloadRowsAtIndexPaths:@[self.tableView.indexPathForSelectedRow] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
    }
}

-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
 
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //设置请求条数
    query.limit = 10;
    [query orderByDescending:@"createdAt"];
    //包含user对象
    [query includeKey:@"user"];
    //设置查询类型
    switch (self.typeSC.selectedSegmentIndex) {
        case 1://消息
            [query whereKey:@"isHomework" notEqualTo:@(YES)];
            break;
            
        case 2://作业
            [query whereKey:@"isHomework" equalTo:@(YES)];
            break;
    }
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {

        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
        
        [self.tableView reloadData];
        
        //结束动画
        [self.tableView.infiniteScrollingView stopAnimating];
        
    }];

}
-(void)loadObjs{
   
   //判断是否有网络 无网络就不需要刷新了
    NSLog(@"%ld",self.manager.networkReachabilityStatus);
    if (self.manager.networkReachabilityStatus==AFNetworkReachabilityStatusNotReachable) {
        [self.tableView.pullToRefreshView stopAnimating];
        
        return;
    }
    

    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
   
    //设置请求条数
    query.limit = 10;
    
    [query orderByDescending:@"createdAt"];
    //设置查询类型
    switch (self.typeSC.selectedSegmentIndex) {
        case 1://消息
            [query whereKey:@"isHomework" notEqualTo:@(YES)];
            break;
            
        case 2://作业
             [query whereKey:@"isHomework" equalTo:@(YES)];
            break;
    }
    
    
    //包含user对象
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
      
       
        //请求到数据后 初始化数组
        self.itObjs = [NSMutableArray array];
        
        for (BmobObject *bObj in array) {
            TRITObject *itObj = [[TRITObject alloc]initWithBmobObject:bObj];
            [self.itObjs addObject:itObj];
        }
      
        [self.tableView reloadData];
      
        //结束动画
        [self.tableView.pullToRefreshView stopAnimating];
        
    }];
    
    
}
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
//    if (self.itObjs.count>0) {
//        //把数据保存
//        NSData *itObjsData = [NSKeyedArchiver archivedDataWithRootObject:self.itObjs];
//        
//        NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/itObjs.arch"];
//        [itObjsData writeToFile:path atomically:YES];
//    }
    
    
    return self.itObjs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LYHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
  
    
    cell.itObj = self.itObjs[indexPath.row];
  
    
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //计算每行的高度
    TRITObject *itObj = self.itObjs[indexPath.row];
    
    
    
    return itObj.contentHeight + 60 + 5;//5为分割线宽度
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRDetailViewController *vc = [TRDetailViewController new];
    
    vc.itObj = self.itObjs[indexPath.row];
    
    [vc.itObj addShowCount];
    //隐藏tabbar
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
