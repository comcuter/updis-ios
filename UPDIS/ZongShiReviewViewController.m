//
//  ZongShiReviewViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "ZongShiReviewViewController.h"
#import "ActiveTaskModel.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>

typedef enum : NSInteger {
    TaskManageLevelNone = 1,
    TaskManageLevelYuanJi = 2,
    TaskManageLevelSuoJi = 3,
} TaskManageLevel;

@interface ZongShiReviewViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation ZongShiReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"ico_arr"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backImage forState:UIControlStateNormal];
    backButton.bounds = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton addTarget:self action:@selector(navigationBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo3"]];
    self.navigationItem.titleView = titleImageView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:229./255 green:229./255 blue:229./255 alpha:1.0];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
    }
}



@end
