//
//  YAStoryItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAStoryItem : NSObject
/** title */
@property (nonatomic,copy) NSString *title;
/** images */
@property (nonatomic,strong) NSArray *images;
/** multipic是否包含多张图片 */
@property (nonatomic,assign) BOOL multipic;
/** image--top */
@property (nonatomic,copy) NSString *image;
/** id */
@property (nonatomic,assign) NSInteger ID;


// 字典转模型
+ (NSArray <YAStoryItem *> *)storyItemsWithKeyValues:(id)responseObject;
+ (NSArray <YAStoryItem *> *)topStoryItemWithKeyValues:(id)responseObject;

// 根据字符串'20170214'返回指定格式'02月14日 星期二'
+ (NSString *)formatStringWithDateString:(NSString *)string;

@end
