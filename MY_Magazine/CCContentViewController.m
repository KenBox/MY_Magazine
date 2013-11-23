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
@interface CCContentViewController ()<UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *HomeBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *CommentBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ShareBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ThumbBtn;
@property (assign, nonatomic) BOOL isToolbarHidden;
@property (strong, nonatomic) UIActionSheet * shareActionSheet;

@end

@implementation CCContentViewController
@synthesize back,Toolbar,HomeBtn,CommentBtn,ShareBtn,ThumbBtn,isToolbarHidden,scrollView,shareActionSheet,currentView,CommentViewController,ThumbViewController;

#pragma mark - ScrollViewTransition
- (void)swiped:(UISwipeGestureRecognizer *)sender {
    NSString *splashImage;
    loop++;
    switch (loop) {
        case 1:
            splashImage = @"Stars";
            break;
        case 2:
            splashImage = @"Balloon";
            break;
        default:
            splashImage = @"bg_carpet";
            loop = 0;
            break;
    }
    UIImageView *newView = [[UIImageView alloc] initWithImage:
                            [UIImage imageNamed:splashImage]];
    newView.userInteractionEnabled = YES;
    newView.frame = self.view.bounds;
    [scrollView addSubview:newView];
    PRPViewTransition *transView = [PRPViewTransition
                                    viewWithView:self.currentView
                                    splitInto:4];
    transView.duration = 0.8;
    [scrollView addSubview:transView];
    [self.currentView removeFromSuperview];
    self.currentView = newView;

}



#pragma mark - Button Methods
- (IBAction)ThumbBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了目录");
    ThumbViewController = [[CCThumbViewController alloc]initWithNibName:@"CCThumbViewController" bundle:Nil];
    [self presentViewController:ThumbViewController animated:YES completion:Nil];
}


- (IBAction)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
    shareActionSheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到新浪微博" otherButtonTitles:@"分享到腾讯微博", nil];
    [shareActionSheet showInView:self.view];
}


- (IBAction)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
    CommentViewController = [[CCCommentViewController alloc]initWithNibName:@"CCCommentViewController" bundle:Nil];
    [self presentViewController:CommentViewController animated:YES completion:Nil];
}

- (IBAction)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Gesture Methods
-(void)pageSelected:(UITapGestureRecognizer *)sender{
    if (isToolbarHidden) {
        isToolbarHidden = NO;
    }else if(!isToolbarHidden){
        isToolbarHidden = YES;
    }
    [Toolbar setHidden:isToolbarHidden];
}

#pragma mark - LifeCycle Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self preferredStatusBarStyle];
    //scrollView显示期刊内容
    CGRect scrollViewFrame = CGRectMake(0, 20, 320, 548);
    scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor grayColor];

    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
    [scrollView addGestureRecognizer:tap1];
    
    //scrollViewTransition框架代码
    self.currentView = [[UIImageView alloc] initWithImage:
                        [UIImage imageNamed:@"bg_carpet"]];
    [scrollView addSubview:self.currentView];
    self.currentView.frame = self.view.bounds;
    self.currentView.userInteractionEnabled = YES;
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(swiped:)];
    [scrollView addGestureRecognizer:swipe];
    swipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view insertSubview:scrollView atIndex:0];
//    [self.view insertSubview:scrollView belowSubview:self.view];

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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}
@end
