//
//  ProjectDetailViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-1-23.
//  Copyright (c) 2014年 tianv. All rights reserved.
//

#import "ProjectDetailViewController.h"
#import "ActiveTaskViewController.h"

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
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        CGSize contentSize = [self.project.partyAName sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
        return MAX(contentSize.height, 44);
    } else if (indexPath.row == 4) {
        NSString *projectLeads = [self.project.projectLeaders componentsJoinedByString:@", "];
        CGSize contentSize = [projectLeads sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
        return MAX(contentSize.height, 44);
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *titleIdentifier = @"titleIdentifier";
    NSString *otherIdentifier = @"otherIdentifier";
    NSString *activeTaskIdentifier = @"activeTaskIdentifier";
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleIdentifier];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
            cell.textLabel.numberOfLines = 0;
        }
        
        cell.textLabel.text = self.project.projectName;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.row == 6) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activeTaskIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:activeTaskIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        if (self.project.isImportedProject) {
            cell.textLabel.text = @"导入项目,不存在下达记录";
        } else {
            if (self.project.activeTaskId != 0) {
                cell.textLabel.text = @"产品要求评审及任务下达记录";
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            } else {
                cell.textLabel.text = @"";
            }
        }
        
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:otherIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 1) {
        cell.textLabel.text = @"项目编号";
        cell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.project.projectNumber);
        return cell;
    }
    
    if (indexPath.row == 2) {
        cell.textLabel.text = @"甲方";
        cell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.project.partyAName);
        cell.detailTextLabel.numberOfLines = 0;
        return cell;
    }
    
    if (indexPath.row == 3) {
        cell.textLabel.text = @"设计部门";
        cell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.project.designDepartment);
        cell.detailTextLabel.numberOfLines = 0;
        return cell;
    }
    
    if (indexPath.row == 4) {
        cell.textLabel.text = @"项目负责人";
        NSString *projectLeaders = [self.project.projectLeaders componentsJoinedByString:@", "];
        cell.detailTextLabel.text = convertBlankStringToDashIfPossible(projectLeaders);
        cell.detailTextLabel.numberOfLines = 0;
        return cell;
    }
    
    if (indexPath.row == 5) {
        cell.textLabel.text = @"规模";
        cell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.project.projectScale);
        cell.detailTextLabel.numberOfLines = 0;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 6) {
        if (!self.project.isImportedProject && self.project.activeTaskId != 0) {
            ActiveTaskViewController *activeTaskVC = [[ActiveTaskViewController alloc] init];
            activeTaskVC.activeTaskId = self.project.activeTaskId;
            [self.navigationController pushViewController:activeTaskVC animated:YES];
        }
    }
}

@end
