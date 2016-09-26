//
//  LYUserInfoViewController.m
//  ITSNS
//
//  Created by Ivan on 16/1/9.
//  Copyright © 2016年 Ivan. All rights reserved.
//

#import "TRUserHeaderView.h"
#import "TRDetailViewController.h"
#import "TRUserInfoViewController.h"
#import "TRITObject.h"
#import "LYHomeCell.h"
#import "SVPullToRefresh.h"
@interface TRUserInfoViewController ()<UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong)NSMutableArray *itObjs;
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSData *imageData;
@property (nonatomic)BOOL isSelf;
@property (nonatomic, strong)UISegmentedControl *typeSC;
 
@end

@implementation TRUserInfoViewController

-(UISegmentedControl *)typeSC{
    if (!_typeSC) {
        _typeSC = [[UISegmentedControl alloc]initWithItems:@[@"全部",@"消息",@"作业"]];
        _typeSC.tintColor = MainColor;
        _typeSC.frame = CGRectMake(0, 0, LYSW/2, 25);
        _typeSC.center = CGPointMake(LYSW/2, 80);
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
  
    self.title = [self.user objectForKey:@"nick"];
    
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
        
        [self loadObjs];
        
    }];
    
    
    
    //触发下拉刷新事件
    [tableView triggerPullToRefresh];
    
    //添加 上拉加载事件
    [tableView addInfiniteScrollingWithActionHandler:^{
        [self loadMoreObjs];
    }];
    
    
    
    TRUserHeaderView *hv = [[NSBundle mainBundle]loadNibNamed:@"TRUserHeaderView" owner:self options:0][0];
    hv.user = self.user;
    
    self.tableView.tableHeaderView = hv;
    
    [hv.bottomView addSubview:self.typeSC];
    
    //给用户头像添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [hv.headIV addGestureRecognizer:tap];
    
    
 
    //发红包按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发红包" style:UIBarButtonItemStyleDone target:self action:@selector(sendScoreOrMoney)];
    

}
- (void)sendScoreOrMoney{
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入金币或者积分" preferredStyle:UIAlertControllerStyleAlert];
    
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"积分";
    }];
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"金币";
    }];
    
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action1];
    [ac addAction:action2];
    
    [self presentViewController:ac animated:YES completion:nil];
}
-(void)tapAction{
    
    UIImagePickerController *vc = [[UIImagePickerController alloc]init];
    vc.delegate = self;
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}
-(void)editAction{
        TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑信息"]) {
        
        
        
        hv.nickTF.enabled = YES;
        hv.nickTF.backgroundColor = MainColor;
        
        hv.headIV.userInteractionEnabled = YES;
        hv.headIV.layer.borderColor = MainColor.CGColor;
        hv.headIV.layer.borderWidth = 3;
        
        
        
        self.navigationItem.rightBarButtonItem.title = @"保存";
        
    }else{//保存操作
        
        hv.nickTF.enabled = NO;
        hv.nickTF.backgroundColor = [UIColor clearColor];
        hv.headIV.layer.borderWidth = 0;
        
        
        NSString *currentNick = [self.user objectForKey:@"nick"];
        
        if (self.imageData||![hv.nickTF.text isEqualToString:currentNick]) {
            
            //判断是否有图片
            if (self.imageData) {
                //上传图片
                BmobFile *file = [[BmobFile alloc]initWithFileName:@"a.jpg" withFileData:self.imageData];
                [file saveInBackground:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        
                       
                        //更新头像地址
                        [self.user setObject:file.url forKey:@"headPath"];
                        [self.user setObject:hv.nickTF.text forKey:@"nick"];
                        [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                           
                            NSLog(@"头像保存成功！");
                                [self.tableView triggerPullToRefresh];
                            //让headView内容更新
                            hv.user = self.user;
                        }];
                        
                    }
                } withProgressBlock:^(CGFloat progress) {
                    NSLog(@"%lf",progress);
                }];
                
            }else{//没有头像只修改 nick
                
                
                //更新用户nick
                [self.user setObject:hv.nickTF.text forKey:@"nick"];
                [self.user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    NSLog(@"用户名保存成功！");
                    
                    [self.tableView triggerPullToRefresh];
                    //让headView内容更新
                    hv.user = self.user;
                }];

                
                
                
            }
            
            
            
        }
        
        
        self.navigationItem.rightBarButtonItem.title = @"编辑信息";
    }
    

    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.tableView triggerPullToRefresh];
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    hv.user = self.user;
//    //判断只有是显示自己信息的时候更新 表头数据
//    if ([[self.user objectForKey:@"username"]  isEqualToString:[BmobUser currentUser].username]) {
//        
//        hv.user = [TRUser currentUser].bmobUser;
//    }
    
}

-(void)loadMoreObjs{
    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
    
    //跳过已有数据的个数
    query.skip = self.itObjs.count;
    //只查询自己相关
    [query whereKey:@"user" equalTo:self.user];
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
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"Status"];
    
    //设置请求条数
    query.limit = 10;
    
    [query whereKey:@"user" equalTo:self.user];
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
    
    return itObj.contentHeight + 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TRDetailViewController *vc = [TRDetailViewController new];
    
    vc.itObj = self.itObjs[indexPath.row];
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
    self.tableView.clipsToBounds = NO;
}

//当SV拖动的时候会不停的进入此方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    
    [hv updateSubViewsWithOffset:scrollView.contentOffset.y];
    
    
}

#pragma mark 选择图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.imageData = UIImageJPEGRepresentation(image, .5);
    
    TRUserHeaderView *hv = (TRUserHeaderView *)self.tableView.tableHeaderView;
    hv.headIV.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
