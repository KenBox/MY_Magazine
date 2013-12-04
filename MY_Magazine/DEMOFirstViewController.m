//
//  DEMOFirstViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"
#import "CCContentViewController.h"
#import "CCMagazineDock.h"
#import "CCMagazineTopic.h"
#import "CCNetworking.h"
#import "AllDefineHeader.h"
#import "CCCornerImageView.h"

#define _HOSTURL @"http://218.4.19.242:8089/naill/upload/"
//#define _HOSTURL @"http://192.168.2.133:8080/naill/upload/"
//#define _HOSTURL @"http://42.121.0.245:8080/naill/upload/"
@interface DEMOFirstViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) CCNetworking * netManager;
@property (nonatomic,retain) NSMutableDictionary * DictForSectionHeader;//封装了2011-2015年的SectionHeader图片
@property (nonatomic,retain) NSMutableArray * DockArray;
@property (nonatomic,retain) NSMutableArray * year2012Data;
@property (nonatomic,retain) NSMutableArray * year2013Data;
@property (nonatomic,retain) NSMutableArray * year2014Data;
@property (nonatomic,retain) NSMutableArray * year2015Data;
@property (nonatomic,retain) NSMutableArray * year2011Data;

@property (nonatomic,retain) NSString * ContentXMLPath;//这个属性存储了内容页的XML本地路径
@property (nonatomic,retain) UIImageView * cornerImageView;
@end

@implementation DEMOFirstViewController
@synthesize ContentViewController,DictForSectionHeader,DockArray,netManager;
@synthesize year2011Data,year2012Data,year2013Data,year2014Data,year2015Data,ContentXMLPath;

@synthesize tableView;

#pragma mark - 按年份封装xml数据
//重新封装数据，一年的数据为一个Section，请配合加载图片至DictForSectionHeader集合中
-(NSMutableArray *)analyseSrc:(NSArray *)array{
    NSLog(@">>>>>>>>>>>Analyse Src>>>>>>>>>>>");
    NSMutableArray * resaultArr = [[NSMutableArray alloc]initWithCapacity:0];
    if ([DockArray count]) {
        [DockArray removeAllObjects];
    }
    [year2011Data removeAllObjects];
    [year2012Data removeAllObjects];
    [year2013Data removeAllObjects];
    [year2014Data removeAllObjects];
    [year2015Data removeAllObjects];
//    NSLog(@"array count = %lu",(unsigned long)[array count]);
    for (CCMagazineDock * obj in array) {
        //封装2013年的所有数据
        if([obj.Ppath hasPrefix:@"2013"]){
//            NSLog(@"%@",[obj description]);
            [year2013Data addObject:obj];
//            NSLog(@"year2013Data count = %lu",(unsigned long)[year2012Data count]);
//            NSLog(@"Ppath hasprefix 2013,Ppath = %@",obj.Ppath);
        }else if([obj.Ppath hasPrefix:@"2012"]){
            [year2012Data addObject:obj];
//            NSLog(@"Ppath hasprefix 2012,Ppath = %@",obj.Ppath);
        }else if ([obj.Ppath hasPrefix:@"2014"]){
            [year2014Data addObject:obj];
//            NSLog(@"Ppath hasprefix 2014,Ppath = %@",obj.Ppath);
        }else if ([obj.Ppath hasPrefix:@"2015"]){
            [year2015Data addObject:obj];
//            NSLog(@"Ppath hasprefix 2015,Ppath = %@",obj.Ppath);
        }else if ([obj.Ppath hasPrefix:@"2011"]){
            [year2011Data addObject:obj];
//            NSLog(@"Ppath hasprefix 2011,Ppath = %@",obj.Ppath);
        }
    }

    //若year201xData数组非空则加入集合中
    if ([year2015Data count]) {
        [self sortArrayByMonth:year2015Data];
        NSArray * arr = [NSArray arrayWithArray:year2015Data];
        [resaultArr addObject:arr];
    }
    if ([year2014Data count]) {
        [self sortArrayByMonth:year2014Data];
        NSArray * arr = [NSArray arrayWithArray:year2014Data];
        [resaultArr addObject:arr];
    }
    if ([year2013Data count]) {
        [self sortArrayByMonth:year2013Data];
        NSArray * arr = [NSArray arrayWithArray:year2013Data];
        [resaultArr addObject:arr];
    }
    if ([year2012Data count]) {
        [self sortArrayByMonth:year2012Data];
        NSArray * arr = [NSArray arrayWithArray:year2012Data];
        [resaultArr addObject:arr];
    }
    if ([year2011Data count]) {
        [self sortArrayByMonth:year2011Data];
        NSArray * arr = [NSArray arrayWithArray:year2011Data];
        [resaultArr addObject:arr];
    }
    

    NSLog(@">>>>>>>>>>>Analyse Src End>>>>>>>>>>>");
    return resaultArr;
}
//对期刊月份经行排序
-(void)sortArrayByMonth:(NSMutableArray *)Array{
    NSLog(@"sortArrayByMonth...");
    for (CCMagazineDock * obj in Array) {
        NSString * path = [NSString stringWithString:obj.Ppath];
        NSArray * pathArray = [path componentsSeparatedByString:@"/"];
        NSString * res1 = [pathArray objectAtIndex:2];
        NSArray * temp = [res1 componentsSeparatedByString:@"_"];
        NSString * str1 = [[temp firstObject] substringToIndex:4];
        NSString * str2 = [[temp firstObject] substringFromIndex:4];
        NSString * str3 = [temp lastObject];
        NSString * res = [NSString stringWithFormat:@"%@年%@月第%@期",str1,str2,str3];
//        NSLog(@"res = %@",res);
        obj.MonthVersion = [NSString stringWithString:res];
//        NSLog(@"%@",obj.MonthVersion);
    }
    //对Data数据按月及期刊号进行排序
    //其中，MonthVersion为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"MonthVersion" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [Array sortUsingDescriptors:sortDescriptors];
    
}

