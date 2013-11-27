//
//  CCContentViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCContentViewController.h"
#import "CCCommentViewController.h"
#import "CCThumbViewController.h"
#import "Utilities.h"
#import "LeavesView.h"
@interface CCContentViewController ()<UIActionSheetDelegate>

@property (strong, nonatomic) UIToolbar * Toolbar;
@property (strong, nonatomic) UIBarButtonItem *HomeBtn;
@property (strong, nonatomic) UIBarButtonItem *CommentBtn;
@property (strong, nonatomic) UIBarButtonItem *ShareBtn;
@property (strong, nonatomic) UIBarButtonItem *ThumbBtn;
@property (assign, nonatomic) BOOL isToolbarHidden;
@property (strong, nonatomic) UIActionSheet * shareActionSheet;

//leaves框架
@property (readonly) NSArray *images;
@end

@implementation CCContentViewController
@synthesize Toolbar,HomeBtn,CommentBtn,ShareBtn,ThumbBtn,isToolbarHidden,shareActionSheet,CommentViewController,ThumbViewController;


#pragma mark LeavesViewDataSource

- (NSUInteger)numberOfPagesInLeavesView:(LeavesView*)leavesView {
	return _images.count;
}

- (void)renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	UIImage *image = [_images objectAtIndex:index];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,
											CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}



#pragma mark - Button Methods
- (void)ThumbBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了目录");
    ThumbViewController = [[CCThumbViewController alloc]initWithNibName:@"CCThumbViewController" bundle:Nil];
    [self presentViewController:ThumbViewController animated:YES completion:Nil];
}


- (void)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
    shareActionSheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到新浪微博" otherButtonTitles:@"分享到腾讯微博", nil];
    [shareActionSheet showInView:self.view];
}


- (void)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
    CommentViewController = [[CCCommentViewController alloc]initWithNibName:@"CCCommentViewController" bundle:Nil];
    [self presentViewController:CommentViewController animated:YES completion:Nil];
}

- (void)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Gesture Methods

-(void)pageSelected:(UITapGestureRecognizer *)sender{
    //增加隐藏toolbar动画
    CATransition *trans=[CATransition animation];
    trans.type=kCATransitionPush;
    
    trans.duration=0.5;

    if (isToolbarHidden) {
        isToolbarHidden = NO;
//        [Toolbar isUserInteractionEnabled];
        trans.subtype=kCATransitionFromTop;
        [Toolbar.layer addAnimation:trans forKey:@"transition"];
        [Toolbar setHidden:isToolbarHidden];
    }else if(!isToolbarHidden){
        isToolbarHidden = YES;
        trans.subtype=kCATransitionFromBottom;
        [Toolbar.layer addAnimation:trans forKey:@"transition"];
        [Toolbar setHidden:isToolbarHidden];
    }
}

#pragma mark - LifeCycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
		_images = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"Stars"],
                   [UIImage imageNamed:@"Balloon"],
                   [UIImage imageNamed:@"bg_carpet"],
                   nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Do any additional setup after loading the view from its nib.
    Toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    [Toolbar sizeToFit];

    //设置toolbar风格
    [Toolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    
    UIBarButtonItem *baritem1=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_home"] style:UIBarButtonItemStylePlain target:self action:@selector(HomeBtnPressed:)];
    [baritem1 setWidth:66];
    UIBarButtonItem *baritem2=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_cmt"] style:UIBarButtonItemStylePlain target:self action:@selector(CommentBtnPressed:)];
    [baritem2 setWidth:66];
    UIBarButtonItem *baritem3=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_share"] style:UIBarButtonItemStylePlain target:self action:@selector(ShareBtnPressed:)];
    [baritem3 setWidth:66];
    
    UIBarButtonItem *baritem4=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"btn_catalog"] style:UIBarButtonItemStylePlain target:self action:@selector(ThumbBtnPressed:)];
    [baritem4 setWidth:66];
    
    NSArray *items=@[baritem1,baritem2,baritem3,baritem4];
    
    [Toolbar setItems:items animated:YES];

    
    //Tap手势显示及隐藏Toolbar
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(pageSelected:)];

    [self.leavesView addGestureRecognizer:tap1];

    [self.view insertSubview:self.leavesView atIndex:0];
    [self.view insertSubview:Toolbar aboveSubview:self.view];
}



-(void)viewWillAppear:(BOOL)animated{
    [Toolbar setHidden:YES];
    isToolbarHidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置隐藏状态栏
-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
