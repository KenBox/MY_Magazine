
#ifndef MeiJiaApp_MeiJiaHeader_h
#define MeiJiaApp_MeiJiaHeader_h


//--------------------------------常用宏定义----------------------------
#define USER_DEFAULT                [NSUserDefaults standardUserDefaults]

#define APP_CACHES_PATH             [NSSearchPathForDirectoriesInDomains (NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#define APP_SCREEN_WIDTH            [UIScreen mainScreen].bounds.size.width
#define APP_SCREEN_HEIGHT           [UIScreen mainScreen].bounds.size.height

#define APP_SCREEN_CONTENT_HEIGHT   ([UIScreen mainScreen].bounds.size.height-20.0)

#define IS_4_INCH                   (APP_SCREEN_HEIGHT > 480.0)

#define RGBCOLOR(r,g,b)             [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a)          [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define APP_STORE_LINK_http                 @"https://itunes.apple.com/cn/app/dou-ban-xiang-ce-jing-xuan-ji/id588070942?ls=1&mt=8"
#define APP_STORE_LINK_iTunes               @"itms-apps://itunes.apple.com/cn/app/id588070942?mt=8"

#define APP_COMMENT_LINK_iTunes             @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=588070942"

#define IMAGE_CACHE     [SDImageCache sharedImageCache]
#define NOTIFICATION_CENTER         [NSNotificationCenter defaultCenter]
//--------------------------------文件存放路径--------------------------

#define kBaseHttpURL @"http://mz.glavesoft.com"
#define kCachesFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"] //Caches文件夹
#define KDocumentFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] //Documents文件夹
#define kTmpFolderPath [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/Tmp"] //tmp文件夹
#define kResouceFlieName @"shishang" // mztest修改为jianfengzazhi
#define KListXMLName @"List.xml"
#define KLoadingImageName @"loading_Bg.png"
#define KLoadingFileName @"WelcomeImages_magazine"

//#define kResouceUseFolderPath [kCachesFolderPath stringByAppendingPathComponent:KLoadingFileName]
#define kResouceUseFolderPath [kCachesFolderPath stringByAppendingPathComponent:kResouceFlieName] //资源使用目录 Library/Caches/jianfengzazhi
#define kResouceDownloadFolderPath [kTmpFolderPath stringByAppendingPathComponent:kResouceFlieName]	//资源临时存放目录
#define kResouceDownloadURL [NSString stringWithFormat:@"%@/%@", kBaseHttpURL, kResouceFlieName]
#define KListXMLDownloadURL [NSString stringWithFormat:@"%@/%@/%@",kBaseHttpURL,kResouceFlieName,KListXMLName]//http://mz.glavesoft.com/shishang/List.xml
#define KLoadingImageDownloadURL [NSString stringWithFormat:@"%@/%@/%@",kBaseHttpURL,KLoadingFileName,KLoadingImageName] //http://mz.glavesoft.com/WelcomeImages_magazine/loading_bg.png
//[kBaseHttpURL stringByAppendingPathComponent:kResouceFlieName]	//用这种方式http：//会变成http：/
//sina weibo key
#define kAppKey             @"2527883662"
#define kAppSecret          @"d6e639fba11bb9097cfe50d787997515"
#define kAppRedirectURI     @"http://www.sina.com"

#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#else
#    define NSLog(...) {}
#endif


#endif