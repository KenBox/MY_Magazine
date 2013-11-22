//
//  DEMOFirstViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOFirstViewController.h"
#import "CCContentViewController.h"

@interface DEMOFirstViewController ()
@property (nonatomic,retain)NSIndexPath * MyIndexPath;
@end

@implementation DEMOFirstViewController
@synthesize MyIndexPath;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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


-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 5;
}

//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    [[tableView headerViewForSection:section] setBackgroundColor:[UIColor clearColor]];
//    return tableView.tableHeaderView;
//}

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
    return @"2011年";
}



- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

//手势方法
-(void)pageSelected:(UITapGestureRecognizer*)gesture{
    CGPoint point = [gesture locationInView:self.tableView];
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"%@",selectedIndexPath);
//    NSInteger row = selectedIndexPath;
    if (point.x<160) {
        NSLog(@"点击了左边 point.x = %f,point.y = %f",point.x,point.y);
        
    }else{
        NSLog(@"点击了右边 point.x = %f,point.y = %f",point.x,point.y);
    }
}


@end