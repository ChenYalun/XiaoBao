//
//  YASettingViewController.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/25.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YASettingViewController.h"
#import <UIViewController+MMDrawerController.h>
#import "YAProgressHUD.h"
#import <YYWebImageManager.h>
#import <YYCache.h>
#define kSectionFooterHeight 15
#define kSectionHeaderHeight 8
#define kIconImageWH 38
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
    
    
    // 设置tableView顶部间距
    CGRect frame=CGRectMake(0, 0, 0, 20);
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
    
    
    
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

    

}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.iconImageView.bounds = CGRectMake(0, 0, kIconImageWH, kIconImageWH);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) { // 返回指定格式的提示文字
        UIView *view = [[UIView alloc] init];
        UILabel *label = [[UILabel alloc] init];
        label.height = kSectionFooterHeight;
        NSMutableAttributedString *stre = [[NSMutableAttributedString alloc] initWithString:@"仅 Wi-Fi 下可用，自动下载最新内容" attributes:@{
                                                                                                                                      NSFontAttributeName : [UIFont systemFontOfSize:10], NSForegroundColorAttributeName : [UIColor lightGrayColor],
                                                                                                                                      
                                                                                                                                      }];
        label.attributedText = stre;
        [view addSubview:label];
        label.frame = CGRectMake(22, 2, kScreenWidth, kSectionFooterHeight);
     
        return view;
    } else {
        return nil;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kSectionFooterHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeaderHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 去吐槽
    if (indexPath.section == 4 && indexPath.row == 1) {
        [self sendEmail];
    }
    
    // 去好评
    if (indexPath.section == 4 && indexPath.row == 0) {
        [self gotoAppStore];
    }
    
    // 清除缓存
    if (indexPath.section == 5) {
        [self clearDisk];
    }
    

    // 选中后不久取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - 发送邮件
- (void)sendEmail {
    
    NSMutableString *mailUrl = [NSMutableString string];
    
    //添加收件人
    NSArray *toRecipients = [NSArray arrayWithObject: @"first@example.com"];
    [mailUrl appendFormat:@"mailto:%@", [toRecipients componentsJoinedByString:@","]];
    
    //添加抄送
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
    [mailUrl appendFormat:@"?cc=%@", [ccRecipients componentsJoinedByString:@","]];
    
    //添加密送
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"fourth@example.com", nil];
    [mailUrl appendFormat:@"&bcc=%@", [bccRecipients componentsJoinedByString:@","]];
    
    //添加主题
    [mailUrl appendString:@"&subject=my email"];
    
    //添加邮件内容
    [mailUrl appendString:@"&body=<b>email</b> body!"];
    
    NSString *email = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:email]];
}

#pragma mark - 清除缓存
- (void)clearDisk {
    
    // 图片缓存
    kClearDiskCache;
    kClearMemoryCache;



    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Caches目录
    NSString *cachesPath =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;

 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
     
     //拿到path路径的所有的的子文件夹
     NSArray *subPaths = [fileManager subpathsAtPath:cachesPath];
     
     // 遍历路径
     for (NSString *path in subPaths) {
         NSString *filePath = [cachesPath stringByAppendingPathComponent:path];
         [fileManager removeItemAtPath:filePath error:nil];
     }
     
     
     // 提示
     dispatch_sync(dispatch_get_main_queue(), ^{
         [YAProgressHUD showSuccessWithStatus:@"清除成功"];
     });
     
 });
    

}


#pragma mark - 去好评
- (void)gotoAppStore {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/Fv7fM.i"]];
}
@end
