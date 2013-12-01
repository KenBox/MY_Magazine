//
//  CCNetworking.m
//  MY_Magazine
//
//  Created by Ken on 13-11-26.
//  Copyright (c) 2013年 Ken. All rights reserved.
//

#import "AllDefineHeader.h"
#import "CCNetworking.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "CCMagazineDock.h"
#import "FileOperation.h"
#import "GSAlert.h"
#import "CCMagazineTopic.h"
#import "GSBaseResource.h"
#import "ZipArchive.h"

#define _HOSTURL @"http://218.4.19.242:8089/naill/upload/"
#define _LISTURL @"http://218.4.19.242:8089/naill/upload/List.xml"

//#define _HOSTURL @"http://192.168.1.4:8080/naill/upload/"
//#define _LISTURL @"http://192.168.1.4:8080/naill/upload/List.xml"


@interface CCNetworking ()

@end


@implementation CCNetworking

@synthesize RequestXMLPath,magazineDock,magazineDockArr,ListURL,LocalListPath,resourcePath;


#pragma mark - 查看网络状况
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
                [GSAlert showAlertWithTitle:@"没有网络连接,请连接网络后启动程序"];
                return NotReachable;
            }else{
                //若存在本地list文件则解析本地数据
                [GSAlert showAlertWithTitle:@"没有网络连接,无法正常更新数据"];
                return NotReachable;
            }
    }
    return -1;
}


#pragma mark - 判断本地路径上是否已存在文件
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




#pragma mark - 文件下载方法

//下载XML文件和XML地址中的图片
-(void)downloadXMLList{
    if ([self checkNetwork]==ReachableViaWiFi||ReachableViaWWAN) {
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:ListURL];
        [request setDownloadDestinationPath:LocalListPath];
        [request startSynchronous];
    }
}

/*
 *  description:            将目录文件存放到指定的文件夹
 *  @param 参数一:           目录图片URL集合
 *  @param 参数二:           期刊在Document下存放的文件夹名称
 *  @paran 参数三:           目录图片名称集合
 */
-(void)downloadThumbPackageImages:(NSMutableArray *)URLArray WithPath:(NSString * )LocalPath And:(NSMutableArray *)ThumbName{
    NSLog(@">>>>>>>>>>>下载目录页图片>>>>>>>>>>>");
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //并给文件起个文件名
    NSString *imageDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:LocalPath];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    //*********************这里下载目录页图片***********************//
    for (int i = 0; i<[ThumbName count]; i++) {
        NSURL * imageURL = [NSURL URLWithString:[URLArray objectAtIndex:i]];
        NSString * thumbName = [NSString stringWithString:[ThumbName objectAtIndex:i]];
        NSArray * arr = [thumbName componentsSeparatedByString:@"/"];
        NSString * res = [NSString stringWithString:[arr lastObject]];
        NSString * imagePath = [imageDir stringByAppendingString:[NSString stringWithFormat:@"/%@",res]];
        //判断文件路径上是否已经存在
        if (![FileOperation fileExistsAtPath:imagePath]) {
            [self downloadFileFrom:imageURL intoPath:imagePath];
        }else{
            NSLog(@"文件已经存在");
        }
    }
    NSLog(@">>>>>>>>>>>下载目录页图片完成>>>>>>>>>>>");
}



/**
 *  description:            下载各个图片的zip包并解压
 *  @param 参数一:           期刊在Document下存放的文件夹名称
 *  @param 参数二:           Zip路径集合
 *  @paran 参数三:           暂时没有用处
 */
