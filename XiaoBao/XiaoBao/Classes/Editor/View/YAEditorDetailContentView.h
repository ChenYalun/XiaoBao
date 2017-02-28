//
//  YAEditorDetailContentView.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/21.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YAEditorItem.h"

@interface YAEditorDetailContentView : UIView

// 快速创建
+ (instancetype)editorViewWithItem:(YAEditorItem *)editor;
@end
