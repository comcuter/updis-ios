//
//  SearchProjectLeadViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-7-13.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "SearchProjectLeadViewController.h"
#import <UI7Kit/UI7Kit.h>
#import <UI7Kit/UI7TableViewCell.h>
#import "ActiveTaskModel.h"

@interface SearchProjectLeadViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) IBOutlet UI7TableView *tableView;

@property (nonatomic, strong) NSMutableArray *currentSearchResult;
@property (nonatomic, strong) NSMutableArray *currentSelectedProjectLeaders;

@end

@implementation SearchProjectLeadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo3"]];
    self.navigationItem.titleView = titleImageView;
    
    UIImage *backImage = [UIImage imageNamed:@"ico_arr"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    backButton.bounds = CGRectMake(0, 0, 60, 44);
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    [backButton addTarget:self action:@selector(navigationBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIButton *selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selectButton setTitle:@"完成" forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [selectButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    selectButton.bounds = CGRectMake(0, 0, 40, 40);
    [selectButton addTarget:self action:@selector(projectLeadDidSelectButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *selectButtonItem = [[UIBarButtonItem alloc] initWithCustomView:selectButton];
    self.navigationItem.rightBarButtonItem = selectButtonItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:229./255 green:229./255 blue:229./255 alpha:1.0];
    
    self.searchBar.delegate = self;
    
    self.currentSelectedProjectLeaders = [NSMutableArray array];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateSelectProjectLeadButton
{
    if (self.currentSelectedProjectLeaders.count > 0) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    } else {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)projectLeadDidSelectButtonClicked
{
    if (self.projectLeadDidSelectBlock != nil) {
        self.projectLeadDidSelectBlock(self.currentSelectedProjectLeaders);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchProjectLeaders];
}

- (void)searchProjectLeaders
{
    NSURL *requestURL =[NSURL URLWithString:[NSString stringWithFormat:URL_SEARCH_PROJECT_LEADER, MAIN_DOMAIN]];
    ASIFormDataRequest *strongRequest = [[ASIFormDataRequest alloc] initWithURL:requestURL];
    [strongRequest setPostValue:self.searchBar.text forKey:@"name"];
    __weak ASIFormDataRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        NSLog(@"%@", responseDic);
        
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            self.currentSearchResult = [[CommonCellModel parseDataFromRawArray:(NSArray *)responseDic[@"data"]] mutableCopy];
            [self.tableView reloadData];
        }
    };
    
    weakRequest.failedBlock = ^{
        // do nothing;
    };
    
    [weakRequest startAsynchronous];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"搜索结果";
    } else if (section == 1) {
        return @"已选择的项目负责人";
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.currentSearchResult.count == 0 ? 1 : self.currentSearchResult.count;
    } else {
        return self.currentSelectedProjectLeaders.count == 0 ? 1 : self.currentSelectedProjectLeaders.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommonCellIdentifier = @"CommonCell";
    static NSString *CenterAlignedCellIdentifier = @"CenterAlignedCell";
    
    UI7TableViewCell *centerAlignedCell = [tableView dequeueReusableCellWithIdentifier:CenterAlignedCellIdentifier];
    if (centerAlignedCell == nil) {
        centerAlignedCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CenterAlignedCellIdentifier];
        centerAlignedCell.textLabel.textAlignment = UITextAlignmentCenter;
    }
    
    if (indexPath.section == 0 && self.currentSearchResult.count == 0) {
        centerAlignedCell.textLabel.text = @"无结果";
        return centerAlignedCell;
    }
    
    if (indexPath.section == 1 && self.currentSelectedProjectLeaders.count == 0) {
        centerAlignedCell.textLabel.text = @"未选择负责人";
        return centerAlignedCell;
    }
    
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommonCellIdentifier];
    }
    
    CommonCellModel *user;
    if (indexPath.section == 0) {
        user = self.currentSearchResult[indexPath.row];
    } else if (indexPath.section == 1) {
        user = self.currentSelectedProjectLeaders[indexPath.row];
    }
    commonCell.textLabel.text = user.name;
    return commonCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.currentSearchResult.count == 0) {
        return;
    }
    
    if (indexPath.section == 0) {
        CommonCellModel *user = self.currentSearchResult[indexPath.row];
        // 判断是否加入
        BOOL shouldAddUserToSelect = YES;
        for (CommonCellModel *selectedUser in self.currentSelectedProjectLeaders) {
            if (selectedUser.modelId == user.modelId) {
                shouldAddUserToSelect = NO;
                break;
            }
        }
        
        if (shouldAddUserToSelect) {
            [self.currentSearchResult removeObject:user];
            [self.currentSelectedProjectLeaders addObject:user];
            [self.tableView reloadData];
            [self updateSelectProjectLeadButton];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

@end
