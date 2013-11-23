//
//  CCContentViewController.h
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PRPViewTransition.h"
@class CCCommentViewController,CCThumbViewController;
@interface CCContentViewController :UIViewController{
    int loop;
}
@property (nonatomic,strong) UIButton * back;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic, retain)  UIView *currentView;
@property (nonatomic,strong) CCCommentViewController * CommentViewController;
@property (nonatomic,strong) CCThumbViewController * ThumbViewController;
@end
