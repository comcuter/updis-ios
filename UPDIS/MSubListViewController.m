//
//  MSubListViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "MSubListViewController.h"

@interface MSubListViewController ()

@end

@implementation MSubListViewController

-(void)loadView
{
    [super loadView];
    [self.navigationController.navigationBar setBackgroundImage:TTIMAGE(@"bundle://bgtit.png")
                                                  forBarMetrics:UIBarMetricsDefault];
    
    TTImageView *itemTitle = [[TTImageView alloc] init];
    [itemTitle setUrlPath:@"bundle://logo3.png"];
    [self.navigationItem setTitleView:itemTitle];
    TT_RELEASE_SAFELY(itemTitle);
}
@end
