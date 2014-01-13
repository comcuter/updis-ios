//
//  MyInformationViewController.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "MyInformationViewController.h"
#import "MTabBarItem.h"
#import "SendMessageViewController.h"
@interface MyInformationViewController ()

@end

@implementation MyInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"我的信息" image:TTIMAGE(@"bundle://icon_3.png") tag:3];
        self.tabBarItem = item;
        [item release];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.navigationController.navigationBar setBackgroundImage:TTIMAGE(@"bundle://bgtit.png") forBarMetrics:UIBarMetricsDefault];
    TTImageView *itemTitle = [[TTImageView alloc] init];
    [itemTitle setUrlPath:@"bundle://logo3.png"];
    [self.navigationItem setTitleView:itemTitle];
    TT_RELEASE_SAFELY(itemTitle);
}

- (void)viewDidLoad
{
    SendMessageViewController *personQuery = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                         bundle:nil
                                                                                    messageType:SendMessageTypePostMessage];
    personQuery.title = @"发布消息";
    
    SendMessageViewController *contactsQuery = [[SendMessageViewController alloc] initWithNibName:@"SendMessageViewController"
                                                                                           bundle:nil
                                                                                      messageType:SendMessageTypeMyMessage];
    contactsQuery.title = @"我发布的";
    
    NSArray *viewControllers =  [NSArray arrayWithObjects:personQuery, nil];
    self.viewControllers = viewControllers;
    
    TT_RELEASE_SAFELY(personQuery);
    TT_RELEASE_SAFELY(contactsQuery);
    [self setDelegate:self];
    
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
    
    [super viewDidLoad];
}

- (void)listSwipe:(UISwipeGestureRecognizer *)recognizer
{
    if (recognizer.direction==UISwipeGestureRecognizerDirectionLeft) {
        if (self.selectedIndex + 1 == [self.viewControllers count]) {
            return;
        }
        debug_NSLog(@"UISwipeGestureRecognizerDirectionLeft");
        [self setSelectedIndex:self.selectedIndex + 1 animated:YES];
    }
    
    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
        debug_NSLog(@"UISwipeGestureRecognizerDirectionRight");
        //往右滑动
        if (self.selectedIndex == 0) {
            return;
        }
        [self setSelectedIndex:self.selectedIndex - 1 animated:YES];
    }
}

@end
