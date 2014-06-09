//
//  ProjectTypeListViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "ProjectTypeListViewController.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>
#import "CategoryTypeListViewController.h"

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

@interface ProjectTypeListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) NSArray *projectTypes;

@end

@implementation ProjectTypeListViewController

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
    
    [self loadProjectList];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadProjectList
{
    [self showHUDWithText:@"正在加载数据..." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_ZONG_SHI_REVIEW_PROJECT_TYPE_LIST, MAIN_DOMAIN]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        if (error == nil && [responseDic intValueForKey:SUCCESS_KEY] == 1) {
            NSArray *rawArray = [responseDic arrayValueForKey:@"data"];
            self.projectTypes = [CommonCellModel parseDataFromRawArray:rawArray];
            [self.tableView reloadData];
        }
    };
    
    weakRequest.failedBlock = ^{
        [self.HUD hide:YES];
        TTAlert(@"数据加载失败,请重试");
    };
    [weakRequest startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommonCellIdentifier = @"CommonCell";
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommonCellIdentifier];
    }
    commonCell.textLabel.text = ((CommonCellModel *)self.projectTypes[indexPath.row]).name;
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommonCellModel *commonModel = self.projectTypes[indexPath.row];
    
    CategoryTypeListViewController *categoryListVC = [[CategoryTypeListViewController alloc] init];
    categoryListVC.currentSelectProjectType = commonModel.modelId;
    categoryListVC.categoryTypeDidSelectBlock = self.categoryTypeDidSelectBlock;
    [self.navigationController pushViewController:categoryListVC animated:YES];
}

- (void)showHUDWithText:(NSString *)text type:(HUDType)type
{
    if (self.HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.animationType = MBProgressHUDAnimationFade;
    }
    
    self.HUD.labelText = text;
    if (type == HUDTypeLoading) {
        [self.HUD show:YES];
    } else {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD show:YES];
        [self.HUD hide:YES afterDelay:2];
    }
}

@end
