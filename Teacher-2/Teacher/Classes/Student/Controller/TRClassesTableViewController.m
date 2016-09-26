//
//  TRClassesTableViewController.m
//  Teacher
//
//  Created by tarena on 16/9/13.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TRClassesTableViewController.h"

@interface TRClassesTableViewController ()
@property (nonatomic, strong)NSMutableArray *classes;
@end

@implementation TRClassesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //新建班级
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加班级" style:UIBarButtonItemStyleDone target:self action:@selector(addClass)];

    [self loadClasses];
}

- (void)addClass {
    
    
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入班级的名称" preferredStyle:UIAlertControllerStyleAlert];
    
    [ac addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
       textField.placeholder = @"班级名称";
    }];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *className = ac.textFields[0].text;
        
        //新建班级表 把班级名称保存
        BmobObject *classObj = [BmobObject objectWithClassName:@"Classes"];
        [classObj setObject:className forKey:@"className"];
        
        [classObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
           
            if (isSuccessful) {
                [self loadClasses];
                
            }
            
        }];
        
        
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ac addAction:action1];
    [ac addAction:action2];
    
    [self presentViewController:ac animated:YES completion:nil];
}


-(void)loadClasses{
    
    BmobQuery *bq = [BmobQuery queryWithClassName:@"Classes"];
    [bq findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        self.classes = [array mutableCopy];
        [self.tableView reloadData];
        
    }];
    
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
 
    
    
    
    return self.classes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    BmobObject *classObj = self.classes[indexPath.row];
    
    cell.textLabel.text = [classObj objectForKey:@"className"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BmobObject *classObj = self.classes[indexPath.row];
        
        [classObj deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"删除成功");
            }
        }];
        
        [self.classes removeObject:classObj];
        
        
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

@end
