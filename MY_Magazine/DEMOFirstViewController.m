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
#import "CCNetworking.h"

#define _HOSTURL @"http://218.4.19.242:8089/naill/upload/"
//#define _HOSTURL @"http://192.168.2.133:8080/naill/upload/"
@interface DEMOFirstViewController ()
@property (nonatomic,retain) CCNetworking * netManager;
@property (nonatomic,retain) NSMutableArray * ArrayForSectionHeader;//封装了2011-2015年的SectionHeader图片
@property (nonatomic,retain) NSMutableArray * DockArray;
@property (nonatomic,retain) NSMutableArray * year2012Data;
@property (nonatomic,retain) NSMutableArray * year2013Data;
@property (nonatomic,retain) NSMutableArray * year2014Data;
@property (nonatomic,retain) NSMutableArray * year2015Data;
@property (nonatomic,retain) NSMutableArray * year2011Data;
@property (nonatomic,retain) CCMagazineDock * DockObj;
@end

@implementation DEMOFirstViewController
@synthesize ContentViewController,ArrayForSectionHeader,DockArray,netManager;
@synthesize year2011Data,year2012Data,year2013Data,year2014Data,year2015Data,DockObj;


#pragma mark - 按年份封装xml数据
//重新封装数据，一年的数据为一个Section，请配合加载图片至ArrayForSectionHeader集合中
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
            NSLog(@"%@",[obj description]);
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
    if ([year2012Data count]) {
        [self sortArrayByMonth:year2013Data];
        NSArray * arr = [NSArray arrayWithArray:year2012Data];
        [resaultArr addObject:arr];
    }
    if ([year2013Data count]) {
        [self sortArrayByMonth:year2012Data];
        NSArray * arr = [NSArray arrayWithArray:year2013Data];
        [resaultArr addObject:arr];
    }
    if ([year2011Data count]) {
        [self sortArrayByMonth:year2011Data];
        NSArray * arr = [NSArray arrayWithArray:year2011Data];
        [resaultArr addObject:arr];
    }
    
//    NSLog(@"DockArray count = %lu",(unsigned long)[DockArray count]);
    NSArray * arr = [resaultArr objectAtIndex:0];
    NSLog(@"arr count = %lu",(unsigned long)[arr count]);
    NSLog(@">>>>>>>>>>>Analyse Src End>>>>>>>>>>>");
    return resaultArr;
}
//对期刊月份经行排序
-(void)sortArrayByMonth:(NSMutableArray *)Array{
    NSLog(@"sortArrayByMonth...");
    for (CCMagazineDock * obj in Array) {
        NSString * path = [NSString stringWithString:obj.Ppath];
        NSArray * pathArray = [path componentsSeparatedByString:@"/"];
        NSString * version = [pathArray objectAtIndex:2];
        NSArray * arr = [version componentsSeparatedByString:@"_"];
        NSString * res = [arr componentsJoinedByString:@"."];
        obj.MonthVersion = [NSString stringWithString:res];
//        NSLog(@"%@",obj.MonthVersion);
    }
    //对Data数据按月及期刊号进行排序
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"MonthVersion" ascending:NO];//其中，MonthVersion为数组中的对象的属性，这个针对数组中存放对象比较更简洁方便
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:&sortDescriptor count:1];
    [Array sortUsingDescriptors:sortDescriptors];
    
}


#pragma mark - LifeCycle
-(id)init{
    self = [super init];
    if (self) {
        NSLog(@">>>>>>>>FirstViewInit>>>>>>>>>>");
        netManager = [[CCNetworking alloc]init];
        DockArray = [[NSMutableArray alloc]init];
        //每年的数据
        year2011Data = [[NSMutableArray alloc]init];
        year2014Data = [[NSMutableArray alloc]init];
        year2013Data = [[NSMutableArray alloc]init];
        year2012Data = [[NSMutableArray alloc]init];
        year2015Data = [[NSMutableArray alloc]init];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
//    NSLog(@"View did appear! DockArray count = %lu",(unsigned long)[DockArray count]);
}

-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"View will appear! DockArray count = %lu",(unsigned long)[DockArray count]);
}

-(void)updateData{
    NetworkStatus netStatus = [netManager checkNetwork];
    //检测网络
    if (netStatus == ReachableViaWiFi || netStatus == ReachableViaWWAN ) {
        //如果使用wifi或者3g则更新xml数据
        NSLog(@"正在检测网络状况");
        [netManager downloadXMLList];
        NSLog(@"更新List.xml文件成功,开始解析数据......");
        //获得解析完毕的数据
        NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
        //封装到自己的DockArray中
        DockArray = [self analyseSrc:array];
        NSLog(@"解析List.xml文件成功");
    }else if (netStatus == NotReachable){
        //如果存在本地List.xml则进行数据解析
        if ([netManager checkListXMLexist]) {
            NSLog(@"List.xml文件已存在,开始解析数据......");
            [DockArray removeAllObjects];
            //获得解析完毕的数据
            NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
            //封装到自己的DockArray中
            DockArray = [self analyseSrc:array];
            NSLog(@"解析List.xml文件成功");
        }
    }

}

