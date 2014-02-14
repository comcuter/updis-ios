//
//  ProjectViewController.m
//  UPDIS
//
//  Created by admin on 2/14/14.
//  Copyright (c) 2014 tianv. All rights reserved.
//

#import "ProjectViewController.h"
#import "PendingProjectListViewController.h"

@interface ProjectViewController ()

@end

@implementation ProjectViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"项目" image:[UIImage imageNamed:@"tab_icon_project"] tag:4];
        self.tabBarItem = tabBarItem;
    }
    return self;
}

- (void)viewDidLoad
{
    UIImage *navigationBarBackgroundImage = [[UIImage imageNamed:@"bgtit"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [self.navigationController.navigationBar setBackgroundImage:navigationBarBackgroundImage forBarMetrics:UIBarMetricsDefault];
    
    UIImageView *navigationBarTitleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo3"]];
    self.navigationItem.titleView = navigationBarTitleView;
    
    PendingProjectListViewController *pendingProjectsViewController = [[PendingProjectListViewController alloc] init];
    pendingProjectsViewController.title = @"待处理项目";
    self.viewControllers = @[ pendingProjectsViewController ];
    
    [super viewDidLoad];
}

@end
