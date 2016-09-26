//
//  ZCRankingViewController.m
//  Student
//
//  Created by tarena on 16/9/22.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRUserInfoViewController.h"
#import "TRRankingViewController.h"
#import "TRRankingCell.h"

@interface TRRankingViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UISegmentedControl *classesSC;
@property (weak, nonatomic) IBOutlet UITableView *scoreRankTableView;
@property (weak, nonatomic) IBOutlet UITableView *coinRankTableView;
@property (nonatomic, strong) NSArray *scoreRankArr;
@property (nonatomic, strong) NSArray *coinRankArr;
@property (nonatomic, strong) NSArray *classes;

@property (nonatomic, strong) TRRankingCell *scoreCell;
@property (nonatomic, strong) TRRankingCell *coinCell;
@end

@implementation TRRankingViewController

-(TRRankingCell *)scoreCell{
    if (!_scoreCell) {
        
        _scoreCell = [[[NSBundle mainBundle]loadNibNamed:@"TRRankingCell" owner:self options:nil]firstObject];
        
        _scoreCell.frame = CGRectMake(kMargin, CGRectGetMaxY(self.scoreRankTableView.frame)+kMargin, self.scoreRankTableView.width, 58);
        
        [self.view addSubview:_scoreCell];
  
    }
    
    return _scoreCell;
}

-(TRRankingCell *)coinCell{
    if (!_coinCell) {
        _coinCell = [[[NSBundle mainBundle]loadNibNamed:@"TRRankingCell" owner:self options:nil]firstObject];
        
        _coinCell.frame = CGRectMake(self.coinRankTableView.left, CGRectGetMaxY(self.coinRankTableView.frame)+kMargin, self.coinRankTableView.width, 58);
        
        [self.view addSubview:_coinCell];
      
    }
    
    return _coinCell;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadCoinRankingData];
    [self loadScoreRankingData];
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.scoreRankTableView registerNib:[UINib nibWithNibName:@"TRRankingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
    [self.coinRankTableView registerNib:[UINib nibWithNibName:@"TRRankingCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    
        [self addCurrentUserClassesWithUser:[TRUser currentUser].bmobUser];
 
    
   
}

-(void)loadScoreRankingData{
    BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
 
    [bq orderByDescending:@"score"];
    switch (self.classesSC.selectedSegmentIndex) {
        case 0:
            ;
            break;
            
        default:
            [bq whereKey:@"classes" containsAll:@[self.classes[self.classesSC.selectedSegmentIndex-1]]];
            break;
    }
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error){
            self.scoreRankArr = array;
            [self.scoreRankTableView reloadData];
            
            [self updateScoreCell];
            
        }else{
            NSLog(@"获取积分数据出错%@", error);
        }
    }];
}

-(void)loadCoinRankingData{
    BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
    //倒序
    [bq orderByDescending:@"money"];
    switch (self.classesSC.selectedSegmentIndex) {
        case 0:
            ;
            break;
            
        default:
            //只查询用户选中班级的信息
            [bq whereKey:@"classes" containsAll:@[self.classes[self.classesSC.selectedSegmentIndex-1]]];
            break;
    }
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error){
            self.coinRankArr = array;
            [self.coinRankTableView reloadData];
            
            [self updateCoinCell];
        }else{
            NSLog(@"获取金币数据出错%@", error);
        }
    }];
}
-(void)updateScoreCell{
    self.scoreCell.user = [TRUser currentUser].bmobUser;
    
    NSInteger index;
    
    for (NSInteger i = 0; i < self.scoreRankArr.count; i++) {
        BmobObject *aUser = self.scoreRankArr[i];
        if ([[aUser objectForKey:@"username"] isEqualToString:[TRUser currentUser].username]){
            index = i;
            break;
        }
    }
    _scoreCell.rankType = RANKTYPESCORE;
    _scoreCell.rankLabel.text = [NSString stringWithFormat:@"%ld", index+1];
    
    
    
    
}
-(void)updateCoinCell{
    
    //设置显示内容为自己
   self.coinCell.user = [TRUser currentUser].bmobUser;
    
    NSInteger index;
    
    for (NSInteger i = 0; i < self.coinRankArr.count; i++) {
        BmobObject *aUser = self.coinRankArr[i];
        //找自己 出现的位置
        if ([[aUser objectForKey:@"username"] isEqualToString:[TRUser currentUser].username]){
            index = i;
            break;
        }
    }
    _coinCell.rankType = RANKTYPECOIN;
    _coinCell.rankLabel.text = [NSString stringWithFormat:@"%ld", index+1];
    
    
    
    
}

-(void)addCurrentUserClassesWithUser:(BmobObject *)user{
    self.classes = [user objectForKey:@"classes"];
    NSArray *newArr = [@[@"全部班级"] arrayByAddingObjectsFromArray:self.classes];
    self.classesSC  = [[UISegmentedControl alloc] initWithItems:newArr];
    self.classesSC.frame = CGRectMake(kMargin, 70, kScreenW-2*kMargin, 30);
    self.classesSC.selectedSegmentIndex = 0;
    [self.classesSC addTarget:self action:@selector(changeContent:) forControlEvents:UIControlEventValueChanged];
    self.classesSC.tintColor = MainColor;
    [self.view addSubview:self.classesSC];

    
}

-(void)changeContent:(UISegmentedControl *)classesSC{
    [self loadScoreRankingData];
    [self loadCoinRankingData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UItableView协议方法



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
  //判断协议方法到底响应的是哪个tableView
    if ([tableView isEqual:self.scoreRankTableView]){//积分排行表
        return self.scoreRankArr.count;
        
    }else{//金币排行表
        return self.coinRankArr.count;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TRRankingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
  
    
    
        if ([tableView isEqual:self.scoreRankTableView]){
            BmobObject *theUser = self.scoreRankArr[indexPath.row];
            cell.rankType = RANKTYPESCORE;
            cell.user = theUser;
            
        }else{
            BmobObject *theUser = self.coinRankArr[indexPath.row];
            cell.rankType = RANKTYPECOIN;
            cell.user = theUser;
        }
        //设置排名的值
        cell.rankLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row+1];
 
    

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 58;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
        
        if ([tableView isEqual:self.scoreRankTableView]) {
             return @"积分排行";
        }
        return @"金币排行";
 
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return kMargin;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobObject *user = nil;
    if ([tableView isEqual:self.scoreRankTableView]) {
        user = self.scoreRankArr[indexPath.row];
    }else{
        user = self.coinRankArr[indexPath.row];
    }
    
    
    TRUserInfoViewController *vc = [TRUserInfoViewController new];
    vc.user = user;
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
    
    
}


@end
