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
@class CCContentViewController;
@interface DEMOFirstViewController : PullToRefreshViewController

@property (nonatomic,strong) CCContentViewController * ContentViewController;
@end
