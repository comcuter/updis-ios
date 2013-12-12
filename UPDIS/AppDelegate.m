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

@implementation AppDelegate

-(void)dealloc{
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
    [map from:@"tt://loginView/(loadFromNib:)/(withClass:)" toModalViewController:self];
    
    [map from:@"tt://category" toViewController:[CategoryMessageViewController class]];
    [map from:@"tt://personnel" toViewController:[PersonnelMessageViewController class]];
    [map from:@"tt://myinfo" toViewController:[MyInformationViewController class]];
    [map from:@"tt://setting" toViewController:[SettingViewController class]];

    [map from:@"tt://commonList/(initWithListType:)" toViewController:[CommonListViewController class]];
    [map from:@"tt://commemtList/(initWithContentId:)" toViewController:[CommentListViewController class]];
    [map from:@"tt://commonDetail/(initWithContentId:)" toViewController:[CommonDetailViewController class]];
    [map from:@"tt://webContent/(initWithFileName:)" toViewController:[WebContentViewController class]];
    
    if (![navigator restoreViewControllers]) {
        
        BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:@"islogin"];
        if(!isLogin){
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://loginView/LoginViewController/LoginViewController"]];
        }
        else{
            [navigator openURLAction:[TTURLAction actionWithURLPath:@"tt://rootView"]];
        }
    }
    
	[_window makeKeyAndVisible];

    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)];
    [APService setupWithOption:launchOptions];

    [APService setTags:[NSSet setWithObjects:@"default", nil] alias:@"default"];

    return YES;

}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)URL {
	TTDPRINT(@"Opening url: %@", URL.absoluteString);
	[[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:URL.absoluteString]];
	return YES;
}


/**
 * Loads the given viewcontroller from the nib
 */
- (UIViewController*)loadFromNib:(NSString *)nibName withClass:className {
    UIViewController* newController = [[NSClassFromString(className) alloc]
                                       initWithNibName:nibName bundle:nil];

    [newController autorelease];

    return newController;
}

-(void)change2RootView{

    [[TTNavigator navigator] openURLAction:[TTURLAction actionWithURLPath:@"tt://rootView"]];
//	[[[TTNavigator navigator] visibleViewController] dismissModalViewController];
}

-(void)change2LoginView{
    TTOpenURL(@"tt://loginView/LoginViewController/LoginViewController");
}

- (void)showDetailView:(NSString *)contentId{
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}




- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.

    [application setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    NSLog(@"TYPESSSSSS: %d", [application enabledRemoteNotificationTypes]);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *) error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音

    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);

    // Required
    [APService handleRemoteNotification:userInfo];
}

#pragma mark -

- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];

    NSDictionary *aps = [userInfo valueForKey:@"aps"];
   NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
   NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
   NSString *sound = [aps valueForKey:@"sound"]; //播放的声音

   // 取得自定义字段内容
   NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
   NSLog(@"content =[%@], badge=[%d], sound=[%@], customize field =[%@]",content,badge,sound,customizeField1);


    
    NSString *title = [userInfo valueForKey:@"title"];

    debug_NSLog(@"title:%@ content:%@",title,content);
}

@end