-(void)updateData{
    NSLog(@"检测网络状况完毕");
    NetworkStatus netStatus = [netManager checkNetwork];
    //检测网络
    if (netStatus == ReachableViaWiFi || netStatus == ReachableViaWWAN ) {
        //如果使用wifi或者3g则更新xml数据
        [netManager downloadXMLList];
        NSLog(@"更新List.xml文件成功,开始解析数据......");
        //获得解析完毕的数据
        NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
        //封装到自己的DockArray中
        [DockArray removeAllObjects];
        DockArray = [self analyseSrc:array];
        NSLog(@"解析List.xml文件成功");
    }else if (netStatus == NotReachable){
        //如果存在本地List.xml则进行数据解析
        if ([netManager checkListXMLexist]) {
            NSLog(@"List.xml文件已存在,开始解析数据......");
            //获得解析完毕的数据
            NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
            //封装到自己的DockArray中
            [DockArray removeAllObjects];
            DockArray = [self analyseSrc:array];
            NSLog(@"解析List.xml文件成功");
        }
    }

}

#pragma mark - LifeCycle
-(id)init{
    self = [super init];
    if (self) {
        NSLog(@">>>>>>>>FirstViewInit>>>>>>>>>>");
        tableView = [[UITableView alloc]init];
        [tableView setFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64)];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        netManager = [[CCNetworking alloc]init];
        DockArray = [[NSMutableArray alloc]init];
        //每年的数据
        year2011Data = [[NSMutableArray alloc]init];
        year2014Data = [[NSMutableArray alloc]init];
        year2013Data = [[NSMutableArray alloc]init];
        year2012Data = [[NSMutableArray alloc]init];
        year2015Data = [[NSMutableArray alloc]init];
        ContentXMLPath = [[NSString alloc]init];
        
        

    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@">>>>>>>>>FirstView did load>>>>>>>>>>");
    [super viewDidLoad];
    
    [self updateData];

    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.layer.borderWidth = 0.5;
    self.view.layer.borderColor = [UIColor colorWithWhite:0.750 alpha:1.000].CGColor;
    [self.view addSubview:tableView];
    //取消TableView的点击效果
    [self.tableView setAllowsSelection:NO];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
    //SectionHeader Data
    DictForSectionHeader = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < 5; i++) {
        NSString * imageName = [NSString stringWithFormat:@"bg_bookself_year_201%d",(i+1)];
        NSString * str = [NSString stringWithFormat:@"201%d",(i+1)];
        UIImage * image = [UIImage imageNamed:imageName];
        [DictForSectionHeader setObject:image forKey:str];
    }

    //添加设置按钮的图片及点击事件
    UIButton * setupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [setupBtn setImage:[UIImage imageNamed:@"btn_setting"] forState:UIControlStateNormal];
    [setupBtn addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    setupBtn.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithCustomView:setupBtn];
    self.navigationItem.leftBarButtonItem = btn;

    //导航栏的图片设置
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [bgImg setImage:[UIImage imageNamed:@"navbar_logo"]];
    self.navigationItem.titleView = bgImg;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_wood"] forBarMetrics:UIBarMetricsDefault];


}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - 下拉更新table数据
//-(void) doRefresh {
//    double delayInSeconds = 2.0;
//    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//        self.loading = NO;
//        //更新表格界面中的 DataSource 数据
//        NSLog(@">>>>>>>>>>>>>>>>>>>>>刷新数据中>>>>>>>>>>>>>>>>>>>>>>>");
//        [self updateData];
//        [self.tableView reloadData];
//    });
//}

