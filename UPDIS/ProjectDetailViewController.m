//
//  ProjectDetailViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-1-23.
//  Copyright (c) 2014年 tianv. All rights reserved.
//

#import "ProjectDetailViewController.h"

@interface ProjectDetailViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end

@implementation ProjectDetailViewController

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
    
    self.tableView.allowsSelection = NO;
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleIdentifier = @"titleIdentifier";
    NSString *otherIdentifier = @"otherIdentifier";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleIdentifier];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20];
        }
        
        cell.textLabel.text = self.project.projectName;
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:otherIdentifier];
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"项目编号";
        cell.detailTextLabel.text = [self convertBlankStringToDashIfPossible:self.project.projectNumber];
        return cell;
    }
    
    if (indexPath.row == 2) {
        cell.textLabel.text = @"甲方";
        cell.detailTextLabel.text = [self convertBlankStringToDashIfPossible:self.project.partyAName];
        return cell;
    }
    
    if (indexPath.row == 3) {
        cell.textLabel.text = @"设计部门";
        cell.detailTextLabel.text = [self convertBlankStringToDashIfPossible:self.project.designDepartment];
        return cell;
    }
    
    if (indexPath.row == 4) {
        cell.textLabel.text = @"项目负责人";
        NSString *projectLeaders = [self.project.projectLeaders componentsJoinedByString:@", "];
        cell.detailTextLabel.text = [self convertBlankStringToDashIfPossible:projectLeaders];
        return cell;
    }
    
    if (indexPath.row == 5) {
        cell.textLabel.text = @"规模";
        cell.detailTextLabel.text = [self convertBlankStringToDashIfPossible:self.project.projectScale];
        return cell;
    }
    
    return nil;
}

- (NSString *)convertBlankStringToDashIfPossible:(NSString *)originalString
{
    if (originalString.length == 0) {
        return @"-";
    } else {
        return originalString;
    }
}

@end
