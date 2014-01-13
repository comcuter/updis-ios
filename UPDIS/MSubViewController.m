//
//  MSubViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "MSubViewController.h"

@interface MSubViewController ()

@end

@implementation MSubViewController

- (void)loadView
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
