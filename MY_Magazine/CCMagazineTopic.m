//
//  CCMagazineTopic.m
//  MY_Magazine
//
//  Created by Ken on 13-11-30.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCMagazineTopic.h"

@implementation CCMagazineTopic
@synthesize CoverPath,CoverThumbName,ThumbName,TopicPath;
@synthesize FrontCoverZipURL,ThumbImages,ContectImages;

- (id)init
{
    self = [super init];
    if (self) {
        CoverPath = @"";
        ThumbName = [[NSMutableArray alloc]init];
        TopicPath = [[NSMutableArray alloc]init];
        ThumbImages = [[NSMutableArray alloc]init];
        ContectImages = [[NSMutableArray alloc]init];
    }
    return self;
}

-(id)initWithObject:(CCMagazineTopic *)topic{
    self = [super init];
    if(self){
        CoverPath = topic.CoverPath;
        ContectImages = [[NSMutableArray alloc]initWithArray:topic.ContectImages];
        ThumbImages = [[NSMutableArray alloc]initWithArray:topic.ThumbImages];
    }
    return self;
}
@end
