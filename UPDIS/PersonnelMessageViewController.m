//
//  PersonnelMessageViewController.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "PersonnelMessageViewController.h"
#import "PersonQueryViewController.h"
#import "PersonQueryParentViewController.h"
#import "MHTabBarController.h"

@interface PersonnelMessageViewController ()

@end

@implementation PersonnelMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"人事相关"
                                                           image:TTIMAGE(@"bundle://icon_2.png")
                                                             tag:2];
        self.tabBarItem = item;
        [item release];
    }
    return self;
}

-(void)loadView
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
    PersonQueryParentViewController *personQuery = [[PersonQueryParentViewController alloc] initWithType:QueryTypePerson];
    personQuery.title = @"人员查询";
    
    PersonQueryParentViewController *contactsQuery = [[PersonQueryParentViewController alloc] initWithType:QueryTypeContacts];
    contactsQuery.title = @"通讯录";
    
    NSArray *viewControllers =  [NSArray arrayWithObjects:personQuery, contactsQuery, nil];
    self.viewControllers = viewControllers;
    
    TT_RELEASE_SAFELY(personQuery);
    TT_RELEASE_SAFELY(contactsQuery);
    [self setDelegate:self];
    
    //左右滑动手势
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listSwipe:)];
    swipeGestureRight.direction =  UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRight];
    TT_RELEASE_SAFELY(swipeGestureRight);
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(listSwipe:)];
    swipeGestureLeft.direction =  UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureLeft];
    TT_RELEASE_SAFELY(swipeGestureLeft);
    
    [super viewDidLoad];
}

-(void)listSwipe:(UISwipeGestureRecognizer *)recognizer
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
        if (self.selectedIndex==0) {
            return;
        }
        [self setSelectedIndex:self.selectedIndex - 1 animated:YES];
    }
}

- (BOOL)mh_tabBarController:(MHTabBarController *)tabBarController
 shouldSelectViewController:(UIViewController *)viewController
                    atIndex:(NSUInteger)index
{
    if ([viewController isKindOfClass:[PersonQueryParentViewController class]]) {
        PersonQueryParentViewController *temp = (PersonQueryParentViewController *)viewController;
        [temp clickCurrentTab];
    }

	return YES;
}

@end