#pragma mark -
#pragma mark UITableView Datasource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [DockArray count];
}

//通过计算得出Section需要分配的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    NSArray * arr = [NSArray arrayWithArray:[DockArray objectAtIndex:sectionIndex]];
    NSInteger RowNumber = 0;
    if ([arr count]%2==0) {
        RowNumber = [arr count]/2;
    }else if([arr count]%2 == 1){
        RowNumber = [arr count]/2 + 1;
    }
    return RowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //每次取出队列都需要清空子视图
    for (UIView* view in [cell.contentView subviews]) {
//        if (![view isKindOfClass:[CCCornerImageView class]]) {
            [view removeFromSuperview];
//        }
    }
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    NSInteger Section = indexPath.section;
    NSInteger Row = indexPath.row;
    unsigned long int _row =[[DockArray objectAtIndex:Section] count];//_row = numberOfRowsInSection
    //当indexPath.row * 2 < 总行号时，从左侧开始创建imageView和期刊号Label
    if (Row*2 < _row) {
        CCMagazineDock * dock = [[DockArray objectAtIndex:Section] objectAtIndex:Row*2];
        //获得本地图片地址
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:dock.FrontCover];
//        NSLog(@"FrontCover = %@",dock.FrontCover);
        NSData * imgdata = [NSData dataWithContentsOfFile:path];
        UIImage * leftimg = [UIImage imageWithData:imgdata];
        

        //创建手势对象
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
        //左侧视窗
        CGRect leftFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+20, 108, 172);
        UIImageView * left = [[UIImageView alloc]initWithFrame:leftFrame];
        [left.layer setShadowOffset:CGSizeMake(1, 1)];

        [left.layer setShadowRadius:5];
        [left.layer setShadowOpacity:1];
        [left.layer setShadowColor:[UIColor blackColor].CGColor];
        [left setImage:leftimg];
        [left setUserInteractionEnabled:YES];
        [left addGestureRecognizer:tap1];
        
        
        //左侧label
        CGRect leftLabelFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+10+202, 128, 20);
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:leftLabelFrame];
        //获得月号及期刊号