-(void)downloadImageZipIntoPath:(NSString *)LocalPath WithURL:(NSMutableArray *)URLArray And:(NSMutableArray *)TopicZipURLArray{
    NSLog(@">>>>>>>>>>>开始下载图片zip包>>>>>>>>>>>");
    //此处首先指定了图片存取路径（默认写到应用程序沙盒 中）
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    //并给文件起个文件名
    NSString *ZipDir = [[paths objectAtIndex:0] stringByAppendingPathComponent:LocalPath];
    //创建文件夹路径
    [[NSFileManager defaultManager] createDirectoryAtPath:ZipDir withIntermediateDirectories:YES attributes:nil error:nil];
    for (int i = 0; i<[URLArray count]; i++) {
        NSString * zipName = [URLArray objectAtIndex:i];
        NSURL * ZipURL = [NSURL URLWithString:zipName];
        NSArray * arr = [zipName componentsSeparatedByString:@"/"];
        NSString * subName = [NSString stringWithString:[arr lastObject]];
        zipName = [ZipDir stringByAppendingString:[NSString stringWithFormat:@"/%@",subName]];
        //判断路径上是否已经存在文件，不存在则下载并解压
        if (![FileOperation fileExistsAtPath:zipName]) {
            [self downloadFileFrom:ZipURL intoPath:zipName];
            [self unzipImage:zipName WithZipDir:ZipDir];
        }else{
            NSLog(@"文件已经存在");
        }
    }
    NSLog(@">>>>>>>>>>>下载图片zip包完成>>>>>>>>>>>");
}

/**
 *  description:            解压文件
 *  @param 参数一:           需要解压文件的本地路径
 *  @param 参数二:           解压后存放文件的路径
 */
-(void)unzipImage:(NSString * )FileName WithZipDir:(NSString *)ZipDir{
    ZipArchive * archive = [[ZipArchive alloc]init];
    NSLog(@">>>>>>>>>>解压图片中>>>>>>>>>>>");
    BOOL result;
    
    if ([archive UnzipOpenFile:FileName]) {
        result = [archive UnzipFileTo:ZipDir overWrite:YES];
        if (!result) {
            NSLog(@"解压失败");
        }
        else
        {
            NSLog(@"解压成功");
        }
        [archive UnzipCloseFile];
    }
}

/**
 *  description: 判断图片本地路径是否存在，不存在则下载图片
 *  @param 参数一: 图片在服务器上的URL
 *  @param 参数二: 图片名
 *  @paran 参数三: 图片存在Documents文件夹中的路径
 */
-(void)downloadFileFrom:(NSURL *)URL intoPath:(NSString * )path{
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:URL];
    [request setDownloadDestinationPath:path];
    NSLog(@"文件下载中...");
    [request startSynchronous];
    int statusCode = [request responseStatusCode];
    NSString *statusMessage = [request responseStatusMessage];
    NSLog(@"statusMessage = %@",statusMessage);
    NSLog(@"statusCode = %d",statusCode);
    switch (statusCode) {
        case 200:
            NSLog(@"文件下载成功");
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

#pragma mark - 书架页面XML解析
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
            //1.得到沙箱中的Documents目录路径
            NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //2.指定下载到沙箱中的文件名称
            path = [path stringByAppendingPathComponent:magazineDock.FrontCover];
            //先检测图片是否已经存在
            BOOL isDownload = [FileOperation fileExistsAtPath:path];
            //结果为 NO 则下载图片
            if (!isDownload) {
                NSLog(@"文件下载开始......");
                NSURL * imageURL = [NSURL URLWithString:magazineDock.FrontCoverURL];
                [self downloadFileFrom:imageURL intoPath:path];
                NSLog(@"文件下载完毕......");
            }else{
                NSLog(@"path = %@,文件已经存在",path);
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

#pragma mark - 期刊内容页XML解析
/**
 *  description:            解析期刊内容页数据
 *  @param path:            用户所点击的期刊对应XML的URL
 *  @return:                返回一个期刊内容页数据对象
 */
-(CCMagazineTopic *)ParserContentListXMLWithPath:(NSString * )path{
    NSLog(@">>>>>>>>>>ContentListXML解析开始>>>>>>>>>>>>>");
//    NSString * path = @"/Users/Ken/Library/Application Support/iPhone Simulator/7.0.3/Applications/196BD667-57D7-4056-9040-F04CA9E6BD2C/Documents/ContentList.xml";
    NSString *docXML =[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:Nil];
    NSError *error = nil;
    GDataXMLDocument *document = [[GDataXMLDocument alloc]initWithXMLString:docXML options:0 error:&error];
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
                Content.CoverThumbName = [[subObj attributeForName:@"ThumbName"]stringValue];
            }else if ([subObj.name isEqualToString:@"Topic"]){
                NSString * Thumb = [[subObj attributeForName:@"ThumbName"]stringValue];
                NSString * ThumbURL = [self getThumbNameURL:Thumb WithPath:Content.CoverPath];
                [Content.ThumbName addObject:ThumbURL];

                NSString * TopicPath =[[subObj attributeForName:@"TopicPath"]stringValue];
                NSString * zipPath = [self getTopicPathZipURL:TopicPath];
                [Content.TopicPath addObject:zipPath];
            }
        }
    }
