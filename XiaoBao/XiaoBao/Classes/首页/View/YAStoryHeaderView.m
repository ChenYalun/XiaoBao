//
//  YAStoryHeaderView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/15.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YAStoryHeaderView.h"
#import <SDCycleScrollView.h>
#import <UIImageView+YYWebImage.h>
#import "GPUImageBrightnessFilter.h"
#import <GPUImagePicture.h>
#import <UIImage+YYWebImage.h>
@interface YAStoryHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation YAStoryHeaderView
- (void)setStory:(YAStoryItem *)story {
    _story = story;
    
//    [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image] placeholder:nil options:YYWebImageOptionShowNetworkActivity|YYWebImageOptionProgressiveBlur|YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
//        GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
//        filter.brightness = 0.2;
//        image =  [filter imageFromCurrentFramebuffer];
//    }];

    
    [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image]
                      placeholder:nil
                          options:YYWebImageOptionSetImageWithFadeAnimation
                         progress:nil
                        transform:^UIImage *(UIImage *image, NSURL *url) {
                            
                            GPUImageBrightnessFilter *filter = [[GPUImageBrightnessFilter alloc] init];
                            // 调节亮度 +增加 -减少 默认0不增不减
                            filter.brightness = -0.25;
                            //设置要渲染的区域
                            [filter forceProcessingAtSize:image.size];
                            [filter useNextFrameForImageCapture];
                            
                            //获取数据源
                            GPUImagePicture *picture = [[GPUImagePicture alloc] initWithImage:image];
                            //添加滤镜
                            [picture addTarget:filter];
                            //开始渲染
                            [picture processImage];
                            //获取渲染后的图片

                            return [filter imageFromCurrentFramebuffer];;
                        }
                       completion:nil];

    
    self.titleLabel.text = story.title;
}


@end
