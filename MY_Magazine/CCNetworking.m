//
//  CCNetworking.m
//  MY_Magazine
//
//  Created by Ken on 13-11-26.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCNetworking.h"
#import "Reachability.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "CCMagazineDock.h"
#import "FileOperation.h"
#import "GSAlert.h"
#define _HOSTURL @"http://localhost:8080/naill/upload/"
#define _LISTXMLURL @"http://localhost:8080/naill/upload/List.xml"
@interface CCNetworking ()

@end


@implementation CCNetworking
@synthesize RequestXMLPath,magazineDock,magazineDockArr;

-(void)checkNetwork{
    Reachability * reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            NSLog(@"wifi连接");
            [self downloadXMLList];
            break;
        case ReachableViaWWAN:
            NSLog(@"3G连接");
            [self downloadXMLList];
            break;
        case NotReachable:
            NSLog(@"无连接");
            [self checkListXMLexist];
            break;
        default:
            break;
    }
}

-(void)checkListXMLexist{
    //1.得到沙箱中的Documents目录路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.指定下载到沙箱中的文件名称
    path = [path stringByAppendingPathComponent:@"List.xml"];
    RequestXMLPath = [NSString stringWithString:path];
//    NSLog(@"RequestXMLPath = %@",RequestXMLPath);
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithString:path];
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
        NSLog(@"List.xml is not exist!");
        //        NSString *dataPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingString:@"/List.xml"];//获取程序包中相应文件的路径
        [self downloadXMLList];
        
        NSLog(@"download List.xml complete!");
    }else{
        NSLog(@"List.xml is exist!");
        [self downloadXMLList];
        NSLog(@"List.xml refresh!");
    }
//    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"List.xml" ofType:nil inDirectory:nil];
}

//下载XML文件和XML地址中的图片
-(void)downloadXMLList{
    //1.得到沙箱中的Documents目录路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.指定下载到沙箱中的文件名称
    path = [path stringByAppendingPathComponent:@"List.xml"];
    NSLog(@"%@",path);
    //3.生成url
    NSURL * url = [NSURL URLWithString:_LISTXMLURL];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    //4.设置下载参数
    [request setDownloadDestinationPath:path];
    //显示下载进度
    //    [request setDownloadProgressDelegate:<#(id)#>];
    //5.发出请求
    [request startSynchronous];

    
    [self downloadImage:request withPath:path];
}


-(void)downloadImage:(NSString *)imageURL withImageName:(NSString *)imageName{
    
    //1.得到沙箱中的Documents目录路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.指定下载到沙箱中的文件名称
    path = [path stringByAppendingPathComponent:imageName];
    //3.生成url
    NSURL * url = [NSURL URLWithString:imageURL];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [self downloadImage:request withPath:path];
}

-(void)downloadImage:(ASIHTTPRequest *)request withPath:(NSString *)path{
    int statusCode = [request responseStatusCode];
    NSLog(@"statusCode = %d",statusCode);
    switch (statusCode) {
        case 0://本地服务器会返回0
            NSLog(@"服务器响应成功");
            if ([FileOperation fileExistsAtPath:path]) {
                NSLog(@"文件已存在");
                break;
            }else{
                //4.设置下载参数
                [request setDownloadDestinationPath:path];
                //显示下载进度
                //    [request setDownloadProgressDelegate:];
                //5.发出请求
                [request startSynchronous];
                NSLog(@"文件图片成功");
            }
            break;
        case 200:
            if ([FileOperation fileExistsAtPath:path]) {
                NSLog(@"文件已存在");
                break;
            }else{
                //4.设置下载参数
                [request setDownloadDestinationPath:path];
                //显示下载进度
                //    [request setDownloadProgressDelegate:];
                //5.发出请求
                [request startSynchronous];
                NSLog(@"下载文件成功");
            }
            break;
        case 404:
            NSLog(@"服务器没有找到你指定的路径");
            [GSAlert showAlertWithTitle:@"文件下载失败"];
            break;
        case 500:
            NSLog(@"服务器端出错");
            [GSAlert showAlertWithTitle:@"文件下载失败"];
            break;
        default:
            break;
    }
    
    
}


