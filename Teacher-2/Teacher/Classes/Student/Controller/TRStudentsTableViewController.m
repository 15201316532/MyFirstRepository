//
//  TRStudentsTableViewController.m
//  Theater
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//
#import "TRUserInfoViewController.h"
#import "TRStudentCell.h"
#import "TRStudentInfoViewController.h"
#import "TRStudentsTableViewController.h"
#import "TRClassesTableViewController.h"
@interface TRStudentsTableViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong)NSMutableArray *students;
@end

@implementation TRStudentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //新建班级
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"班级列表" style:UIBarButtonItemStyleDone target:self action:@selector(addClass)];
    
    //新建学生
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加学生" style:UIBarButtonItemStyleDone target:self action:@selector(addStudent)];

    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:@"TRStudentCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
  
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //查询全部学生
    [self loadStudentsWithClassName:nil];
    [self loadClasses];
}

- (void)addClass {
    TRClassesTableViewController *vc = [TRClassesTableViewController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (void)addStudent {
    TRStudentInfoViewController *vc = [TRStudentInfoViewController new];
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    return self.students.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TRStudentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
 
    
    cell.user = self.students[indexPath.row];
   
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 66;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BmobObject *user = self.students[indexPath.row];
    
    TRStudentInfoViewController *vc = [TRStudentInfoViewController new];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
    
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BmobUser *user = self.students[indexPath.row];
        [user deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"用户删除成功");
            }else{
                NSLog(@"删除用户出错：%@",error);
            }
        }];
        
        [self.students removeObject:user];
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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

-(void)loadStudentsWithClassName:(NSString *)className{
    BmobQuery *bq = [BmobQuery queryWithClassName:@"TRUser"];
    //查找某个班级的学生
    if (className) {
        [bq whereKey:@"classes" containedIn:@[className]];
    }
    
    
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        self.students = [array mutableCopy];
        [self.tableView reloadData];
        
    }];
}


-(void)loadClasses{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Classes"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        
        UIScrollView *sv = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 40)];
        //添加显示全部按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 10, 90, 20);
         [btn setTintColor:MainColor];
        [btn setTitle:@"全部学生" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickedClassAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.layer.cornerRadius = 5;
        btn.layer.masksToBounds = YES;
        btn.backgroundColor = MainColor;
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [sv addSubview:btn];
        
        for (int i=0; i<array.count; i++) {
            
            NSString *className = [array[i]objectForKey:@"className"];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(100+i*100, 10, 90, 20);
            [btn setTitle:className forState:UIControlStateNormal];
            [btn setTintColor:MainColor];
            [btn addTarget:self action:@selector(clickedClassAction:) forControlEvents:UIControlEventTouchUpInside];
            [sv addSubview:btn];
            btn.layer.cornerRadius = 5;
            btn.layer.masksToBounds = YES;
        }
        sv.contentSize = CGSizeMake(100*(array.count+1), 0);
        self.tableView.tableHeaderView = sv;
    }];
    
}
-(void)clickedClassAction:(UIButton *)btn{
 
    //遍历所有的班级按钮 清除选中效果
    for (UIButton *subView in btn.superview.subviews) {
        
        if ([subView isKindOfClass:[UIButton class]]) {
            subView.backgroundColor = [UIColor clearColor];
            [subView setTitleColor:MainColor forState:UIControlStateNormal];
        }
        
    }
    //让选中按钮效果不一样
    btn.backgroundColor = MainColor;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
    
    
    NSString *className = [btn titleForState:UIControlStateNormal];
    
    if ([className isEqualToString:@"全部学生"]) {
        [self loadStudentsWithClassName:nil];
    }else
    [self loadStudentsWithClassName:className];
    
    
}




@end
