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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)loadView{
    [super loadView];
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 5.0) {
        [self.navigationController.navigationBar setBackgroundImage:TTIMAGE(@"bundle://bgtit.png")
                                                      forBarMetrics:UIBarMetricsDefault];
    } else {
        //让视图重新调用drawRect
        [self.navigationController.navigationBar setNeedsDisplay];
    }
    TTImageView *itemTitle = [[TTImageView alloc] init];
    [itemTitle setUrlPath:@"bundle://logo3.png"];
    [self.navigationItem setTitleView:itemTitle];
    TT_RELEASE_SAFELY(itemTitle);
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
