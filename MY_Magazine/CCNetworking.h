//
//  CCNetworking.h
//  MY_Magazine
//
//  Created by Ken on 13-11-26.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
@class CCMagazineDock,CCMagazineTopic;
@interface CCNetworking : NSObject

@property (nonatomic,strong) NSString * RequestXMLPath;
@property (nonatomic,strong) CCMagazineDock * magazineDock;
@property (nonatomic,strong) NSMutableArray * magazineDockArr;
@property (nonatomic,retain) NSURL * ListURL;//存放List.xml服务器URL
@property (nonatomic,retain) NSString * LocalListPath;//存放List.xml本地路径
@property (nonatomic,strong) NSString * resourcePath;//存放解压后的文件路径

-(NetworkStatus)checkNetwork;
-(BOOL)checkListXMLexist;
-(void)downloadXMLList;
-(void)downloadFileFrom:(NSURL *)URL intoPath:(NSString * )path;//根据url下载文件
-(void)downloadThumbPackageImages:(NSMutableArray *)URLArray WithPath:(NSString * )LocalPath And:(NSMutableArray *)ThumbName;
-(void)downloadImageZipIntoPath:(NSString *)LocalPath WithURL:(NSMutableArray *)URLArray And:(NSMutableArray *)TopicZipURLArray;
-(void)downloadFileFrom:(NSURL *)URL intoPath:(NSString * )path CreatFolderName:(NSString *)FolderName;

-(NSMutableArray *)useDOMXMLParser;
-(CCMagazineTopic *)ParserContentListXMLWithPath:(NSString * )path;

@end
