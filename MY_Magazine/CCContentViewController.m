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
#import "Utilities.h"
#import "LeavesView.h"
#import "AllDefineHeader.h"
@interface CCContentViewController ()<UIActionSheetDelegate,UIToolbarDelegate>

@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *HomeBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *CommentBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ShareBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ThumbBtn;

@property (assign, nonatomic) BOOL isToolbarHidden;
@property (strong, nonatomic) UIActionSheet * shareActionSheet;
@property (strong, nonatomic) NSArray * BarItems;
//leaves框架
@property (readonly) NSArray *images;
@end

@implementation CCContentViewController

@synthesize shareActionSheet,CommentViewController,ThumbViewController,ContentTopic;
@synthesize BarItems,Toolbar,HomeBtn,CommentBtn,ShareBtn,ThumbBtn,isToolbarHidden;

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
- (IBAction)ThumbBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了目录");
    ThumbViewController = [[CCThumbViewController alloc]initWithNibName:@"CCThumbViewController" bundle:Nil];
    [self presentViewController:ThumbViewController animated:YES completion:Nil];
}
- (IBAction)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");
    [self dismissViewControllerAnimated:YES completion:Nil];
}
- (IBAction)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
    CommentViewController = [[CCCommentViewController alloc]initWithNibName:@"CCCommentViewController" bundle:Nil];
    [self presentViewController:CommentViewController animated:YES completion:Nil];
}
- (IBAction)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
    shareActionSheet = [[UIActionSheet alloc]initWithTitle:Nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享到新浪微博" otherButtonTitles:@"分享到腾讯微博", nil];
    [shareActionSheet showInView:self.view];

}

#pragma mark - Gesture Methods

-(void)pageSelected:(UITapGestureRecognizer *)sender{
    NSLog(@"tap.....");
    //增加隐藏toolbar动画
    CATransition *trans=[CATransition animation];
    trans.type=kCATransitionPush;
    
    trans.duration=0.5;

    if (isToolbarHidden) {
        isToolbarHidden = NO;
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
        ContentTopic = [[CCMagazineTopic alloc]init];
		_images = [[NSArray alloc] initWithObjects:
                   [UIImage imageNamed:@"Stars"],
                   [UIImage imageNamed:@"Balloon"],
                   [UIImage imageNamed:@"bg_carpet"],
                   nil];
        if (!IS_4_INCH) {
            [Toolbar setFrame:CGRectMake(0, APP_SCREEN_CONTENT_HEIGHT/2-44, APP_SCREEN_WIDTH, APP_SCREEN_HEIGHT/2)];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [Toolbar setFrame:CGRectMake(0.0, self.view.frame.size.height - Toolbar.frame.size.height - 44.0, self.view.frame.size.width, 44.0)];
    [Toolbar setBarStyle:UIBarStyleDefault];
    Toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    NSLog(@"currentDevice = %@",[UIDevice currentDevice].model);
    [Toolbar setHidden:YES];
    isToolbarHidden = YES;

    NSLog(@"width = %f,height = %f",APP_SCREEN_WIDTH,APP_SCREEN_HEIGHT);

    // Do any additional setup after loading the view from its nib.
    //Tap手势显示及隐藏Toolbar
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                           action:@selector(pageSelected:)];
    [self.leavesView addGestureRecognizer:tap1];
    [self.view insertSubview:self.leavesView atIndex:0];

}



-(void)viewWillAppear:(BOOL)animated{
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
