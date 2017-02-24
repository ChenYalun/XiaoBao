//
//  YACommentViewController.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/24.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//


#import <UIKit/UIKit.h>
@interface YACommentViewController : UIViewController
/** 是否展开 */
@property (nonatomic,assign) BOOL isOpen;
/** storyID */
@property (nonatomic,assign) NSInteger storyID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end


