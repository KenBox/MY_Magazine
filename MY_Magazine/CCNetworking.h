//
//  CCNetworking.h
//  MY_Magazine
//
//  Created by Ken on 13-11-26.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CCMagazineDock;
@interface CCNetworking : NSObject

@property (nonatomic,strong) NSString * RequestXMLPath;
@property (nonatomic,strong) CCMagazineDock * magazineDock;
@property (nonatomic,strong) NSMutableArray * magazineDockArr;
@property (nonatomic,retain) NSURL * ListURL;//存放List.xml服务器URL
@property (nonatomic,retain) NSString * LocalListPath;//存放List.xml本地路径

-(void)checkNetwork;
-(BOOL)checkListXMLexist;
-(BOOL)checkLocalImagesExist:(NSString *)imageName;
-(void)downloadXMLList;
-(void)downloadByURL:(NSURL *)url WithPath:(NSString *)path;//根据url下载文件
-(NSMutableArray *)useDOMXMLParser;

@end
