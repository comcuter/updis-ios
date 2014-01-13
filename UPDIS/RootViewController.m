//
//  RootViewController.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "RootViewController.h"
#import "MTabBarItem.h"
#import "CommonDetailViewController.h"
#import "UpdateApp.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithTabBar:(NSString *)temp
{
    if (self = [super init]) {
        self.selectedIndex = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self tabBar] setBackgroundImage:TTIMAGE(@"bundle://bgbtm.png")];
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://category",
                      @"tt://personnel",
                      @"tt://myinfo",
                      @"tt://setting",
                      nil]];
    [[UpdateApp sharedManager] update:NO];
}

@end
