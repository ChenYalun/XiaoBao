//
//  YAStoryTableViewCell.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryTableViewCell.h"
#import <UIImageView+YYWebImage.h>

@interface YAStoryTableViewCell()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
/** 多图指示 */
@property (weak, nonatomic) IBOutlet UIImageView *multipleImageView;
/** 标题Trailing约束 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelTrailingConstraint;
@end
@implementation YAStoryTableViewCell

#pragma mark - life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}


#pragma mark - getter and setter

- (void)setStory:(YAStoryItem *)story {
    _story = story;
    
    // 配图
    if (story.images.count > 0) {
        self.picImageView.hidden = NO;
        [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.images.firstObject] placeholder:kGetImage(@"Image_Preview") options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:nil];
        
        self.titleLabelTrailingConstraint.constant = 105;
        
    } else {
        self.picImageView.hidden = YES;
        self.titleLabelTrailingConstraint.constant = 15;
    }
    
    
    // 多图展示
    NSString *multiplePath = [[NSBundle mainBundle] pathForResource:@"/Home_Morepic@2x" ofType:@"png"];
    NSURL *multipleImageurl = [NSURL fileURLWithPath:multiplePath];
    [self.multipleImageView yy_setImageWithURL:multipleImageurl placeholder:[[UIImage alloc] init]];
    if (story.multipic && story.images.count > 0) {
        self.multipleImageView.hidden = NO;
    } else {
        self.multipleImageView.hidden = YES;
    }
    
    // 标题
    self.titleLabel.text = story.title;
    
    
}

@end
