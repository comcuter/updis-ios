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

- (id)initWithTabBar:(NSString *)temp{
    if (self = [super init]) {
        self.selectedIndex = 0;
    }
    return self;
}
-(void)dealloc{
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self tabBar] setBackgroundImage:TTIMAGE(@"bundle://bgbtm.png")];
	// Do any additional setup after loading the view.
    [self setTabURLs:[NSArray arrayWithObjects:
                      @"tt://category",
                      @"tt://personnel",
                      @"tt://myinfo",
                      @"tt://setting",
                      nil]];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showDetail:) name:@"showdetail" object:nil];

    [[UpdateApp sharedManager] update:NO];
    
}



- (void)showDetail:(NSNotification *) aNotification{
    NSString *contentId = [aNotification object];
    NSString *url = [NSString stringWithFormat:@"tt://commonDetail/%@",contentId];
    TTOpenURL(url);
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(MTabBarItem *)item{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
