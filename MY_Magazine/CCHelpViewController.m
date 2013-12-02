//
//  CCHelpViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-29.
//  Copyright (c) 2013年 Ken. All rights reserved.
//
/**
 *  description:        帮助界面
 */

#import "CCHelpViewController.h"
#import "RESideMenu.h"

@interface CCHelpViewController ()

@end

@implementation CCHelpViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setAutoresizesSubviews:YES];
    
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

    //添加操作指南的图片
    UIImage * helpImg = [UIImage imageNamed:@"ver-0.jpg"];
    UIImageView * helpImgView = [[UIImageView alloc]initWithImage:helpImg];
    [helpImgView setFrame:[UIScreen mainScreen].bounds];
    [helpImgView setContentMode:UIViewContentModeScaleAspectFill];

    
    [self.view addSubview:helpImgView];
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