//        NSString * month = [NSString stringWithString:dock.MonthVersion];
//        NSString * subStr = [month substringFromIndex:4];
//        leftLabel.text = [NSString stringWithFormat:@"%@",subStr];//显示期刊号的字符串
        leftLabel.text = [NSString stringWithString:dock.MonthVersion];
        leftLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
//        [leftLabel.layer setShadowOffset:CGSizeMake(1, 1)];
//        [leftLabel.layer setShadowRadius:5];
//        [leftLabel.layer setShadowOpacity:1];
//        [leftLabel.layer setShadowColor:[UIColor blackColor].CGColor];
        [leftLabel setBackgroundColor:[UIColor clearColor]];
        
        [cell.contentView insertSubview:left atIndex:0];
        [cell.contentView addSubview:leftLabel];
        //根据每年数据需要创建右侧视图
        //当indexPath.row * 2+1 < 总行号时，创建右侧imageView和期刊号Label视图
        if(Row*2+1 < _row){
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
            //获得右侧视图的本地URL
            CCMagazineDock * dock2 = [[DockArray objectAtIndex:Section] objectAtIndex:Row*2+1];
            NSString * path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            path2 = [path2 stringByAppendingPathComponent:dock2.FrontCover];
//            NSLog(@"FrontCover2 = %@",dock2.FrontCover);
            NSData * imgdata2 = [NSData dataWithContentsOfFile:path2];
            UIImage * rightimg2 = [UIImage imageWithData:imgdata2];
            
            //右侧视窗

            
            CGRect rightFrame = CGRectMake(cell.bounds.size.width-10-128, cell.bounds.origin.y+20, 108, 172);
            UIImageView * right = [[UIImageView alloc]initWithFrame:rightFrame];

            [right.layer setShadowOffset:CGSizeMake(1, 1)];
            [right.layer setShadowRadius:5];
            [right.layer setShadowOpacity:1];
            [right.layer setShadowColor:[UIColor blackColor].CGColor];
            //    [right setImage:[UIImage imageNamed:@"Cover_126"]];
//            [right setAutoresizesSubviews:YES];
            [right setImage:rightimg2];
            [right setUserInteractionEnabled:YES];
            [right addGestureRecognizer:tap2];
            
            //右侧label
            CGRect rightLabelFrame = CGRectMake(cell.bounds.size.width-10-128,cell.bounds.origin.y+10+202, 128, 20);
            UILabel * rightLabel = [[UILabel alloc]initWithFrame:rightLabelFrame];
            rightLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
            rightLabel.text = [NSString stringWithString:dock2.MonthVersion];
//            [rightLabel.layer setShadowOffset:CGSizeMake(1, 1)];
//            [rightLabel.layer setShadowRadius:5];
//            [rightLabel.layer setShadowOpacity:1];
//            [rightLabel.layer setShadowColor:[UIColor blackColor].CGColor];
//            NSString * subStr = [month substringFromIndex:4];
//            rightLabel.text = [NSString stringWithFormat:@"%@",subStr];//显示期刊号的字符串
            [rightLabel setBackgroundColor:[UIColor clearColor]];
            
//            [cell.contentView addSubview:right];
            [cell.contentView insertSubview:right atIndex:0];
            [cell.contentView addSubview:rightLabel];
        }
    }
    
    return cell;
}


//通过这个方法设置sectionHeader的各项属性(背景图片,显示图片).
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * sectionView = [[UIView alloc]init];
    
    UIImageView * background = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_carpet"]];
    [background setFrame:CGRectMake(0, 0, 320, 30)];
    [sectionView addSubview:background];
    [sectionView setAutoresizesSubviews:YES];
    UIImageView * sepImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_bookself_sep"]];

    CCMagazineDock * obj = [[DockArray objectAtIndex:section] firstObject];
    NSString * sectionKey = [[obj.Ppath componentsSeparatedByString:@"/"]firstObject];
    UIImageView * sectionImageView = [[UIImageView alloc]initWithImage:[DictForSectionHeader objectForKey:sectionKey]];
    
    [sectionImageView setFrame:CGRectMake(15, 10, 50, 17)];
    [sepImageView setFrame:CGRectMake(70, 13, 230, 13.1)];
    
    [sectionView addSubview:sectionImageView];
    [sectionView addSubview:sepImageView];
    return sectionView;
}
 

