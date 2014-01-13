//
//  PersonQueryParentViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-12.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonQueryViewController.h"
#import "CommonListViewController.h"
#import "WebContentViewController.h"

@interface PersonQueryParentViewController : TTViewController<CommonListViewControllerDelegate,WebContentViewControllerDelegate>{
    UIViewController *currentViewController;
    BOOL showList;
    BOOL showDetail;
}

@property (nonatomic ,assign) QueryType queryType;

@property (nonatomic ,retain) PersonQueryViewController *personQueryViewController;
@property (nonatomic ,retain) CommonListViewController *personListViewController;
@property (nonatomic ,retain) WebContentViewController *webContentViewController;

- (id)initWithType:(QueryType)queryType;
-(void)clickCurrentTab;
@end
