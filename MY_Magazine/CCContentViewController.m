//
//  CCContentViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//
/**
 *  description:        期刊内容页面
 */
#import "CCContentViewController.h"
#import "CCCommentViewController.h"
#import "CCThumbViewController.h"

#import "HMSideMenu.h"
#import "Utilities.h"
#import "LeavesView.h"
#import "AllDefineHeader.h"
@interface CCContentViewController ()<UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *HomeBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *CommentBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ShareBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ThumbBtn;

@property (strong, nonatomic) UIActionSheet * shareActionSheet;
@property (strong, nonatomic) NSArray * BarItems;
//leaves框架
//@property (readonly) NSArray *images;
@end

@implementation CCContentViewController

@synthesize shareActionSheet,CommentViewController,ThumbViewController,imagesArray,ThumbImagesArray,sideMenu;
@synthesize BarItems,HomeBtn,CommentBtn,ShareBtn,ThumbBtn;
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
    [[NSNotificationCenter defaultCenter]postNotificationName:@"thumbImages" object:ThumbImagesArray];
    [self presentViewController:ThumbViewController animated:YES completion:Nil];
}
- (void)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");
    [self dismissViewControllerAnimated:YES completion:Nil];
//    [self.leavesView removeFromSuperview];

}
- (void)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
    CommentViewController = [[CCCommentViewController alloc]initWithNibName:@"CCCommentViewController" bundle:Nil];
    [self presentViewController:CommentViewController animated:YES completion:Nil];
}
- (void)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
    shareActionSheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到新浪微博" otherButtonTitles:@"分享到腾讯微博", nil];
    [shareActionSheet showInView:self.view];

}

#pragma mark - Gesture Methods

//-(void)pageSelected:(UITapGestureRecognizer *)sender{
//    NSLog(@"tap.....");
//    //增加隐藏toolbar动画
//    CATransition *trans=[CATransition animation];
//    trans.type=kCATransitionPush;
//    
//    trans.duration=0.5;
//
//    if (isToolbarHidden) {
//        isToolbarHidden = NO;
//        trans.subtype=kCATransitionFromTop;
//        [Toolbar.layer addAnimation:trans forKey:@"transition"];
//        [Toolbar setHidden:isToolbarHidden];
//    }else if(!isToolbarHidden){
//        isToolbarHidden = YES;
//        trans.subtype=kCATransitionFromBottom;
//        [Toolbar.layer addAnimation:trans forKey:@"transition"];
//        [Toolbar setHidden:isToolbarHidden];
//    }
//}

#pragma mark - LifeCycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    NSLog(@"ContentViewInit..........");
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        imagesArray = [[NSMutableArray alloc]init];
        ThumbImagesArray = [[NSMutableArray alloc]init];
        _images = [[NSMutableArray alloc]init];
        //注册接收内容图片集合的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getInfo:) name:@"topic" object:Nil];
        //注册接收目录页图片集合的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getThumbImages:) name:@"topic2" object:Nil];
        //注册接收目录页返回的行数
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getSelectRowFromThumbview:) name:@"selectRow" object:Nil];
    }
    return self;
}
//接收目录页传回来的页码
-(void)getSelectRowFromThumbview:(NSNotification *)info{
    NSInteger row = [[info object] integerValue];
    [self.leavesView setCurrentPageIndex:row];
}

//接收通知,目录页的图片集合
-(void)getThumbImages:(NSNotification *)info{
    NSLog(@"接收通知....");
    if (ThumbImagesArray) {
        [ThumbImagesArray removeAllObjects];
    }
    for (UIImage * img in [info object]) {
        [ThumbImagesArray addObject:img];
    }
}
//接收通知，内容页显示的图片集合
-(void)getInfo:(NSNotification *)info{
//    NSLog(@"接收通知.....");
    if (imagesArray) {
        [imagesArray removeAllObjects];
        [_images removeAllObjects];
    }
    for (UIImage * img in [info object]) {
        [imagesArray addObject:img];
        [_images addObject:img];
    }
//    [self reloadInputViews];
    [self.leavesView reloadData];
}
-(void)viewDidDisappear:(BOOL)animated{
    
}
- (void)toggleMenu:(id)sender {
    if (self.sideMenu.isOpen)
        [self.sideMenu close];
    else
        [self.sideMenu open];
}



- (void)viewDidLoad
{
    
    NSLog(@"ContentView did load......");
    [super viewDidLoad];
    
    CGRect ItemFrame = CGRectMake(0, 0, 66, 40);
    UIColor * bgcolor = [UIColor colorWithRed:0.220 green:0.185 blue:0.126 alpha:0.500];
    UIView *HomeItem = [[UIView alloc] initWithFrame:ItemFrame];
    [HomeItem setBackgroundColor:bgcolor];
    [HomeItem.layer setCornerRadius:8];
    [HomeItem setMenuActionWithBlock:^{
        [self HomeBtnPressed:Nil];
    }];
    UIImageView *HomeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28, 28)];
    [HomeIcon setImage:[UIImage imageNamed:@"btn_home.png"]];
    [HomeItem addSubview:HomeIcon];
    
    UIView *CommentItem = [[UIView alloc] initWithFrame:ItemFrame];
    [CommentItem setBackgroundColor:bgcolor];
    [CommentItem.layer setCornerRadius:8];
    [CommentItem setMenuActionWithBlock:^{
        [self CommentBtnPressed:Nil];
    }];
    UIImageView *CommentIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28 , 28)];
    [CommentIcon setImage:[UIImage imageNamed:@"btn_cmt.png"]];
    [CommentItem addSubview:CommentIcon];
    
    UIView *ShareItem = [[UIView alloc] initWithFrame:ItemFrame];
    [ShareItem setBackgroundColor:bgcolor];
    [ShareItem.layer setCornerRadius:8];
    [ShareItem setMenuActionWithBlock:^{
        [self ShareBtnPressed:Nil];
        
    }];
    UIImageView *ShareIcon = [[UIImageView alloc] initWithFrame:CGRectMake(19, 6, 28, 28)];
    [ShareIcon setImage:[UIImage imageNamed:@"btn_share.png"]];
    [ShareItem addSubview:ShareIcon];
    
    
    UIView *ThumbItem = [[UIView alloc] initWithFrame:ItemFrame];
    [ThumbItem setBackgroundColor:bgcolor];
    [ThumbItem.layer setCornerRadius:8];
    [ThumbItem setMenuActionWithBlock:^{
        [self ThumbBtnPressed:Nil];
    }];
    UIImageView *ThumbIcon = [[UIImageView alloc] initWithFrame:CGRectMake(21, 8, 24, 24)];
    [ThumbIcon setImage:[UIImage imageNamed:@"btn_catalog.png"]];
    [ThumbItem addSubview:ThumbIcon];
    
    self.sideMenu = [[HMSideMenu alloc] initWithItems:@[HomeItem, CommentItem, ShareItem, ThumbItem]];
    [self.sideMenu setItemSpacing:5.0f];
    [self.sideMenu setMenuPosition:HMSideMenuPositionBottom];
    [self.view addSubview:self.sideMenu];


    // Do any additional setup after loading the view from its nib.
    //Tap手势显示及隐藏Toolbar
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(toggleMenu:)];
    [self.leavesView addGestureRecognizer:tap1];
    [self.view insertSubview:self.leavesView atIndex:0];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置隐藏状态栏
//-(BOOL)prefersStatusBarHidden{
//    return YES;
//}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

@end
