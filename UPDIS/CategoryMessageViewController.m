//
//  CategoryMessageViewController.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CategoryMessageViewController.h"
#import "MTabBarItem.h"
#import "CommonListView.h"
#import "NimbusPagingScrollView.h"
#import "TabPageView.h"
#import "CommonListViewController.h"
#import "BaseFunction.h"



@interface CategoryMessageViewController ()

@end

@implementation CategoryMessageViewController

-(void)listSwipe:(UISwipeGestureRecognizer *)recognizer{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        //往左滑动
        if (self.selectedIndex+1==[self.viewControllers count]) {
            return;
        }
        debug_NSLog(@"UISwipeGestureRecognizerDirectionLeft");
        [self setSelectedIndex:self.selectedIndex+1 animated:YES];
    }
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        debug_NSLog(@"UISwipeGestureRecognizerDirectionRight");
        //往右滑动
        if (self.selectedIndex==0) {
            return;
        }
        [self setSelectedIndex:self.selectedIndex-1 animated:YES];
    }
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"分类消息"
                                                           image:TTIMAGE(@"bundle://icon_1.png")
                                                             tag:1];
        self.tabBarItem = item;
        TT_RELEASE_SAFELY(item);

       
    }
    return self;
}
-(void)dealloc{
    
    [super dealloc];
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
    BOOL isSpecailUser = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isSpecialUser"] integerValue];

    //通知
    CommonListViewController *listView1 = [[CommonListViewController alloc] initWithListType:ListTypeNotice];
    listView1.title = @"通知";
    //招标信息
    CommonListViewController *listView2 = [[CommonListViewController alloc] initWithListType:ListTypeBidding];
    listView2.title = @"招标信息";
    //畅所欲言
    CommonListViewController *listView3 = [[CommonListViewController alloc] initWithListType:ListTypeTalk];
    listView3.title = @"畅所欲言";
    //业余生活
    CommonListViewController *listView4 = [[CommonListViewController alloc] initWithListType:ListTypeAmateur];
    listView4.title = @"业余生活";
    //在谈项目
    CommonListViewController *listView5 = [[CommonListViewController alloc] initWithListType:ListTypeProject];
    listView5.title = @"在谈项目";

    NSArray *viewControllers = nil;
    if (isSpecailUser) {
        viewControllers = [NSArray arrayWithObjects:listView1,listView2,listView3,listView4,listView5, nil];
    }
    else{
        viewControllers = [NSArray arrayWithObjects:listView1,listView2,listView3,listView4, nil];
    }
    self.viewControllers = viewControllers;

    TT_RELEASE_SAFELY(listView1);
    TT_RELEASE_SAFELY(listView2);
    TT_RELEASE_SAFELY(listView3);
    TT_RELEASE_SAFELY(listView4);
    TT_RELEASE_SAFELY(listView5);
    
    [super viewDidLoad];
    //左右滑动手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(listSwipe:)];
    swipeGestureRight.direction =  UISwipeGestureRecognizerDirectionRight;

    [self.view addGestureRecognizer:swipeGestureRight];
    TT_RELEASE_SAFELY(swipeGestureRight);

    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(listSwipe:)];
    swipeGestureLeft.direction =  UISwipeGestureRecognizerDirectionLeft;

    [self.view addGestureRecognizer:swipeGestureLeft];
    TT_RELEASE_SAFELY(swipeGestureLeft);
}

-(void) viewDidAppear:(BOOL)animated{
}

- (void)tabBar:(TTTabBar*)tabBar tabSelected:(NSInteger)selectedIndex
{
    if([tabBar isKindOfClass:[TTTabStrip class]])
    {
        NSLog(@"TTabStrip select:%d", selectedIndex);
    }else if([tabBar isKindOfClass:[TTTabGrid class]])
    {
        NSLog(@"TTTabGrid select:%d", selectedIndex);
    }else  if([tabBar isKindOfClass:[TTTabBar class]])
    {
        NSLog(@"TTTabBar select:%d", selectedIndex);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return NIIsSupportedOrientation(interfaceOrientation);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration {
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
}



#pragma mark -
#pragma mark MHTabBarControllerDelegate
- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController
 shouldSelectViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ shouldSelectViewController %@ at index %u", tabBarController, viewController, index);

	// Uncomment this to prevent "Tab 3" from being selected.
	//return (index != 2);

	return YES;
}

- (void)mh_tabBarController:(MHTabBarController *)tabBarController
    didSelectViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index
{
	NSLog(@"mh_tabBarController %@ didSelectViewController %@ at index %u", tabBarController, viewController, index);
}

@end
