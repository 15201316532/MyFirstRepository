//
//  TRStoreTableViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import <SVPullToRefresh.h>
#import "TRStoreDetialViewController.h"
#import "TRStoreInfoViewController.h"
#import "TRStoreTableViewController.h"
#import "TRStoreCell.h"
#import "TRStoreHeaderCell.h"
@interface TRStoreTableViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,TRStoreHeaderCellDelegate>
@property (nonatomic, strong)NSMutableArray *arr;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, strong)TRStoreHeaderCell *cell;
@end

@implementation TRStoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加商品" style:UIBarButtonItemStyleDone target:self action:@selector(addStore)];
    
    //创建CollectionView代码
    UICollectionViewFlowLayout *fl = [UICollectionViewFlowLayout new];
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:fl];
    
    collectionView.backgroundColor = kRGBA(240, 240, 240, 1);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    //注册Cell
    [collectionView registerClass:[TRStoreCell class] forCellWithReuseIdentifier:@"cell"];
//   注册头部的Cell
    [collectionView registerNib:[UINib nibWithNibName:@"TRStoreHeaderCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"headerCell"];
    
    collectionView.backgroundColor = kRGBA(230, 230, 230, 1);
    collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    
    //添加上拉加载
    [collectionView addPullToRefreshWithActionHandler:^{
       
        [self loadInfoWithType:self.cell.typeSC.selectedSegmentIndex andSortType:self.cell.sortSC.selectedSegmentIndex];
    }];
    
    //上拉加载
    [collectionView addInfiniteScrollingWithActionHandler:^{
         [self loadMoreInfoWithType:self.cell.typeSC.selectedSegmentIndex andSortType:self.cell.sortSC.selectedSegmentIndex];
    }];
    
    
}


- (void)addStore {
    
    TRStoreInfoViewController *vc = [TRStoreInfoViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    if (self.arr.count==0) {
         [self.collectionView triggerPullToRefresh];
    }
    
   
}
//加载更多
- (void)loadMoreInfoWithType:(StoreType)storeType andSortType:(SortType)sortType{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Store"];
    
    if (storeType==StoreTypeMoney) {//判断如果是金币
        //查询金币大于0
        [bq whereKey:@"money" greaterThan:@(0)];
        
        
        
        if (sortType==SortTypeA) {//升序
            [bq orderByAscending:@"money"];
        }else{
            [bq orderByDescending:@"money"];
        }
        
    }else if (storeType == StoreTypeScore){//积分
        //查询积分大于0
        [bq whereKey:@"score" greaterThan:@(0)];
        if (sortType==SortTypeA) {//升序
            [bq orderByAscending:@"score"];
        }else{
            [bq orderByDescending:@"score"];
        }
        
    }
    //跳过已有的个数
    bq.skip = self.arr.count;
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self.arr addObjectsFromArray:array];
        [self.collectionView reloadData];
        [self.collectionView.infiniteScrollingView stopAnimating];
    }];
    
}

- (void)loadInfoWithType:(StoreType)storeType andSortType:(SortType)sortType{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Store"];
    
    if (storeType==StoreTypeMoney) {//判断如果是金币
        //查询金币大于0
        [bq whereKey:@"money" greaterThan:@(0)];
        
        
        
        if (sortType==SortTypeA) {//升序
            [bq orderByAscending:@"money"];
        }else{
            [bq orderByDescending:@"money"];
        }

    }else if (storeType == StoreTypeScore){//积分
        //查询积分大于0
        [bq whereKey:@"score" greaterThan:@(0)];
        if (sortType==SortTypeA) {//升序
            [bq orderByAscending:@"score"];
        }else{
            [bq orderByDescending:@"score"];
        }

    }
  
    
    
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        self.arr = [array mutableCopy];
        [self.collectionView reloadData];
         [self.collectionView.pullToRefreshView stopAnimating];
    }];
    
}

#pragma mark UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section==0) {
        return 1;
    }
    
    return self.arr.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        TRStoreHeaderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        cell.delegate = self;
        self.cell = cell;
        return cell;
    }
    
    
    TRStoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.storeObj = self.arr[indexPath.row];
    return cell;
    
    
}

//控制显示大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return CGSizeMake(kScreenW, 40);
    }
    float size = (kScreenW-3*kMargin)/2;
    return CGSizeMake(size, size*.8);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(kMargin, kMargin, 0, kMargin);
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return kMargin;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BmobObject *obj = self.arr[indexPath.row];
    TRStoreDetialViewController *vc = [TRStoreDetialViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    vc.obj = obj;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}
#pragma mark 头里面类型和排序改变的协议方法
-(void)typeChangeAction:(StoreType)storeType andSortType:(SortType)sortType{
    
    [self loadInfoWithType:storeType andSortType:sortType];
}


@end
