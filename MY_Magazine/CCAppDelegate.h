//
//  CCAppDelegate.h
//  MY_Magazine
//
//  Created by Ken on 13-11-20.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface CCAppDelegate : UIResponder  <UIApplicationDelegate, RESideMenuDelegate>{
    
    UIImageView *zView;//Z图片ImageView
    UIImageView *fView;//F图片ImageView
    
    
    UIView *rView;//图片的UIView
}

@property (strong, nonatomic) UIWindow *window;


@end
