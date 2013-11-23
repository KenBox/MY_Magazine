//
//  CCCommentViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-23.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCCommentViewController.h"

@interface CCCommentViewController ()

@end

@implementation CCCommentViewController
- (IBAction)BackBtnPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self preferredStatusBarStyle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
