//
//  DEMOFirstViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"
#import "CCContentViewController.h"
#define _SECTIONNUM 2

@interface DEMOFirstViewController ()
@property (nonatomic,retain) NSMutableArray * ArrayForSectionHeader;

@end

@implementation DEMOFirstViewController
@synthesize ContentViewController,ArrayForSectionHeader;

- (void)viewDidLoad
{
    [super viewDidLoad];

    //SectionHeader Data
    ArrayForSectionHeader = [NSMutableArray arrayWithCapacity:_SECTIONNUM];
    for (int i = _SECTIONNUM ; i>0; i--) {
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
    //    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
    //                                                                             style:UIBarButtonItemStylePlain
    //                                                                            target:self
    //                                                                            action:@selector(showMenu)];
    
    //导航栏的图片设置
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [bgImg setImage:[UIImage imageNamed:@"navbar_logo"]];
    self.navigationItem.titleView = bgImg;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_wood"] forBarMetrics:UIBarMetricsDefault];
    
    
    /*
     //背景图片设置
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
     //    UIImageView * imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_carpet"]];
     imageView.contentMode = UIViewContentModeScaleAspectFill;
     imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
     imageView.image = [UIImage imageNamed:@"bg_carpet"];
     [self.view insertSubview:imageView atIndex:0];
     
     //添加TableView
     CGFloat navHeight =  self.navigationController.navigationBar.frame.size.height;
     //    CGRect tableFrame = CGRectMake(0, (navHeight/2+30), 320,( 1116-navHeight/2));
     CGRect tableFrame = CGRectMake(0, navHeight/2-20 , 320, 528);
     myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
     [myTable setBackgroundColor:[UIColor clearColor]];
     myTable.delegate = self;
     myTable.dataSource =self;
     
     
     myTable.backgroundColor = [UIColor clearColor];
     [self.view addSubview:myTable];
     */
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

-(void) doRefresh {
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.loading = NO;
        //更新表格界面中的 DataSource 数据
        
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
    return _SECTIONNUM;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
    }

    //创建手势对象
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected:)];
    
    //左侧视窗
    CGRect leftFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+20, 108, 172);
    UIImageView * left = [[UIImageView alloc]initWithFrame:leftFrame];
    [left setImage:[UIImage imageNamed:@"Cover_126"]];
    [left setUserInteractionEnabled:YES];
    [left addGestureRecognizer:tap1];
    //左侧label
    CGRect leftLabelFrame = CGRectMake(cell.bounds.origin.x+30, cell.bounds.origin.y+10+202, 128, 20);
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:leftLabelFrame];
    leftLabel.text = @"12月期刊";
    
    //右侧视窗
    CGRect rightFrame = CGRectMake(cell.bounds.size.width-10-128, cell.bounds.origin.y+20, 108, 172);
    UIImageView * right = [[UIImageView alloc]initWithFrame:rightFrame];
    [right setImage:[UIImage imageNamed:@"Cover_126"]];
    [right setUserInteractionEnabled:YES];
    [right addGestureRecognizer:tap2];
    //右侧label
    CGRect rightLabelFrame = CGRectMake(cell.bounds.size.width-10-128,cell.bounds.origin.y+10+202, 128, 20);
    UILabel * rightLabel = [[UILabel alloc]initWithFrame:rightLabelFrame];
    rightLabel.text = @"11月期刊";
    
    
    //    NSArray *titles = @[@"操作帮助", @"清理杂志", @"关于我们", @"意见反馈", @"退出设置"];
    //    cell.textLabel.text = titles[indexPath.row];
    [cell.contentView addSubview:left];
    [cell.contentView addSubview:right];
    [cell.contentView addSubview:leftLabel];
    [cell.contentView addSubview:rightLabel];
    
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
