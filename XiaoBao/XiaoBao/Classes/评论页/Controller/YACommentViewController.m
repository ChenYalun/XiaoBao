//
//  YACommentViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/23.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YACommentViewController.h"
#import "YACommentTableViewCell.h"
//#import <UITableView+FDTemplateLayoutCell.h>
#import "YAHTTPManager.h"
@interface YACommentViewController ()

@property (nonatomic,strong) NSMutableArray <NSMutableArray *>*comments;
@end

@implementation YACommentViewController
static NSString *reuseIdentifier = @"comment";

#pragma mark - 懒加载
- (NSMutableArray<NSMutableArray *> *)comments {
    if (_comments == nil) {
        _comments = [NSMutableArray array];
        _comments[0] = [NSMutableArray array];
        _comments[1] = [NSMutableArray array];
    }
    return _comments;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.estimatedRowHeight = 30;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:[YACommentTableViewCell className] bundle:nil] forCellReuseIdentifier:reuseIdentifier];
    
    // http://news-at.zhihu.com/api/4/story/4232852/
    
//    http://news-at.zhihu.com/api/4/story/8997528/
    
    
    // 长评论
    [self refreshForCommentsWithId:[NSString stringWithFormat:@"%ld",self.storyID] kindOfComment:@"long-comments"];
    
    // 短评论
   // [self refreshForCommentsWithId:self.storyID kindOfComment:@"short-comments"];
}

- (void)refreshForCommentsWithId:(NSString *)commentID kindOfComment:(NSString *)kind {
    
    // 请求路径
    NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story/%@/%@",commentID,kind];
    requestSuccessBlock sblock = ^(id responseObject){
        NSArray *array = [YACommentModel commentModelWithKeyValues:responseObject];
        [self.comments[0] addObjectsFromArray:array];
        
        [self.tableView reloadData];
    };
    
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:path WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.comments[section].count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YACommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.comment = self.comments[indexPath.section][indexPath.row];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [tableView fd_heightForCellWithIdentifier:reuseIdentifier configuration:^(YACommentTableViewCell *cell) {
//     
//    cell.comment = self.comments[indexPath.section][indexPath.row];
//    }];
//}

// 选中后调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    YACommentTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    cell.comment.isOpen = !cell.comment.isOpen;
//    
//    [tableView reloadRow:indexPath.row inSection:indexPath.section withRowAnimation:UITableViewRowAnimationNone];
    
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
