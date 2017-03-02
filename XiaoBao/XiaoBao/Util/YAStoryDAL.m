//
//  YAStoryDAL.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/3/2.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryDAL.h"
#import "YAHTTPManager.h"

@implementation YAStoryDAL

#pragma mark - event response

+ (void)obtainNewStoryItemsWithSuccessBlock:(obtainNewStorySuccessBlock)successBlock failureBlock:(obtainStoryFailureBlock)failureBlock {
    
    // 成功回调
    requestSuccessBlock sblock = ^(id responseObject){
        // 获取头部视图新闻
        NSArray *topStoryItems = [YAStoryItem topStoryItemWithKeyValues:responseObject];
    
        // 获取普通新闻
        NSArray *storyItems = [YAStoryItem storyItemsWithKeyValues:responseObject];
        
        // 把模型以及日期传出去
        successBlock(topStoryItems,storyItems,responseObject[@"date"]);
        
    };
    
    // 失败回调
    requestFailureBlock fblock = ^(NSError *error){
        if (failureBlock) {
            failureBlock(error);
        }
    };
    
    // 发送请求
    [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:@"http://news-at.zhihu.com/api/4/news/latest" WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
}


+ (void)obtainStoryItemsWithDateID:(NSString *)date successBlock:(obtainStorySuccessBlock)successBlock failureBlock:(obtainStoryFailureBlock)failureBlock {
    
    // 将日期转化为前一天
    NSString *beforeDate = [YAStoryDAL dateBefore:date];
    
    // 尝试从数据库获取数据
    NSArray <YAStoryItem *> *storyItems = [YAStoryDAL obtainStoryItemsFromDataBaseWithStoryDate:beforeDate];
    
    if (storyItems.count > 0) { // 数据库有数据,从数据库加载
        successBlock(storyItems,storyItems.lastObject.storyDate);
        failureBlock(nil);
    } else {// 数据库无数据从网络加载
        // 成功回调
        requestSuccessBlock sblock = ^(id responseObject){
            // 获取普通新闻
            NSArray *storyItems = [YAStoryItem storyItemsWithKeyValues:responseObject];
            // 保存到Realm
            [YAStoryDAL saveStoryToDataBase:storyItems];
            successBlock(storyItems,responseObject[@"date"]);
        };
        
        // 失败回调
        requestFailureBlock fblock = ^(NSError *error){
            if (failureBlock) {
                failureBlock(error);
            }
        };
        
        // 发送请求
        NSString *path = [NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/before/%@",date];
        [[YAHTTPManager sharedManager] requestWithMethod:GET WithPath:path WithParameters:nil WithSuccessBlock:sblock WithFailurBlock:fblock];
    }
}



#pragma mark - private method

// 获取数据库
+ (RLMRealm *)obtainRealm {
    // 创建数据库
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath = [docPath stringByAppendingPathComponent:@"XiaoBao.realm"];
    RLMRealm *realm = [RLMRealm realmWithURL:[NSURL URLWithString:dbPath]];
    return realm;
}

// 保存story到realm
+ (void)saveStoryToDataBase:(NSArray <YAStoryItem *> *)stories {
    // 异步执行
    dispatch_async(dispatch_get_main_queue(), ^{
        RLMRealm *realm = [YAStoryDAL obtainRealm];// 也可以使用默认Realm
        
        // 存储对象
        [realm transactionWithBlock:^{
            [realm addObjects:stories];
        }];
    });
    
}

// 从数据库取得数据
+ (NSArray<YAStoryItem *> *)obtainStoryItemsFromDataBaseWithStoryDate:(NSString *)date {
    // 获取数据库
    RLMRealm *realm = [YAStoryDAL obtainRealm];
    NSString *sql = [NSString stringWithFormat:@"storyDate = '%@'",date];

    // 返回模型数组
    NSMutableArray <YAStoryItem *> *storyItems = [NSMutableArray array];
    for (YAStoryItem *realmItem in [YAStoryItem objectsInRealm:realm where:sql]) {
        [storyItems addObject:realmItem];
    }

    return storyItems;
}

// 返回前一天 20170214--->20170213
+ (NSString *)dateBefore:(NSString *)dateString {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    NSDate *date = [formatter dateFromString:dateString];
    
    // date的前一天
    NSDate *beforeDate = [date dateByAddingDays:-1];
    
    return [formatter stringFromDate:beforeDate];

}
@end
