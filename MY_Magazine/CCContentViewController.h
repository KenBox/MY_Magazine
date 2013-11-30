//
//  CCContentViewController.h
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCMagazineTopic.h"
#import "LeavesViewController.h"
@class CCCommentViewController,CCThumbViewController;
@interface CCContentViewController :LeavesViewController<UIGestureRecognizerDelegate>
@property (nonatomic,strong) CCCommentViewController * CommentViewController;
@property (nonatomic,strong) CCThumbViewController * ThumbViewController;
@property (nonatomic,strong) CCMagazineTopic * ContentTopic;

@property (nonatomic,strong) NSString * ContentXMLPath;//存放期刊内容页的本地路径
@property (nonatomic,strong) NSMutableArray * ContentViewImages;//存放解压后的期刊内容页图片

@property (nonatomic,strong) NSMutableArray *images;
@end
