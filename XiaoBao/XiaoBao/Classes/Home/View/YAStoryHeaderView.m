//
//  YAStoryHeaderView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryHeaderView.h"
#import <UIImageView+YYWebImage.h>
#import <UIImage+YYWebImage.h>
#import "UIImage+YAVImage.h"
@interface YAStoryHeaderView()
/** 图片 */
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
/** 标题 */
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end
@implementation YAStoryHeaderView

#pragma mark - getter and setter

- (void)setStory:(YAStoryItem *)story {
    _story = story;
    
    [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image] placeholder:nil options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        
        image = [UIImage boxblurImage:image withBlurNumber:1];
    }];

   // [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image] options:YYWebImageOptionSetImageWithFadeAnimation];
    

    
    self.titleLabel.text = story.title;
}


@end