//    NSLog(@"resourcePath = %@",self.resourcePath);
    NSLog(@">>>>>>>>>>ContentListXML解析结束>>>>>>>>>>>>");
    return Content;
}

#pragma mark - 获得了对应的resourcePath
/**
 *  description:            在这个方法内获得了当前xml对应的resourcePath
 */
-(NSString *)getLocalFolderName:(NSString *)CoverPath{
    NSArray * aaa = [CoverPath componentsSeparatedByString:@"/"];
    NSString * temp = [NSString stringWithString:[aaa objectAtIndex:2]];
    self.resourcePath = Nil;
    resourcePath = [NSString stringWithFormat:@"%@/%@",KDocumentFolderPath,temp];
//    NSLog(@"获得resourcePath = %@",resourcePath);
    return temp;
}
//拼接ThumbNameURL地址
-(NSString *)getThumbNameURL:(NSString *)ThumbName WithPath:(NSString *)CoverPath{
    NSArray * aaa = [CoverPath componentsSeparatedByString:@"/"];
    NSString * resault = [NSString stringWithFormat:@"%@%@/%@/%@/ThumbPackage/%@",_HOSTURL,[aaa objectAtIndex:0],[aaa objectAtIndex:1],[aaa objectAtIndex:2],ThumbName];
    return resault;
}
//拼接Topic.zip地址
-(NSString *)getTopicPathZipURL:(NSString *)TopicPath{
    NSString * temp = [NSString stringWithFormat:@"%@%@",_HOSTURL,TopicPath];
    NSArray * strarr = [temp componentsSeparatedByString:@"/"];
    NSMutableArray * mutArr = [NSMutableArray arrayWithArray:strarr];
    [mutArr removeLastObject];
    NSString * temp1 = [mutArr componentsJoinedByString:@"/"];
    NSMutableString * mutArr2 = [NSMutableString stringWithFormat:@"%@.zip",temp1];
    NSString * resault = [NSString stringWithString:mutArr2];
    return resault;
}
//拼接FrontCover.zip地址
-(NSString *)getFrontCoverZipURL:(NSString *)CoverPath{
    NSString * temp = [NSString stringWithFormat:@"%@%@",_HOSTURL,CoverPath];
    NSArray * subStr = [temp componentsSeparatedByString:@"/"];
    NSMutableArray * removeLast = [NSMutableArray arrayWithArray:subStr];
    [removeLast removeLastObject];
    NSString * joinStr = [removeLast componentsJoinedByString:@"/"];
    NSString * resault = [NSString stringWithFormat:@"%@.zip",joinStr];
    return resault;
}



#pragma mark - LifeCycle
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
//        NSLog(@"ListURL = %@",ListURL);
        LocalListPath = [NSString stringWithString:path];
//        NSLog(@"LocalListPath = %@",LocalListPath);
    }
    return self;
}

@end


