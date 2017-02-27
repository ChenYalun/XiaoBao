//
//  YAEditorListViewController.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/20.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAEditorItem.h"
@interface YAEditorListViewController : UIViewController

/** 编辑数组 */
@property (nonatomic,strong) NSArray <YAEditorItem *> *editors;

@end
