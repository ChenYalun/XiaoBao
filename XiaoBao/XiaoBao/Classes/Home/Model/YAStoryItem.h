//
//  YAStoryItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Realm.h>
#import "YAImageObject.h"

RLM_ARRAY_TYPE(YAImageObject)


@interface YAStoryItem : RLMObject
/** title */
@property (nonatomic,copy) NSString *title;
/** images */
@property (nonatomic,strong) NSMutableArray  *images; // 不支持NSArray
/** multipic是否包含多张图片 */
@property (nonatomic,assign) BOOL multipic;
/** image--top */
@property (nonatomic,copy) NSString *image;
/** id */
@property (nonatomic,assign) NSInteger ID;



/** Realm中存储的图片数组 */
@property(nonatomic,strong)RLMArray <YAImageObject> *imageUrls;
/** story所属的日期 */
@property (nonatomic,copy) NSString *storyDate;
// 字典转模型
+ (NSArray <YAStoryItem *> *)storyItemsWithKeyValues:(id)responseObject;
+ (NSArray <YAStoryItem *> *)topStoryItemWithKeyValues:(id)responseObject;




/*
 
 All properties must be primitives, NSString, NSDate, NSData, NSNumber, RLMArray, RLMLinkingObjects, or subclasses of RLMObject. See https://realm.io/docs/objc/latest/api/Classes/RLMObject.html for more information.'
 
 */

@end




