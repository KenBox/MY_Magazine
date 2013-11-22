//
//  CCContentViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-22.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCContentViewController.h"

@interface CCContentViewController ()

@end

@implementation CCContentViewController
@synthesize back;

-(void)backBtnPressed:(UIButton *)sender{
    [back setBackgroundColor:[UIColor yellowColor]];
    [self dismissViewControllerAnimated:YES completion:Nil];
}

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
    back = [UIButton buttonWithType:UIButtonTypeSystem];
    [back setFrame:CGRectMake(40, 40, 240, 40)];
    [back setBackgroundColor:[UIColor redColor]];
    [back setTitle:@"按这里返回" forState:UIControlStateNormal];

    [back addTarget:self action:@selector(backBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:back];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
