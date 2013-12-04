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
@class CCCommentViewController,CCThumbViewController,HMSideMenu;


@interface CCContentViewController :LeavesViewController<UIGestureRecognizerDelegate>
@property (nonatomic,strong) CCCommentViewController * CommentViewController;
@property (nonatomic,strong) CCThumbViewController * ThumbViewController;
@property (nonatomic,strong) CCMagazineTopic * ContentTopic;



@property (nonatomic,strong) NSMutableArray * imagesArray;//存放了ContentView需要显示的UIImage集合
@property (nonatomic,strong) NSMutableArray * ThumbImagesArray;//存放了ThumbView需要显示的UIImage集合
//Leaves框架
@property (nonatomic,strong) NSMutableArray *images;

@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) HMSideMenu *sideMenu;

- (void)toggleMenu:(id)sender;


@end
