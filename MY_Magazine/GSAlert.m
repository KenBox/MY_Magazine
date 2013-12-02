//
//  GSAlert.m
//  GSPublishSystem
//
//  Created by Baoyifeng on 12-3-15.
//  Copyright 2012 Glavesoft. All rights reserved.
//

#import "GSAlert.h"


@implementation GSAlert

+ (void)showAlertWithTitle:(NSString *)title {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
	[alert show];
	//[alert release];
}

@end
