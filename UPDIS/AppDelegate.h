//
//  AppDelegate.h
//  UPDIS
//
//  Created by Melvin on 13-3-7.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "APService.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>


@property (strong, nonatomic) UIWindow *window;
+(AppDelegate *)sharedAppDelegate;
@property (retain) NSOperationQueue *operationQueue;

-(void)change2RootView;
-(void)change2LoginView;
@end
