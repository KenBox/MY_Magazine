//
//  CCXMLParser.m
//  MY_Magazine
//
//  Created by Ken on 13-11-27.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCXMLParser.h"
#import "GDataXMLNode.h"
#import "CCMagazineDock.h"

@implementation CCXMLParser
/*

#pragma mark - 使用DOM解析器解析XML
//返回解析的结果，保存在一个集合对象中
-(NSMutableArray *)useDOMXMLParser
{
    //定义一个空的可边长度的集合
    NSMutableArray *mutArr =[[NSMutableArray alloc]init];
    //把文件中的内容读取到 NSData 中
    NSString *docXML =[NSString stringWithContentsOfFile:RequestXMLPath encoding:NSUTF8StringEncoding error:Nil];
    
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
    NSLog(@"count : %d", [array count]);
    
    
    for (int i = 0; i < [array count]; i++) {
        //        NSLog(@"=======这里是第一层循环========");
        //Year Element
        
        //        GDataXMLElement *ele = [array objectAtIndex:i];
        GDataXMLNode * ele = [array objectAtIndex:i];
        //        NSLog(@"ele name = %@",[ele name]);
        // 根据标签名判断
        //        if ([[ele name] isEqualToString:@"year"]) {
        //            // 读标签里面的属性
        //            NSString * str = [NSString stringWithString:[ele stringValue]];
        //        }
        for (int j = 0; j< [ele childCount]; j++) {
            //            NSLog(@"=======这里是第二层循环========");
            
            //Month Element
            GDataXMLNode * subEle = [[ele children]objectAtIndex:j];
            magazineDock = [[CCMagazineDock alloc]init];
            for (int k = 0 ; k<[subEle childCount]; k++) {
                GDataXMLElement * ssubEle = [[subEle children]objectAtIndex:k];
                switch (k) {
                    case 0:
                        magazineDock.Periodical = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    case 1:
                        magazineDock.WholePeriodical = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    case 2:
                        magazineDock.Title = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    case 3:
                        magazineDock.Synopsis = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    case 4:
                        magazineDock.FrontCover = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    case 5:
                        
                        break;
                    case 6:
                        magazineDock.Ppath = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    default:
                        break;
                }
                
                
            }
            //增加dock.FrontCoverURL属性;
            magazineDock.FrontCoverURL = [self getFrontCoverURLString:magazineDock];
            //把对象存入集合mutArr,并增加缩略图地址
            [mutArr addObject:magazineDock];
        }
    }
    //    NSLog(@"%@",[mutArr objectAtIndex:0]);
    return  mutArr;
}

//拼接FrontCover字符串
-(NSString *)getFrontCoverURLString:(CCMagazineDock *)obj{
    NSMutableString * str = [NSMutableString stringWithFormat:_HOSTURL];
    [str appendString:obj.Ppath];
    NSString * newstr = [str substringToIndex:(str.length-12)];
    NSString * path = [NSString stringWithFormat:@"/ThumbPackage/"];
    NSMutableString * resault = [NSMutableString stringWithString:newstr];
    [resault appendString:path];
    [resault appendString:obj.FrontCover];
    return resault;
}

*/

@end
