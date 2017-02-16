//
//  YASectionHeaderView.m
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/16.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import "YASectionHeaderView.h"
@interface YASectionHeaderView()
@property (nonatomic,strong) UILabel *titleLabel;
@end
@implementation YASectionHeaderView

- (void)setSectionTitle:(NSString *)sectionTitle {
    _sectionTitle = sectionTitle;
    
    self.titleLabel.text = sectionTitle;
    
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        titleLabel.font = [UIFont systemFontOfSize:17];
        titleLabel.backgroundColor = kGlobalColor;
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.titleLabel];

    }
    return self;
}

@end
