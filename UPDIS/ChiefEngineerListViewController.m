//
//  ChiefEngineerListViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "ChiefEngineerListViewController.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>
#import "ActiveTaskModel.h"

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

@interface ChiefEngineerListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) NSArray *chiefEngineers;
@property (nonatomic, retain) NSMutableArray *currentSelectIndexPaths;

@end

@implementation ChiefEngineerListViewController

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
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:@"完成" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    selectButton.bounds = CGRectMake(0, 0, 40, 40);
    [selectButton addTarget:self action:@selector(chiefEngineersSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    self.navigationItem.rightBarButtonItem = selectButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo3"]];
    self.navigationItem.titleView = titleImageView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:229./255 green:229./255 blue:229./255 alpha:1.0];
    
    self.currentSelectIndexPaths = [NSMutableArray array];
    
    [self loadChiefEngineers];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSelectChiefEngineerButton
{
    if (self.currentSelectIndexPaths.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)chiefEngineersSelectButtonClicked
{
    NSMutableArray *selectedChiefEngineers = [NSMutableArray array];
    for (NSIndexPath *selectIndexPath in self.currentSelectIndexPaths) {
        CommonCellModel *commonModel = self.chiefEngineers[selectIndexPath.row];
        [selectedChiefEngineers addObject:commonModel];
    }
    
    if (self.chiefEngineerDidSelectBlock != nil) {
        self.chiefEngineerDidSelectBlock(selectedChiefEngineers);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadChiefEngineers
{
    [self showHUDWithText:@"正在加载数据..." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_ZONG_SHI_REVIEW_CHIEF_ENGINEER_LIST, MAIN_DOMAIN]];
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
            self.chiefEngineers = [CommonCellModel parseDataFromRawArray:rawArray];
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
    return self.chiefEngineers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommonCellIdentifier = @"CommonCell";
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommonCellIdentifier];
    }
    commonCell.textLabel.text = ((CommonCellModel *)self.chiefEngineers[indexPath.row]).name;
    if ([self.currentSelectIndexPaths containsObject:indexPath]) {
        commonCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        commonCell.accessoryType = UITableViewCellAccessoryNone;
    }
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.currentSelectIndexPaths containsObject:indexPath]) {
        [self.currentSelectIndexPaths removeObject:indexPath];
    } else {
        [self.currentSelectIndexPaths addObject:indexPath];
    }
    
    [self updateSelectChiefEngineerButton];
    [self.tableView reloadData];
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
