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

//#define _SECTIONNUM 2
//#define _ROWINSECTION 5

@interface DEMOFirstViewController ()
@property (nonatomic,retain) CCNetworking * netManager;
@property (nonatomic,retain) NSMutableArray * ArrayForSectionHeader;
@property (nonatomic,retain) NSMutableArray * DockArray;
//@property (nonatomic,retain) NSArray * sectionArr;
@end

@implementation DEMOFirstViewController
@synthesize ContentViewController,ArrayForSectionHeader,DockArray,netManager;

-(void)analyseSrc:(NSArray *)array{
    if ([DockArray count]) {
        [DockArray removeAllObjects];
    }

    //每年的数据
    NSMutableArray * year2013Data = [[NSMutableArray alloc]init];
    NSMutableArray * year2012Data = [[NSMutableArray alloc]init];
    for (CCMagazineDock * obj in array) {
        //封装2013年的所有数据
        if([obj.Ppath hasPrefix:@"2013"]){
            [year2013Data addObject:obj];
            NSLog(@"ppath hasprefix 2013");
        }else if([obj.Ppath hasPrefix:@"2012"]){
            [year2012Data addObject:obj];
            NSLog(@"ppath hasprefix 2012");
        }
    }
    
    [DockArray addObject:year2013Data];
    [DockArray addObject:year2012Data];
    NSLog(@"dockArray count = %d",[DockArray count]);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"view did load");
    netManager = [[CCNetworking alloc]init];
    DockArray = [[NSMutableArray alloc]init];

    //获得解析完毕的数据
    NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
    //再封装到自己的DockArray中
    [self analyseSrc:array];
    [self.tableView setAllowsSelection:NO];
    
    
    //SectionHeader Data
    ArrayForSectionHeader = [NSMutableArray arrayWithCapacity:[DockArray count]];
    for (int i = [DockArray count] ; i>0; i--) {
        NSString * str = [NSString stringWithFormat:@"bg_bookself_year_201%d",i+1];
        [ArrayForSectionHeader addObject:str];
    }

    
    ContentViewController = [[CCContentViewController alloc]initWithNibName:@"CCContentViewController" bundle:Nil];
    self.view.layer.borderWidth = 0.5;
    self.view.layer.borderColor = [UIColor colorWithWhite:0.750 alpha:1.000].CGColor;
    [self.tableView.tableHeaderView setBackgroundColor:[UIColor clearColor]];
 
    //	self.title = @"Magazine Dock";
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    
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
        NSLog(@"刷新数据中.........");
        //1.检测网络
        [netManager checkNetwork];
        //2.重新下载xml文件
        [netManager downloadXMLList];
        //3.重新解析xml数据
        //获得解析完毕的数据
        NSArray * array = [[NSMutableArray alloc]initWithArray:[netManager useDOMXMLParser]];
        //再封装到自己的DockArray中
        [self analyseSrc:array];
        [self loadView];
        [self viewDidLoad];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{

    NSArray * arr = [DockArray objectAtIndex:sectionIndex];
    NSInteger RowNumber = 0;
    if ([arr count]%2==0) {
        RowNumber = [arr count]/2;
    }else if([arr count]%2 ==1){
        RowNumber = [arr count]/2 + 1;
    }
    
//    NSLog(@"RowNumber = %ld",(long)RowNumber);
    return RowNumber;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"生成一个CELL");
    static NSString *cellIdentifier = @"Cell";
    
    NSInteger Section = indexPath.section;
    NSInteger Row = indexPath.row;
    NSLog(@"Section = %d ,Row = %d",Section,Row);
    
    

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    }
    //从DockArray中获取ThumbImage地址
    //左侧视图的FontCoverURL
    //创建临时变量用来取出URL
//    sectionArr = [NSArray arrayWithArray:[DockArray objectAtIndex:Section]];
    int _row =[[DockArray objectAtIndex:Section] count];
    if (Row*2 < _row) {
        NSLog(@"生成左侧视图");
        CCMagazineDock * dock = [[DockArray objectAtIndex:Section] objectAtIndex:Row*2];
        //获得本地图片地址
        NSString * path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        path = [path stringByAppendingPathComponent:dock.FrontCover];
        NSData * imgdata = [NSData dataWithContentsOfFile:path];
        UIImage * leftimg = [UIImage imageWithData:imgdata];
        

        //创建手势对象
        UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
        //左侧视窗
        CGRect leftFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+20, 108, 172);
        UIImageView * left = [[UIImageView alloc]initWithFrame:leftFrame];
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
        
        if(Row*2+1 < _row){
            NSLog(@"生成右侧视图");
            UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
            //获得右侧视图的本地URL
            CCMagazineDock * dock2 = [[DockArray objectAtIndex:Section] objectAtIndex:Row*2+1];
            
            NSString * path2 = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            path2 = [path2 stringByAppendingPathComponent:dock2.FrontCover];
            NSData * imgdata2 = [NSData dataWithContentsOfFile:path2];
            UIImage * rightimg2 = [UIImage imageWithData:imgdata2];
            //右侧视窗
            CGRect rightFrame = CGRectMake(cell.bounds.size.width-10-128, cell.bounds.origin.y+20, 108, 172);
            UIImageView * right = [[UIImageView alloc]initWithFrame:rightFrame];
            //    [right setImage:[UIImage imageNamed:@"Cover_126"]];
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


//    NSLog(@"FrontCoverURL = %@",dock.FrontCoverURL);
    
    
    return cell;
}

//通过这个方法设置section的各项属性

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
-(void)pageSelected:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:point];
    NSInteger row = selectedIndexPath.row;
    NSInteger section = selectedIndexPath.section;

    if (point.x<160) {
        NSLog(@"点击了左边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
        
    }else{
        NSLog(@"点击了右边section = %d row = %d point.x = %f,point.y = %f",section,row,point.x,point.y);
    }
    [self presentViewController:ContentViewController animated:YES completion:Nil];
}


@end
