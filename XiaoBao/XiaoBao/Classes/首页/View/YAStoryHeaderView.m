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
@interface YAStoryHeaderView()
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation YAStoryHeaderView
- (void)setStory:(YAStoryItem *)story {
    _story = story;
    
    [self.picImageView yy_setImageWithURL:[NSURL URLWithString:story.image] options:YYWebImageOptionShowNetworkActivity];
    self.titleLabel.text = story.title;
}


@end