#pragma mark - Gesture Methods
//Tap手势跳转至期刊内容页
-(void)pageSelected:(UITapGestureRecognizer*)gesture{
    ContentViewController = [[CCContentViewController alloc]initWithNibName:@"CCContentViewController" bundle:Nil];
    
    [self showOnWindow:gesture];

    
 
    
}

#pragma mark - SelfMethods
//根据所下载的xml文件更新下一级视图所需加载的资源
-(CCMagazineTopic *)updateContentViewControllerData:(NSString *)_xmlPath{
    CCMagazineTopic * Topic = [[CCMagazineTopic alloc]init];
    
    NSLog(@">>>>>>>>>>>加载内容页数据中>>>>>>>>>>>>>");
    NSURL * url = [NSURL URLWithString:_xmlPath];
    NSArray * arr = [_xmlPath componentsSeparatedByString:@"/"];
    NSString * str = [NSString stringWithString:[arr lastObject]];
    NSArray * subarr = [str componentsSeparatedByString:@"."];
    NSString * substr = [NSString stringWithString:[subarr firstObject]];
    Topic.LocalFolderName = substr;
    //1.得到沙箱中的Documents目录路径
    NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //2.指定下载到沙箱中的文件名称/201210_1/ContentList.xml

    Topic.downloadXMLPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@/ContentList.xml",substr]];

    
    //************下载ContentList.xml到指定文件夹**********//
    [netManager downloadFileFrom:url intoPath:Topic.downloadXMLPath CreatFolderName:Topic.LocalFolderName];

    //拼接下载路径
//    ContentXMLPath = [NSString stringWithString:path];
    Topic = [netManager ParserContentListXMLWithPath:Topic.downloadXMLPath];
    

    Topic.resourcePath = netManager.resourcePath;

    //**************下载图片zip包到指定文件夹***************//
    [netManager downloadImageZipIntoPath:Topic.LocalFolderName
                                 WithURL:Topic.TopicPath
                                     And:Nil];
    

    
    //**************下载目录图片到指定文件夹****************//
    [netManager downloadThumbPackageImages:Topic.ThumbName
                                  WithPath:Topic.LocalFolderName
                                       And:Topic.ThumbName];
    NSMutableArray * ThumbImages = [[NSMutableArray alloc]initWithArray:
                                    [self updateThumbImages:Topic.resourcePath WithThumbName:Topic.ThumbName]];
    Topic.ThumbImages = [[NSMutableArray alloc]initWithArray:ThumbImages];

        //解析下载并解压完毕后设置资源路径获取图片数据
    NSMutableArray * imgArr = [[NSMutableArray alloc]initWithArray:
                               [self updateResource:Topic.resourcePath WithThumbName:Topic.ThumbName]];
    Topic.ContectImages = [[NSMutableArray alloc]initWithArray:imgArr];
    NSLog(@">>>>>>>>>>>>加载内容页数据完成>>>>>>>>>>>>>");

    return Topic;
}

