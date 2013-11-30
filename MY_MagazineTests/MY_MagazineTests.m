//
//  MY_MagazineTests.m
//  MY_MagazineTests
//
//  Created by Ken on 13-11-20.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "GDataXMLNode.h"
#import "CCMagazineTopic.h"
#define _HOSTURL @"http://192.168.1.4:8080/naill/upload/"

@interface MY_MagazineTests : XCTestCase

@end

@implementation MY_MagazineTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
//    CCMagazineTopic * topic = [[CCMagazineTopic alloc]init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
    NSLog(@">>>>>>>>>>ContentListXML解析开始>>>>>>>>>>>>>");
    NSString * path = @"/Users/Ken/Library/Application Support/iPhone Simulator/7.0.3/Applications/196BD667-57D7-4056-9040-F04CA9E6BD2C/Documents/ContentList.xml";
    //把文件中的内容读取到 NSData 中
    NSString *docXML =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:Nil];
    
    //锅炉方式解析 XML (把所有内容全部倒入解析器)
    //预备一个 错误处理对象
    NSError *error = nil;
    //新建一个代表 XML 文档对象，代表所有 XML 文档内容
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:docXML options:0 error:&error];
    //document 对象，包含所有的 xml 内容
    //按照索引找到具体的某个 标签(元素 Elements)
    //1 先找整个树的根节点
    GDataXMLElement *root = [document rootElement];
    NSLog(@"根节点名称 %@",[root name]);
    //解析xml文件
    //    GDataXMLElement *xmlEle = [xmlDoc rootElement];
    NSArray *array = [root children];
    //    NSLog(@"count : %lu", (unsigned long)[array count]);
    CCMagazineTopic * Content = [[CCMagazineTopic alloc]init];
    for (GDataXMLNode * obj in array) {
        for (GDataXMLElement * subObj in [obj children]) {
            if ([subObj.name isEqualToString:@"CoverPage"]) {
                Content.CoverPath = [[subObj attributeForName:@"CoverPath"]stringValue];
                Content.LocalFolderName = [self getLocalFolderName:Content.CoverPath];
                Content.FrontCoverZipURL = [self getFrontCoverZipURL:Content.CoverPath];
                NSLog(@"zipurl = %@",Content.FrontCoverZipURL);
                Content.CoverThumbName = [[subObj attributeForName:@"ThumbName"]stringValue];
            }else if ([subObj.name isEqualToString:@"Topic"]){
//                [Content.ThumbName addObject:[[subObj attributeForName:@"ThumbName"]stringValue]];
                NSString * Thumb = [[subObj attributeForName:@"ThumbName"]stringValue];
                NSString * ThumbURL = [self getThumbNameURL:Thumb WithPath:Content.CoverPath];
                [Content.ThumbName addObject:ThumbURL];
                NSString * TopicPath =[[subObj attributeForName:@"TopicPath"]stringValue];
                NSString * zipPath = [self getTopicPathZipURL:TopicPath];
                [Content.TopicPath addObject:zipPath];
            }
        }
    }

    NSLog(@">>>>>>>>>>ContentListXML解析结束>>>>>>>>>>>>");
    for (NSString * obj in Content.TopicPath) {
//        NSLog(@".zip地址 = %@",obj);
    }

//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

-(NSString *)getLocalFolderName:(NSString *)CoverPath{
    NSArray * aaa = [CoverPath componentsSeparatedByString:@"/"];
    NSString * resault = [NSString stringWithString:[aaa objectAtIndex:2]];
    NSLog(@"LocalFolderName = %@",resault);
    return resault;
}

-(NSString *)getThumbNameURL:(NSString *)ThumbName WithPath:(NSString *)CoverPath{
    NSArray * aaa = [CoverPath componentsSeparatedByString:@"/"];
    NSString * resault = [NSString stringWithFormat:@"%@%@/%@/%@/ThumbPackage/%@",_HOSTURL,[aaa objectAtIndex:0],[aaa objectAtIndex:1],[aaa objectAtIndex:2],ThumbName];
//    NSLog(@"temp = %@",resault);
    return resault;
}

-(NSString *)getTopicPathZipURL:(NSString *)TopicPath{
//    TopicPath = @"2014/201402/201402_1/2014_02_1385689648252/2014_02_1385689648252.html";
        NSString * temp = [NSString stringWithFormat:@"%@%@",_HOSTURL,TopicPath];
    NSMutableString * subStr = [NSMutableString stringWithString:[temp substringToIndex:(temp.length-5)]];
        [subStr appendString:@".zip"];
        NSString * resault = [NSString stringWithString:subStr];
//        NSLog(@"Resault = %@",resault);
    return resault;
}

-(NSString *)getFrontCoverZipURL:(NSString *)CoverPath{
        NSString * temp = [NSString stringWithFormat:@"%@%@",_HOSTURL,CoverPath];
        NSArray * subStr = [temp componentsSeparatedByString:@"/"];
        NSMutableArray * removeLast = [NSMutableArray arrayWithArray:subStr];
        [removeLast removeLastObject];
        NSString * joinStr = [removeLast componentsJoinedByString:@"/"];
        NSString * resault = [NSString stringWithFormat:@"%@.zip",joinStr];
        return resault;
}


@end
