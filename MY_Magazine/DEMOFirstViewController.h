//
//  DEMOFirstViewController.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import "PullToRefreshViewController.h"
#import "MBProgressHUD.h"
@class CCContentViewController;
@interface DEMOFirstViewController : UIViewController<MBProgressHUDDelegate>{
    MBProgressHUD *HUD;
}

@property (nonatomic,strong) CCContentViewController * ContentViewController;
@property (strong, nonatomic) UIActivityIndicatorView *activity;
@property (strong, nonatomic) UIView * activityView;
@property (strong, nonatomic) UILabel * activityLbl;
@property (strong, nonatomic) UITableView * tableView;
-(NSMutableArray *)analyseSrc:(NSArray *)array;
@end