//拼接ContentList.xml下载路径
-(NSString *)getContentXMLPathWith:(NSInteger)section And:(NSInteger)indexInDockArray{
    CCMagazineDock * obj =[[DockArray objectAtIndex:section] objectAtIndex:indexInDockArray];
    NSString * str = _HOSTURL;
    NSString * _ContentXMLPath = [NSString stringWithFormat:@"%@%@",str,obj.Ppath];
//    NSLog(@"ContentXMLPath = %@",_ContentXMLPath);
    return _ContentXMLPath;

}
//将resource文件夹中的图片存放到集合中
-(NSMutableArray *)updateResource:(NSString *)resourcePath WithThumbName:(NSMutableArray *)ThumbName{
    NSMutableArray * mutArr = [[NSMutableArray alloc]init];
    for (NSString * obj in ThumbName) {
        NSArray * arr = [obj componentsSeparatedByString:@"/"];
        NSString * str = [NSString stringWithFormat:@"%@/resource/%@",resourcePath,[arr lastObject]];
        UIImage * imageData = [UIImage imageWithContentsOfFile:str];
        [mutArr addObject:imageData];
    }
    return mutArr;
}
//将期刊索引图片存放到集合中
-(NSMutableArray *)updateThumbImages:(NSString *)resourcePath WithThumbName:(NSMutableArray *)ThumbName{
    NSMutableArray * mutArr = [[NSMutableArray alloc]init];
    for (NSString * obj in ThumbName) {
        NSArray * arr = [obj componentsSeparatedByString:@"/"];
        NSString * str = [NSString stringWithFormat:@"%@/%@",resourcePath,[arr lastObject]];
        UIImage * imageData = [UIImage imageWithContentsOfFile:str];
        [mutArr addObject:imageData];
    }
    return mutArr;
}

#pragma mark - activity Methods
- (void)showOnWindow:(id)sender {
	// The hud will dispable all input on the window
	HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
	[self.view.window addSubview:HUD];
	
	HUD.delegate = self;
	HUD.labelText = @"Loading";
	
	[HUD showWhileExecuting:@selector(myTask:) onTarget:self withObject:(UIGestureRecognizer *)sender animated:YES];
}


- (void)myTask:(UIGestureRecognizer *)gesture {
	// Do something usefull in here instead of sleeping ...
//	sleep(3);
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:point];
    NSInteger row = selectedIndexPath.row;
    NSInteger section = selectedIndexPath.section;
    UITableViewCell * selectedCell = [self.tableView cellForRowAtIndexPath:selectedIndexPath];
    
    
    //通过CGPoint.x坐标分辨点击的期刊在左侧还是右侧cell.bounds.origin.x+30
    if (point.x<160) {
        CCCornerImageView * leftCorner = [[CCCornerImageView alloc]initWithFrame:CGRectMake(selectedCell.bounds.origin.x+116, 18, 30, 30)];
        [selectedCell.contentView insertSubview:leftCorner aboveSubview:selectedCell.contentView];
        
        //        NSLog(@"点击了左边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
        NSInteger indexInDockArray = row * 2;//在DockArray/Year201xData中的位置,用来获得内容页面的xml地址
        //生成ContentXML下载路径
        NSString * leftXMLPath = [self getContentXMLPathWith:section And:indexInDockArray];
        CCMagazineTopic * leftTopic = [[CCMagazineTopic alloc ]initWithObject:[self updateContentViewControllerData:leftXMLPath]];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"topic" object:leftTopic.ContectImages];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"topic2" object:leftTopic.ThumbImages];
        //        NSLog(@"发送通知......");
    }else{
        
        CCCornerImageView * rightCorner = [[CCCornerImageView alloc]initWithFrame:CGRectMake(selectedCell.bounds.size.width-10-42, 18, 30, 30)];
        [selectedCell.contentView insertSubview:rightCorner aboveSubview:selectedCell.contentView];
        
        //        NSLog(@"点击了右边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
        NSInteger indexInDockArray = row * 2 + 1 ;//在DockArray/Year201xData中的位置
        //生成ContentXML下载路径
        NSString * rightXMLPath = [self getContentXMLPathWith:section And:indexInDockArray];
        CCMagazineTopic * rightTopic = [[CCMagazineTopic alloc ]initWithObject:[self updateContentViewControllerData:rightXMLPath]];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"topic" object:rightTopic.ContectImages];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"topic2" object:rightTopic.ThumbImages];
        
        
        //        NSLog(@"发送通知......");
    }
    
    [self presentViewController:ContentViewController animated:YES completion:Nil];

}


@end
