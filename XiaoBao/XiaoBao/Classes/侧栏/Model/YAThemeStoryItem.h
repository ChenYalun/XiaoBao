//
//  YAThemeStoryItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/19.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAStoryItem.h"

@interface YAThemeStoryItem : NSObject
/** 新闻数组 */
@property (nonatomic,strong) NSMutableArray <YAStoryItem *> *stories;
/** 描述 */
@property (nonatomic,copy) NSString *desc;
/** 背景 */
@property (nonatomic,copy) NSString *background;
/** 颜色 */
@property (nonatomic,copy) NSString *color;
/** 主题名称 */
@property (nonatomic,copy) NSString *name;
/** 图片 */
@property (nonatomic,copy) NSString *image;
/** 图片来源 */
@property (nonatomic,copy) NSString *image_source;

/** 编辑 */
@property (nonatomic,strong) NSArray *editors;

+ (YAThemeStoryItem *)themeStoryItemWithKeyValues:(id)responseObject;
@end
