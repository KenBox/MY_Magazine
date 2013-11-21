//
//  DEMOFirstViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"

@interface DEMOFirstViewController ()
@property (nonatomic,retain)NSIndexPath * MyIndexPath;
@end

@implementation DEMOFirstViewController
@synthesize myTable,MyIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    //	self.title = @"Magazine Dock";
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
    
    //背景图片设置
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = [UIImage imageNamed:@"bg_carpet"];
    //导航栏的图片设置
    UIImageView * bgImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 140, 30)];
    [bgImg setImage:[UIImage imageNamed:@"navbar_logo"]];
    self.navigationItem.titleView = bgImg;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_wood"] forBarMetrics:UIBarMetricsDefault];
    [self.view addSubview:imageView];
    
    //添加TableView
    CGFloat navHeight =  self.navigationController.navigationBar.frame.size.height;
    //    CGRect tableFrame = CGRectMake(0, (navHeight/2+30), 320,( 1116-navHeight/2));
    CGRect tableFrame = CGRectMake(0, navHeight/2-20 , 320, 528);
    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStyleGrouped];
    [myTable setBackgroundColor:[UIColor clearColor]];
    myTable.delegate = self;
    myTable.dataSource =self;
    
    myTable.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:myTable atIndex:1];
}

- (void)showMenu
{
    [self.sideMenuViewController presentMenuViewController];
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!MyIndexPath) {
        MyIndexPath = indexPath;
    }
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
    UITapGestureRecognizer * tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected)];
    UITapGestureRecognizer * tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pageSelected)];
    
    //左侧视窗
    CGRect leftFrame = CGRectMake(cell.bounds.origin.x+20, cell.bounds.origin.y+10, 128, 192);
    UIImageView * left = [[UIImageView alloc]initWithFrame:leftFrame];
    [left setImage:[UIImage imageNamed:@"Cover_126"]];
    [left setUserInteractionEnabled:YES];
    [left addGestureRecognizer:tap1];
    //左侧label
    CGRect leftLabelFrame = CGRectMake(cell.bounds.origin.x+20, cell.bounds.origin.y+10+202, 128, 20);
    UILabel * leftLabel = [[UILabel alloc]initWithFrame:leftLabelFrame];
    leftLabel.text = @"12月期刊";
    
    //右侧视窗
    CGRect rightFrame = CGRectMake(cell.bounds.size.width-20-128, cell.bounds.origin.y+10, 128, 192);
    UIImageView * right = [[UIImageView alloc]initWithFrame:rightFrame];
    [right setImage:[UIImage imageNamed:@"Cover_126"]];
    [right setUserInteractionEnabled:YES];
    [right addGestureRecognizer:tap2];
    //右侧label
    CGRect rightLabelFrame = CGRectMake(cell.bounds.size.width-20-128,cell.bounds.origin.y+10+202, 128, 20);
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

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"2013年";
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return Nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)pageSelected{
    NSLog(@"%@",MyIndexPath);
}

@end
