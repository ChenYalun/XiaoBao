//
//  YAHTTPManager.m
//  NanDe
//
//  Created by 陈亚伦 on 2017/2/13.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAHTTPManager.h"

@implementation YAHTTPManager



+ (instancetype)sharedManager {
    static YAHTTPManager *manager = nil;
    static dispatch_once_t onceToken;
    // 使用dispatch_once保证线程安全
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] initWithBaseURL:[NSURL URLWithString:@"http://chenyalum.com/"]];
    });
    return manager;
}

//-(instancetype)initWithBaseURL:(NSURL *)url
//{
//    if (self = [super initWithBaseURL:url]) {
//        // 请求超时设定
//        self.requestSerializer.timeoutInterval = 5.0;
//        self.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
//        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//        [self.requestSerializer setValue:url.absoluteString forHTTPHeaderField:@"Referer"];
//        
//        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json", @"text/html", nil];
//        
//        self.securityPolicy.allowInvalidCertificates = YES;
//    }
//    return self;
//}

- (void)requestWithMethod:(YAHTTPMethod)method WithPath:(NSString *)path WithParameters:(NSDictionary *)parameters WithSuccessBlock:(requestSuccessBlock)success WithFailurBlock:(requestFailureBlock)failure {
    
    switch (method) {
        case GET:{
            [self GET:path parameters:parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                // 容错处理,failure可以为空
                if(failure) {
                    failure(error);
                }
                
            }];
            break;
        }
        case POST:{
            [self POST:path parameters:parameters progress:nil success:^(NSURLSessionTask *task, NSDictionary * responseObject) {
                success(responseObject);
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                if(failure) {
                    failure(error);
                }

            }];
            break;
        }
        default:
            break;
    }
    


}

@end
