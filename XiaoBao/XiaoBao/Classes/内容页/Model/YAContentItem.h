//
//  YAContentItem.h
//  XiaoBao
//
//  Created by 陈亚伦 on 2017/2/22.
//  Copyright © 2017年 陈亚伦. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YAContentItem : NSObject
/** HTML 格式的新闻 */
@property (nonatomic,copy) NSString *body;
/** 图片的内容提供方 */
@property (nonatomic,copy) NSString *image_source;
/** 新闻标题 */
@property (nonatomic,copy) NSString *title;
/** 在文章浏览界面中使用的大图 */
@property (nonatomic,copy) NSString *image;
/** 供在线查看内容与分享至 SNS 用的 URL */
@property (nonatomic,copy) NSString *share_url;
/** js  */
@property (nonatomic,strong) NSArray <NSString *> *js;
/** css */
@property (nonatomic,strong) NSArray <NSString *> *css;

/** 这篇文章的推荐者 */
//@property (nonatomic,copy) NSString *recommenders;
/** 栏目的信息 */
//@property (nonatomic,copy) NSString *section;
/** 栏目的缩略图 */
//@property (nonatomic,copy) NSString *thumbnail;
/** 该栏目的 id */
//@property (nonatomic,copy) NSString *ID;
/** 栏目名称 */
//@property (nonatomic,copy) NSString *name;
/** 新闻类型 */
//@property (nonatomic,copy) NSString *type;

+ (instancetype)contentItemWithKeyValues:(id)responseObject;

@end
