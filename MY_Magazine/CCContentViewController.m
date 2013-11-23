//
//  CCContentViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCContentViewController.h"

@interface CCContentViewController ()
@property (strong, nonatomic) IBOutlet UIToolbar *Toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *HomeBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *CommentBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ShareBtn;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *ThumbBtn;
@property (assign, nonatomic) BOOL isToolbarHidden;
@end

@implementation CCContentViewController
@synthesize back,Toolbar,HomeBtn,CommentBtn,ShareBtn,ThumbBtn,isToolbarHidden,scrollView;

#pragma mark - Button Methods
- (IBAction)ThumbBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了目录");
}


- (IBAction)ShareBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了分享");
}


- (IBAction)CommentBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了评论");
}

- (IBAction)HomeBtnPressed:(UIBarButtonItem *)sender {
    NSLog(@"点击了Home");
    [self dismissViewControllerAnimated:YES completion:Nil];
}

-(void)backBtnPressed:(UIButton *)sender{
    [sender setBackgroundColor:[UIColor yellowColor]];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

#pragma mark - Gesture Methods
-(void)pageSelected:(UITapGestureRecognizer *)sender{
    if (isToolbarHidden) {
        isToolbarHidden = NO;
//        [self.view removeGestureRecognizer:sender];
    }else if(!isToolbarHidden){
        isToolbarHidden = YES;
//        [self.view addGestureRecognizer:sender];
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
    //顶部返回按钮，测试用
    back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setFrame:CGRectMake(40, 40, 240, 40)];
    [back setBackgroundColor:[UIColor redColor]];
    [back setTitle:@"按这里返回" forState:UIControlStateNormal];
    [back addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
    
    //期刊内容制作成一个个imageView
//    UIImageView * imageView =
    
    //scrollView显示期刊内容
    CGRect scrollViewFrame = CGRectMake(0, 20, 320, 548);
    scrollView = [[UIScrollView alloc]initWithFrame:scrollViewFrame];
    scrollView.backgroundColor = [UIColor grayColor];

    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
    [scrollView addGestureRecognizer:tap1];
    
    [self.view insertSubview:scrollView atIndex:0];


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

-(void)ToolbarHiddenAnimation{
    
}

@end
