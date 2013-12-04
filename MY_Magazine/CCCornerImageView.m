//
//  CCCornerImageView.m
//  MY_Magazine
//
//  Created by Ken on 13-12-3.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCCornerImageView.h"

@implementation CCCornerImageView
@synthesize CornerImgView;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CornerImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mag_status_ok"]];
        [self addSubview:CornerImgView];
    }
    return self;
}

-(void)downloadAnimation{
    //开场动画
//    CornerImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    // load all the frames of our animation
    
    [UIView animateWithDuration:0.7 //速度0.7秒
                     animations:^{//修改rView坐标
                         CornerImgView.animationImages = [NSArray arrayWithObjects:
                                                         [UIImage imageNamed:@"mag_status_page1"],
                                                         [UIImage imageNamed:@"mag_status_page2"],
                                                         [UIImage imageNamed:@"mag_status_page3"],
                                                         [UIImage imageNamed:@"mag_status_page4"],
                                                         nil];
                         
                         // all frames will execute in 1 seconds
                         CornerImgView.animationDuration = 2.0;
                         // repeat the annimation forever
                         CornerImgView.animationRepeatCount = 0;
                         // start animating
                         [CornerImgView startAnimating];

                     }
                     completion:^(BOOL finished){
                         [CornerImgView setImage:[UIImage imageNamed:@"mag_status_ok"]];
                     }];

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
