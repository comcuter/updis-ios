//
//  AppDelegate.m
//  UPDIS
//
//  Created by Melvin on 13-3-7.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "AppDelegate.h"
#import "NTStyleSheet.h"
#import "RootViewController.h"
#import "LoginViewController.h"
#import "CategoryMessageViewController.h"
#import "MyInformationViewController.h"
#import "PersonnelMessageViewController.h"
#import "SettingViewController.h"
#import "CommonListViewController.h"
#import "CommentListViewController.h"
#import "CommonDetailViewController.h"
#import "PersonQueryViewController.h"
#import "WebContentViewController.h"
#import "ProjectViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    TT_RELEASE_SAFELY(_window);
    TT_RELEASE_SAFELY(_operationQueue);
    [super dealloc];
}

+ (AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *) [UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSOperationQueue * theQueue = [[NSOperationQueue alloc] init];
    self.operationQueue = theQueue;
    [self.operationQueue setMaxConcurrentOperationCount:4];
    [theQueue release];

    [[TTURLRequestQueue mainQueue] setMaxContentLength:0];
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    
    TTNavigator* navigator = [TTNavigator navigator];
    navigator.persistenceMode = TTNavigatorPersistenceModeNone;
    navigator.supportsShakeToReload = YES;
    [TTStyleSheet setGlobalStyleSheet:[[[NTStyleSheet alloc] init] autorelease]];
    navigator.window = self.window;

    TTURLMap* map = navigator.URLMap;
    [map from:@"8" toViewController:[TTWebController class]];
    [map from:@"tt://rootView" toViewController:[RootViewController class]];
    [map from:@"tt://loginView" toModalViewController:[LoginViewController class]];
    [map from:@"tt://loginView/(loadFromNib:)/(withClassName:)" toModalViewController:self];
    
    [map from:@"tt://category" toViewController:[CategoryMessageViewController class]];
    [map from:@"tt://personnel" toViewController:[PersonnelMessageViewController class]];
    [map from:@"tt://myinfo" toViewController:[MyInformationViewController class]];
    [map from:@"tt://project" toViewController:[ProjectViewController class]];
    [map from:@"tt://setting" toViewController:[SettingViewController class]];

    [map from:@"tt://commonList/(initWithListType:)" toViewController:[CommonListViewController class]];
    [map from:@"tt://commemtList/(initWithContentId:)" toViewController:[CommentListViewController class]];
    [map from:@"tt://commonDetail/(initWithContentId:)" toViewController:[CommonDetailViewController class]];
    [map from:@"tt://webContent/(initWithFileName:)" toViewController:[WebContentViewController class]];
    
    if ([navigator restoreViewControllers] == nil) {
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"];
        if(!isLogin){
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://loginView/LoginViewController/LoginViewController"]];
        } else {
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://rootView"]];
        }
    }
	[_window makeKeyAndVisible];

//    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
//                                                   UIRemoteNotificationTypeSound |
//                                                   UIRemoteNotificationTypeAlert)];
//    [APService setupWithOption:launchOptions];
//    [APService setTags:[NSSet setWithObjects:@"default", nil] alias:@"default"];
    return YES;
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL
{
	TTDPRINT(@"Opening url: %@", URL.absoluteString);
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}

- (UIViewController*)loadFromNib:(NSString *)nibName withClassName:(NSString *)className
{
    UIViewController* newController = [[NSClassFromString(className) alloc] initWithNibName:nibName bundle:nil];
    [newController autorelease];
    return newController;
}

- (void)change2RootView
{
    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://rootView"]];
}

- (void)change2LoginView
{
    TTOpenURL(@"tt://loginView/LoginViewController/LoginViewController");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    NSString *sound = [aps valueForKey:@"sound"];

    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"];
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]", content, badge, sound, customizeField1);

    // Required
    [APService handleRemoteNotification:userInfo];
}

- (void)networkDidReceiveMessage:(NSNotification *)notification
{
    NSDictionary * userInfo = [notification userInfo];
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    NSString *sound = [aps valueForKey:@"sound"];
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"];
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);
    NSString *title = [userInfo valueForKey:@"title"];
    debug_NSLog(@"title:%@ content:%@",title,content);
}

@end