- (void)viewDidLoad
{
    NSLog(@">>>>>>>>>FirstView did load>>>>>>>>>>");
    [super viewDidLoad];
    [self updateData];
    NSLog(@"dockArray count = %lu",(unsigned long)[DockArray count]);
    
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor clearColor]];
    self.view.layer.borderWidth = 0.5;
    self.view.layer.borderColor = [UIColor colorWithWhite:0.750 alpha:1.000].CGColor;
    

    
    //取消TableView的点击效果
    [self.tableView setAllowsSelection:NO];
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
    //SectionHeader Data
    ArrayForSectionHeader = [NSMutableArray arrayWithCapacity:[DockArray count]];
    for (unsigned long int i = [DockArray count] ; i>0; i--) {
        NSString * str = [NSString stringWithFormat:@"bg_bookself_year_201%lu",i+1];
        [ArrayForSectionHeader addObject:str];
    }

    
    ContentViewController = [[CCContentViewController alloc]initWithNibName:@"CCContentViewController" bundle:Nil];
    
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
-(void) doRefresh {
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.loading = NO;
        //更新表格界面中的 DataSource 数据
        NSLog(@">>>>>>>>>>>>>>>>>>>>>刷新数据中>>>>>>>>>>>>>>>>>>>>>>>");

//        for (UIView * view in self.view.subviews) {
//            [view removeFromSuperview];
//        }
        
//        [self viewDidLoad];
        [self updateData];
        [self viewDidAppear:YES];
    });
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            
            break;
        case 1:
            
            break;
            
        default:
            break;
    }
}

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
    NSLog(@"RowNumber = %ld",(long)RowNumber);
    return RowNumber;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //每次取出队列都需要清空子视图
    for (UIView* view in [cell.contentView subviews]) {
        [view removeFromSuperview];
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
        [left setAutoresizesSubviews:YES];
        [left setContentMode:UIViewContentModeScaleToFill];
        [left setOpaque:YES];
        [left setClipsToBounds:YES];
        [left setImage:leftimg];
        [left setUserInteractionEnabled:YES];
        [left addGestureRecognizer:tap1];
        
        
        //左侧label
        CGRect leftLabelFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+10+202, 128, 20);
        UILabel * leftLabel = [[UILabel alloc]initWithFrame:leftLabelFrame];
        //获得月号及期刊号
        NSString * month = [dock.Ppath substringWithRange:NSMakeRange(12, 8)];
        NSString * substr = [month substringFromIndex:4];
        leftLabel.text = [NSString stringWithFormat:@"期刊号:%@",substr];
        [cell.contentView addSubview:left];
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
            //    [right setImage:[UIImage imageNamed:@"Cover_126"]];
            [right setAutoresizesSubviews:YES];
            [right setImage:rightimg2];
            [right setUserInteractionEnabled:YES];
            [right addGestureRecognizer:tap2];
            //右侧label
            CGRect rightLabelFrame = CGRectMake(cell.bounds.size.width-10-128,cell.bounds.origin.y+10+202, 128, 20);
            UILabel * rightLabel = [[UILabel alloc]initWithFrame:rightLabelFrame];
            NSString * month = [dock2.Ppath substringWithRange:NSMakeRange(12, 8)];
            NSString * substr = [month substringFromIndex:4];
            rightLabel.text = [NSString stringWithFormat:@"期刊号:%@",substr];
            
            [cell.contentView addSubview:right];
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
    [background setFrame:CGRectMake(0, 0, 320, 25)];
    [sectionView addSubview:background];
    [sectionView setAutoresizesSubviews:YES];
    UIImageView * sepImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_bookself_sep"]];
//    UIImage * sectionImage = [UIImage imageNamed:@"bg_bookself_year_2011"];
    NSString * str = [ArrayForSectionHeader objectAtIndex:section];
    UIImage * sectionImage1 = [UIImage imageNamed:str];
    UIImageView * sectionImageView = [[UIImageView alloc]initWithImage:sectionImage1];
    
    [sectionImageView setFrame:CGRectMake(15, 5, 50, 20)];
    [sepImageView setFrame:CGRectMake(70, 10, 230, 11)];
    
    [sectionView addSubview:sectionImageView];
    [sectionView addSubview:sepImageView];
    return sectionView;
}
 

#pragma mark - Gesture Methods
//Tap手势跳转至期刊内容页
-(void)pageSelected:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:point];
    NSInteger row = selectedIndexPath.row;
    NSInteger section = selectedIndexPath.section;

    //通过CGPoint.x坐标分辨点击的期刊在左侧还是右侧
    if (point.x<160) {
//        NSLog(@"点击了左边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
        NSInteger indexInDockArray = row * 2;//在DockArray/Year201xData中的位置,用来获得内容页面的xml地址
        //生成ContentXML下载路径
        NSString * leftXMLPath = [self getContentXMLPathWith:section And:indexInDockArray];
        NSURL * url = [NSURL URLWithString:leftXMLPath];
        //1.得到沙箱中的Documents目录路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //2.指定下载到沙箱中的文件名称ContentList.xml
        path = [path stringByAppendingPathComponent:@"ContentList.xml"];
        [netManager downloadByURL:url WithPath:path];
    }else{
//        NSLog(@"点击了右边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
        NSInteger indexInDockArray = row * 2 + 1 ;//在DockArray/Year201xData中的位置
        //生成ContentXML下载路径
        NSString * rightXMLPath = [self getContentXMLPathWith:section And:indexInDockArray];
        NSURL * url = [NSURL URLWithString:rightXMLPath];
        //1.得到沙箱中的Documents目录路径
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        //2.指定下载到沙箱中的文件名称ContentList.xml
        path = [path stringByAppendingPathComponent:@"ContentList.xml"];
        [netManager downloadByURL:url WithPath:path];
    }
    [self presentViewController:ContentViewController animated:YES completion:Nil];
}

//拼接xml下载路径
-(NSString *)getContentXMLPathWith:(NSInteger)section And:(NSInteger)indexInDockArray{
    CCMagazineDock * obj =[[DockArray objectAtIndex:section] objectAtIndex:indexInDockArray];
    NSString * str = _HOSTURL;
    NSString * ContentXMLPath = [NSString stringWithFormat:@"%@%@",str,obj.Ppath];
    return ContentXMLPath;

}

@end
