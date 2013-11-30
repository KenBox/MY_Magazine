//
//  DEMOSecondViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
/**
 *  description:        关于我们界面
 */

#import "DEMOSecondViewController.h"

@implementation DEMOSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //导航栏设置
    UIButton * setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupBtn setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    [setupBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    setupBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithCustomView:setupBtn];
    self.navigationItem.leftBarButtonItem = btn;
    //导航栏的图片设置
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [bgImg setImage:[UIImage imageNamed:@"navbar_logo"]];
    self.navigationItem.titleView = bgImg;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_wood"] forBarMetrics:UIBarMetricsDefault];
    
    //
    
    
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


@end
