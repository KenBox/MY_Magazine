//
//  CCThumbViewController.m
//  MY_Magazine
//
//  Created by Ken on 13-11-23.
//  Copyright (c) 2013年 Ken. All rights reserved.
//
/**
 *  description:        内容目录页面
 */

#import "CCThumbViewController.h"
#import "AllDefineHeader.h"
@interface CCThumbViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation CCThumbViewController
@synthesize imagesArr,myTable;
- (IBAction)BackBtnPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        imagesArr = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getImages:) name:@"thumbImages" object:Nil];
    }
    return self;
}

-(void)getImages:(NSNotification *)info{
    if (imagesArr) {
        [imagesArr removeAllObjects];
    }
    for (UIImage * img in [info object]) {
        [imagesArr addObject:img];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //添加TableView
    self.view.autoresizesSubviews = YES;
    CGRect tableFrame = CGRectMake(0, 80, APP_SCREEN_WIDTH, APP_SCREEN_CONTENT_HEIGHT-80);

    myTable = [[UITableView alloc]initWithFrame:tableFrame style:UITableViewStylePlain];
    [myTable setBackgroundColor:[UIColor clearColor]];
    myTable.delegate = self;
    myTable.dataSource =self;

    
    myTable.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:myTable atIndex:1];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - TableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger Row = imagesArr.count;
    return  Row;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"ThumbCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    [cell.imageView setImage:[imagesArr objectAtIndex:indexPath.row]];
    cell.textLabel.text = @"Topic";
    

    return cell;

}

#pragma mark - TableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self dismissViewControllerAnimated:YES completion:Nil];
    NSInteger row = indexPath.row;
    NSNumber * selectRow = [NSNumber numberWithInteger:row];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectRow" object:selectRow];
}

@end
