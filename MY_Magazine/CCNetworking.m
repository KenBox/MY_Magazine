//
//  CCNetworking.m
//  MY_Magazine
//
//  Created by Ken on 13-11-26.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "CCNetworking.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "CCMagazineDock.h"
#import "FileOperation.h"
#import "GSAlert.h"
#define _HOSTURL @"http://218.4.19.242:8089/naill/upload/"
#define _LISTURL @"http://218.4.19.242:8089/naill/upload/List.xml"

//#define _HOSTURL @"http://192.168.2.133:8080/naill/upload/"
//#define _LISTURL @"http://192.168.2.133:8080/naill/upload/List.xml"


@interface CCNetworking ()

@end


@implementation CCNetworking

@synthesize RequestXMLPath,magazineDock,magazineDockArr,ListURL,LocalListPath;

//检查网络状况
-(NetworkStatus)checkNetwork{
    Reachability * reach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([reach currentReachabilityStatus]) {
        case ReachableViaWiFi:
            NSLog(@"checkNetwork >>> wifi连接");
            return ReachableViaWiFi;
        case ReachableViaWWAN:
            NSLog(@"checkNetwork >>> 3G连接");
            //使用3G更新XML数据
            return ReachableViaWWAN;
        case NotReachable:
            NSLog(@"checkNetwork >>> 无连接");
            //无网络则检查本地xml是否存在
            //不存在需要提示用户无法显示信息
            if ([self checkListXMLexist]==NO) {
                [GSAlert showAlertWithTitle:@"没有网络连接,可能无法正常显示图片"];
                return NotReachable;
            }else{
                //若存在本地list文件则解析本地数据
//                [self useDOMXMLParser];
                return NotReachable;
            }
    }
    return -1;
}

//检查本地List.xml文件是否存在，若不存在需要下载
-(BOOL)checkListXMLexist{
    if(![FileOperation fileExistsAtPath:LocalListPath]) //如果不存在
    {
        NSLog(@"List.xml is not exist!");
        return NO;
    }else{
        NSLog(@"List.xml is exist!");
        return YES;
    }
}

//检测Documents文件夹中是否已经存在先前下载的图片
-(BOOL)checkLocalImagesExist:(NSString *)imageName{
    return [FileOperation fileExistsAtPath:imageName];
}


//下载XML文件和XML地址中的图片
-(void)downloadXMLList{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:ListURL];
    [request setDownloadDestinationPath:LocalListPath];
    [request startSynchronous];
}

-(void)downloadByURL:(NSURL *)url WithPath:(NSString *)path{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:path];
    [request startSynchronous];
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
                NSLog(@"%@文件已存在",path);
                break;
            }else{
                [request setDownloadDestinationPath:path];
                [request startSynchronous];
                NSLog(@"下载文件成功");
            }
            break;
        case 200:
            if ([FileOperation fileExistsAtPath:path]) {
                NSLog(@"%@文件已存在",path);
                break;
            }else{
                //4.设置下载参数
                [request setDownloadDestinationPath:path];
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

#pragma mark - 使用DOM解析器解析XML
//返回解析的结果，保存在一个集合对象中
-(NSMutableArray *)useDOMXMLParser
{
    NSLog(@">>>>>>>>>>XML解析开始>>>>>>>>>>>>>");
    NSMutableArray * mutArr = [[NSMutableArray alloc]init];
    //把文件中的内容读取到 NSData 中
    NSString *docXML =[NSString stringWithContentsOfFile:LocalListPath encoding:NSUTF8StringEncoding error:Nil];
    
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
    
    //List.xml为3层树状结构
    for (int i = 0; i < [array count]; i++) {
        //        NSLog(@"=======这里是第一层循环========");
        GDataXMLNode * ele = [array objectAtIndex:i];
        for (int j = 0; j< [ele childCount]; j++) {
            //            NSLog(@"=======这里是第二层循环========");
            GDataXMLNode * subEle = [[ele children]objectAtIndex:j];
            //创建Model对象存取数据
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
                        //<CatalogCover/>标签无用，直接跳过
                        break;
                    case 6:
                        magazineDock.Ppath = [NSString stringWithString:[ssubEle stringValue]];
                        break;
                    default:
                        break;
                }
            }
            //拼接FrontCoverURL方法
            magazineDock.FrontCoverURL = [self getFrontCoverURLString:magazineDock];
            //先检测图片是否已经存在
            BOOL isDownload = [self checkLocalImagesExist:magazineDock.FrontCover];
            //结果为 NO 则下载图片
            if (!isDownload) {
                [self downloadImage:magazineDock.FrontCoverURL withImageName:magazineDock.FrontCover];
            }
            //把对象存入集合mutArr
            [mutArr addObject:magazineDock];
        }
    }
    
    NSLog(@">>>>>>>>>>XML解析结束>>>>>>>>>>>>");
    return  mutArr;
}

//拼接FrontCover字符串
-(NSString *)getFrontCoverURLString:(CCMagazineDock *)obj{
    NSString * str = [NSString stringWithFormat:_HOSTURL];
    NSArray * subPpath = [obj.Ppath componentsSeparatedByString:@"/"];
    NSMutableArray * temp = [NSMutableArray arrayWithObjects:[subPpath objectAtIndex:0],[subPpath objectAtIndex:1],[subPpath objectAtIndex:2], nil];
    NSString * joinStr = [temp componentsJoinedByString:@"/"];
    NSString * path = [NSString stringWithFormat:@"/ThumbPackage/"];
    NSString * combineStr = [NSString stringWithFormat:@"%@%@%@%@",str,joinStr,path,obj.FrontCover];
    NSMutableString * resault = [NSMutableString stringWithString:combineStr];
//    NSLog(@"FrontCoverURLString = %@",resault);
    return resault;
}



-(id)init{
    self = [super init];
    if (self) {
        NSLog(@"NetworkingManager init...");
        magazineDockArr = [[NSMutableArray alloc]init];
        //1.得到沙箱中的Documents目录路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //2.指定下载到沙箱中的文件名称
        path = [path stringByAppendingPathComponent:@"List.xml"];
        ListURL = [NSURL URLWithString:_LISTURL];
        NSLog(@"ListURL = %@",ListURL);
        LocalListPath = [NSString stringWithString:path];
        NSLog(@"LocalListPath = %@",LocalListPath);
    }
    return self;
}

@end


