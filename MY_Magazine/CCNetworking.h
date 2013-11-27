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
//书店Info
@property (nonatomic, strong) NSMutableArray *storeMap;
@property (nonatomic, strong) NSMutableArray *selectedYears; //解析出来的年份（切换年份用）
@property (strong, nonatomic) NSMutableArray *magazinesInfoArr;
@property (strong, nonatomic) NSMutableDictionary *magazinesDic;

-(void)checkNetwork;
-(void)checkListXMLexist;
-(void)downloadXMLList;
-(NSMutableArray *)useDOMXMLParser;

@end
