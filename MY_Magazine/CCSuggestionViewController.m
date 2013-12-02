//
//  CCSuggestionViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-20.
//  Copyright (c) 2013年 Ken. All rights reserved.
//
/**
 *  description:        意见反馈页面
 */
#import "CCSuggestionViewController.h"
#import "RESideMenu.h"

@interface CCSuggestionViewController ()

@end

@implementation CCSuggestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    //导航栏设置
    UIButton * setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupBtn setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    [setupBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    setupBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithCustomView:setupBtn];
    self.navigationItem.leftBarButtonItem = btn;
    //导航栏左侧图片
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [bgImg setImage:[UIImage imageNamed:@"navbar_logo"]];
    self.navigationItem.titleView = bgImg;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_wood"] forBarMetrics:UIBarMetricsDefault];
    //插入背景图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = [UIImage imageNamed:@"bg_carpet"];
    [self.view addSubview:imageView];
    //两个label
    UILabel * AboutUsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, 280, 40)];
    [AboutUsLabel setText:@"意见反馈"];
    [AboutUsLabel setTextAlignment:NSTextAlignmentCenter];
    UILabel * AboutUsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 60, 280, 40)];
    [AboutUsLabel2 setText:@"联系邮箱xxx@163.com"];
    [AboutUsLabel2 setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:AboutUsLabel];
    [self.view addSubview:AboutUsLabel2];
    
    
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
