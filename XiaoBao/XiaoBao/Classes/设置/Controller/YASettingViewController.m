//
//  YASettingViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/25.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YASettingViewController.h"
#import <UIViewController+MMDrawerController.h>
@interface YASettingViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation YASettingViewController

+ (instancetype)settingViewController {
    YASettingViewController *settingViewController = [UIStoryboard storyboardWithName:[self className] bundle:nil].instantiateInitialViewController;
    return settingViewController;
}

- (instancetype)init {
    if (self = [super init]) {
        self = [YASettingViewController settingViewController];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationController];
    
}

#pragma mark - 设置导航栏
- (void)setupNavigationController {
    // 导航栏item封装button
    UIButton *leftButton = [[UIButton alloc] init];
    [leftButton setImage:kGetImage(@"Dark_News_Arrow") forState:UIControlStateNormal];
    leftButton.frame = CGRectMake(0, 0, 40, 40);
    leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    
    // 返回侧栏
    [leftButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    }];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    // 设置导航栏
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.title = @"设置";
    
    // 设置tableView顶部间距
    CGRect frame=CGRectMake(0, 0, 0, 20);
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
    

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.iconImageView.bounds = CGRectMake(0, 0, 38, 38);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) { // 返回指定格式的提示文字
        UILabel *label = [[UILabel alloc] init];
        label.height = 20;
        NSMutableAttributedString *stre = [[NSMutableAttributedString alloc] initWithString:@"       仅Wi-Fi下可用，自动下载最新内容" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor lightGrayColor]}];
        label.attributedText = stre;
        
        return label;
    } else {
        return nil;
    }

}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:; forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
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
