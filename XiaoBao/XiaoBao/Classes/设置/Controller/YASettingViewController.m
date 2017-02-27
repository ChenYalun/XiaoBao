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
@property (weak, nonatomic) IBOutlet UITableViewCell *firstCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *secondCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *thirdCell;
@property (weak, nonatomic) IBOutlet UIView *fourthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fifthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sixthCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sevenCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *eightCell;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UILabel *fourthLabel;
@property (weak, nonatomic) IBOutlet UILabel *fifthLabel;
@property (weak, nonatomic) IBOutlet UILabel *sixLabel;
@property (weak, nonatomic) IBOutlet UILabel *sevenLabel;
@property (weak, nonatomic) IBOutlet UILabel *eightLabel;
@property (weak, nonatomic) IBOutlet UISwitch *firstSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *secondSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *thirdSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *fourthSwitch;

@end

@implementation YASettingViewController

#pragma mark - 快速创建
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

#pragma mark - life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationController];
    
    // 设置背景颜色
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(SettingViewBackgroundColor);
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.dk_barTintColorPicker = DKColorPickerWithKey(NavigationViewBackgroundColor);
    
    
    self.firstCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.secondCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.thirdCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.fourthCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.fifthCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.sixthCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.sevenCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
    self.eightCell.dk_backgroundColorPicker = DKColorPickerWithKey(SettingCellBackgroundColor);
  
    
    self.firstLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.secondLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.thirdLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.fourthLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.fifthLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.sixLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.sevenLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    self.eightLabel.dk_textColorPicker = DKColorPickerWithKey(LabelColor);
    
    

    self.firstSwitch.dk_tintColorPicker = DKColorPickerWithKey(SwitchTintColor);
    self.secondSwitch.dk_tintColorPicker = DKColorPickerWithKey(SwitchTintColor);
    self.thirdSwitch.dk_tintColorPicker = DKColorPickerWithKey(SwitchTintColor);
    self.fourthSwitch.dk_tintColorPicker = DKColorPickerWithKey(SwitchTintColor);
    
    // 图片的夜间模式
//    self.iconImageView.dk_imagePicker = DKImagePickerWithImages([UIImage imageNamed:@"Account_Avatar"],[UIImage imageNamed:@"Dark_Account_Avatar"]);
//
    self.iconImageView.dk_imagePicker = DKImagePickerWithNames(@"Account_Avatar",@"Dark_Account_Avatar");
//    self.iconImageView.dk_imagePicker = DKImagePickerWithNames();
    
    
    // 设置tableView顶部间距
    CGRect frame=CGRectMake(0, 0, 0, 20);
    self.tableView.tableHeaderView=[[UIView alloc]initWithFrame:frame];
    
    
    
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.iconImageView.bounds = CGRectMake(0, 0, kIconImageWH, kIconImageWH);
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

#pragma mark - event response

// 发送邮件
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

// 清除缓存
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

// 去好评
- (void)gotoAppStore {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://appsto.re/cn/Fv7fM.i"]];
}
@end
