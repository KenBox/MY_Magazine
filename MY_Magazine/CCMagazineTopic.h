//
//  CCMagazineTopic.h
//  MY_Magazine
//
//  Created by Ken on 13-11-30.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCMagazineTopic : NSObject
@property (nonatomic,strong) NSString * CoverPath;
@property (nonatomic,strong) NSString * FrontCoverZipURL;
@property (nonatomic,strong) NSString * CoverThumbName;
@property (nonatomic,strong) NSMutableArray * ThumbName;//存放了所有Thumb的.jpg /***URL地址***/
@property (nonatomic,strong) NSMutableArray * TopicPath;//存放了所有Topic的.zip /***URL地址***/
@property (nonatomic,strong) NSString * LocalThumbPackage;//本地Thumb图片存放路径
@property (nonatomic,strong) NSMutableArray * LocalTopicPath;
@property (nonatomic,strong) NSString * LocalFolderName;

@property (nonatomic,strong) NSMutableArray * ThumbImages;//存放目录页图片的集合
@property (nonatomic,strong) NSMutableArray * ContectImages;//存放内容页图片的集合
@end