/*
//书店xml解析
- (void)getStoreMapFromXmlSource:(NSURL *)xmlUrl
{
    NSData *xmlData = nil;
    xmlData = [NSData dataWithContentsOfURL:xmlUrl];
    self.storeMap = [[NSMutableArray alloc] init];
    self.magazinesInfoArr = [[NSMutableArray alloc] init];
    self.selectedYears = [[NSMutableArray alloc] init];
    self.magazinesDic = [[NSMutableDictionary alloc] init];
    __block NSString *suffix_year;
    //    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData error:nil];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:Nil];
    
    GDataXMLElement *rootElement = [doc rootElement];
    NSArray *years = [rootElement elementsForName:@"year"];
    [years enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        GDataXMLElement *year = obj;
        suffix_year = [[year attributeForName:@"value"] stringValue];
        [self.selectedYears addObject:suffix_year];
        NSLog(@"selectedYears is %@",self.selectedYears);
        //记录每年的期刊
        NSMutableArray  *magazinesArray = [[NSMutableArray alloc] initWithCapacity:0];
        //Month
        NSArray *months = [year elementsForName:@"Month"];
        [months enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            //按月初始化书架对象
            GSShelfItemInfo *shelfInfo = [[GSShelfItemInfo alloc] init];
            GDataXMLElement *month = obj;
            shelfInfo.year = suffix_year;
            shelfInfo.month = [[[[month attributeForName:@"value"] stringValue] componentsSeparatedByString:@"."] objectAtIndex:1];
            //periodical
            GDataXMLElement *periodical = [[month elementsForName:@"Periodical"] objectAtIndex:0];
            shelfInfo.periodicalNumber = [periodical stringValue];
            
            //Title
            GDataXMLElement *title = [[month elementsForName:@"Title"] objectAtIndex:0];
            shelfInfo.title = [title stringValue];
            
            //Synopsis 简介
            GDataXMLElement *synopsis = [[month elementsForName:@"Synopsis"] objectAtIndex:0];
            shelfInfo.synopsis = [synopsis stringValue];
            
            //frontCover
            GDataXMLElement *frontCover = [[month elementsForName:@"FrontCover"] objectAtIndex:0];
            shelfInfo.imageName = [frontCover stringValue];
            
            //catalogCover
            GDataXMLElement *catalogCover = [[month elementsForName:@"CatalogCover"] objectAtIndex:0];
            shelfInfo.catalogImageName = [catalogCover stringValue];
            
            //Ppath
            GDataXMLElement *ppath = [[month elementsForName:@"Ppath"] objectAtIndex:0];
            shelfInfo.contentXmlPath = [ppath stringValue];
            
            //封面子标题
            shelfInfo.subTitle = [NSString stringWithFormat:@"%@年%@月第%@期",shelfInfo.year,shelfInfo.month, shelfInfo.periodicalNumber];
            //封面图片路径
            shelfInfo.imageUrl = [NSString stringWithFormat:@"%@/%@/%@%@/%@%@_%@/ThumbPackage/%@",kResouceDownloadURL,shelfInfo.year,shelfInfo.year,shelfInfo.month,shelfInfo.year,shelfInfo.month,shelfInfo.periodicalNumber,shelfInfo.imageName];
            //字典 按年分类  magazinesInfoArr 删除
            [magazinesArray addObject:shelfInfo];
            
        }];
        //每年后 add
        [self.magazinesDic setObject:magazinesArray forKey:suffix_year];
    }];
    //多个年份 按年排序
    //    NSArray *keys = [self.magazinesDic allKeys];
    //    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
    //        return [obj1 compare:obj2 options:NSNumericSearch];
    //    }];
    // NSDictionary *myDic = [self.magazinesDic objectForKey:[sortedArray objectAtIndex:0]];
    NSLog(@"magazinesInfoArr list:%@",self.magazinesDic);
}
*/

#pragma mark - 使用DOM解析器解析XML
//返回解析的结果，保存在一个集合对象中
-(NSMutableArray *)useDOMXMLParser
{
    //定义一个空的可边长度的集合
    NSMutableArray *mutArr =[[NSMutableArray alloc]init];
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.指定下载到沙箱中的文件名称
    path = [path stringByAppendingPathComponent:@"List.xml"];

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
            //解析完成并下载图片
            magazineDock.FrontCoverURL = [self getFrontCoverURLString:magazineDock];
            [self downloadImage:magazineDock.FrontCoverURL withImageName:magazineDock.FrontCover];
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


-(id)init{
    self = [super init];
    if (self) {
        magazineDockArr = [[NSMutableArray alloc]init];
    }
    return self;
}
@end


