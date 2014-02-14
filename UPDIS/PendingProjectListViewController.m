//
//  ProjectListViewController.m
//  UPDIS
//
//  Created by admin on 1/19/14.
//  Copyright (c) 2014 tianv. All rights reserved.
//

#import "PendingProjectListViewController.h"
#import "ProjectModel.h"
#import "ASIHTTPRequest.h"
#import "ProjectDetailViewController.h"

@interface PendingProjectListViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIView *loadingView;
@property (nonatomic, retain) NSArray *pendingProjects;

@end

@implementation PendingProjectListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.loadingView.hidden = NO;
    
    NSURL *pendingProjectsURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MAIN_DOMAIN, PENDING_PROJECTS]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:pendingProjectsURL];
    __weak ASIHTTPRequest *request = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request addRequestHeader:@"Cookie" value:cookie];
    
    request.completionBlock = ^{
        self.loadingView.hidden = YES;
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:&error];
        if (error == nil && [[responseDic valueForKey:@"success"] intValue] == 1) {
            self.pendingProjects = [ProjectModel parseProjectsFromRawArray:[responseDic valueForKey:@"data"]];
            [self.tableView reloadData];
        } else {
            // TODO: 提示出错.
        }
    };

    request.failedBlock = ^{
        self.loadingView.hidden = YES;
        // TODO: 提示出错.
    };
    
    [request startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pendingProjects.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"projectCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"list1"] resizableImageWithCapInsets:UIEdgeInsetsZero];
        cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        
        cell.textLabel.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        
        cell.detailTextLabel.backgroundColor = [UIColor clearColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.detailTextLabel.textColor = RGBCOLOR(79, 89, 105);
    }
    
    ProjectModel *p = [self.pendingProjects objectAtIndex:indexPath.row];
    
    cell.textLabel.text = p.projectName;
    
    NSString *projectNumber = p.projectNumber;
    if (projectNumber.length == 0) {
        projectNumber = @"-";
    }
    cell.detailTextLabel.text = projectNumber;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ProjectDetailViewController *projectDetailVC = [[ProjectDetailViewController alloc] init];
    projectDetailVC.project = [self.pendingProjects objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:projectDetailVC animated:YES];
}

@end
