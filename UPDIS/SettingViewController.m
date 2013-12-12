//
//  SettingViewController.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "SettingViewController.h"
#import "MTabBarItem.h"
#import "AppDelegate.h"
#import "APService.h"
#import "MURLJSONResponse.h"
#import "UpdateApp.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [mHud removeFromSuperview];
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(mHud);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"设置"
                                                           image:TTIMAGE(@"bundle://icon_4.png")
                                                             tag:4];
        self.tabBarItem = item;
        [item release];

        self.tableViewStyle = UITableViewStyleGrouped;
        self.autoresizesForKeyboard = YES;
        self.variableHeightRows = YES;

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.tableView.top<0) {
        //表格视图下键盘错误的问题
        [self.tableView setFrame:self.view.frame];
        [self createFooterView];
    }
}
-(void)loadView{
    [super loadView];


    [self.navigationController.navigationBar setBackgroundImage:TTIMAGE(@"bundle://bgtit.png")
                                                  forBarMetrics:UIBarMetricsDefault];

    TTImageView *itemTitle = [[TTImageView alloc] init];
    [itemTitle setUrlPath:@"bundle://logo3.png"];
    [self.navigationItem setTitleView:itemTitle];
    TT_RELEASE_SAFELY(itemTitle);

}
-(UISwitch *)createSwitch:(NSInteger)tag{
    UISwitch* switchy = [[UISwitch alloc] init];
    BOOL value =  [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"switch%d",tag]];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"switch%d",tag]]) {
        //不存在
        value = YES;
        if (tag==15||tag==16) {
            value = NO;
        }
    }
    if (tag==15||tag==16) {
        [switchy setOn:value];
    }
    else{
        [switchy setOn:value];
    }
    [switchy setTag:tag];

    [switchy addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

    return [switchy autorelease];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    int tag = [switchButton tag];
    if (tag==14||tag==15||tag==16) {
        switch (tag) {
            case 14:
                if (isButtonOn) {
                    //开启
                    UISwitch *temp15 = (UISwitch *)[self.tableView viewWithTag:15];
                    [temp15 setOn:NO animated:YES];
                    UISwitch *temp16 = (UISwitch *)[self.tableView viewWithTag:16];
                    [temp16 setOn:NO animated:YES];

                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"switch%d",14]];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",15]];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",16]];
                    [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
                }
                break;
            case 15:
                if (isButtonOn) {
                    UISwitch *temp14 = (UISwitch *)[self.tableView viewWithTag:14];
                    [temp14 setOn:NO animated:YES];
                    UISwitch *temp16 = (UISwitch *)[self.tableView viewWithTag:16];
                    [temp16 setOn:NO animated:YES];

                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",14]];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"switch%d",15]];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",16]];
                    [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
                }
                break;
            case 16:
                if (isButtonOn) {

                    UISwitch *temp15 = (UISwitch *)[self.tableView viewWithTag:15];
                    [temp15 setOn:NO animated:YES];
                    UISwitch *temp14 = (UISwitch *)[self.tableView viewWithTag:14];
                    [temp14 setOn:NO animated:YES];

                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",14]];
                    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"switch%d",15]];
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"switch%d",16]];
                    [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
                }

                break;
        }
    }
    else{
        [[NSUserDefaults standardUserDefaults] setBool:isButtonOn forKey:[NSString stringWithFormat:@"switch%d",tag]];
        [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
    }
    [self savePushSetting:tag isOn:isButtonOn];
}

-(void)initPageData{

    if (!self.switchNotice) {
        self.switchNotice = [self createSwitch:10];
    }

    if (!self.switchBidding) {
        self.switchBidding = [self createSwitch:11];
    }

    if (!self.switchAmateur) {
        self.switchAmateur = [self createSwitch:12];
    }

    if (!self.switchTalk) {
        self.switchTalk = [self createSwitch:13];
    }

    if (!self.switchProject) {
        self.switchProject = [self createSwitch:17];
    }

    if (!self.switchOpen) {
        self.switchOpen = [self createSwitch:14];
    }
    if (!self.switchClose) {
        self.switchClose = [self createSwitch:15];
    }
    if (!self.switchNight) {
        self.switchNight = [self createSwitch:16];
    }


    TTTableControlItem* switchNoticeItem = [TTTableControlItem itemWithCaption:@"通知" control:self.switchNotice];
    TTTableControlItem* switchBiddingItem = [TTTableControlItem itemWithCaption:@"招标信息" control:self.switchBidding];
    TTTableControlItem* switchTalkItem = [TTTableControlItem itemWithCaption:@"畅所欲言" control:self.switchTalk];
    TTTableControlItem* switchAmateurItem = [TTTableControlItem itemWithCaption:@"业余生活" control:self.switchAmateur];
    TTTableControlItem* switchProjectItem = [TTTableControlItem itemWithCaption:@"在谈项目" control:self.switchProject];
    



    TTTableControlItem* switchOpenItem = [TTTableControlItem itemWithCaption:@"开启" control:self.switchOpen];
    TTTableControlItem* switchNightItem = [TTTableControlItem itemWithCaption:@"只在夜间开启" control:self.switchNight];
    TTTableControlItem* switchCloseItem = [TTTableControlItem itemWithCaption:@"关闭" control:self.switchClose];


    BOOL isSpecailUser = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isSpecialUser"] integerValue];
    if (isSpecailUser) {
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           @"消息推送:",switchNoticeItem,switchBiddingItem,switchTalkItem,switchAmateurItem,switchProjectItem,
                           @"后台消息提醒时段:",switchOpenItem,switchNightItem,switchCloseItem,
                           @"",[TTTableTextItem itemWithText:@"关于" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"意见反馈" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"版本" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"检查更新" delegate:self selector:@selector(itemClick:)],nil];
    }
    else{
        self.dataSource = [TTSectionedDataSource dataSourceWithObjects:
                           @"消息推送:",switchNoticeItem,switchBiddingItem,switchTalkItem,switchAmateurItem,
                           @"后台消息提醒时段:",switchOpenItem,switchNightItem,switchCloseItem,
                           @"",[TTTableTextItem itemWithText:@"关于" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"意见反馈" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"版本" delegate:self selector:@selector(itemClick:)],
                           @"",[TTTableTextItem itemWithText:@"检查更新" delegate:self selector:@selector(itemClick:)],nil];

    }

    [self createFooterView];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"switch%d",10]]) {
        //不存在
//        [self savePushSetting:14 isOn:YES];
        [[NSUserDefaults standardUserDefaults] setBool:YES
                                                forKey:[NSString stringWithFormat:@"switch%d",10]];
    }
}

-(void)createFooterView{

    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 50)];
    [footView setBackgroundColor:[UIColor clearColor]];
    UIButton *btnLogout = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLogout setTitle:@"退出" forState:UIControlStateNormal];
    UIImage *logoutImage = TTIMAGE(@"bundle://btn10.png");
    [btnLogout setSize:logoutImage.size];
    [btnLogout setBackgroundImage:logoutImage forState:UIControlStateNormal];
    [btnLogout setBackgroundImage:logoutImage forState:UIControlStateHighlighted];
    [btnLogout setBackgroundImage:logoutImage forState:UIControlStateSelected];
    [btnLogout addTarget:self action:@selector(userLogout:) forControlEvents:UIControlEventTouchUpInside];
    [btnLogout setCenter:footView.center];
    [footView addSubview:btnLogout];
    [self.tableView setTableFooterView:footView];

    TT_RELEASE_SAFELY(footView);
}

- (void)userLogout:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出"
                                                    message:@"确认退出UPDIS iPhone版?"
                                                   delegate:self
                                          cancelButtonTitle:@"取消"
                                          otherButtonTitles:@"确认", nil];
    [alert show];
    TT_RELEASE_SAFELY(alert);
}


-(void)postUserLogout{
    [self showHUD:@"正在退出" isLoading:YES];
    NSString* url = [NSString stringWithFormat:USER_LOGOUT,MAIN_DOMAIN];


    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    request.cacheExpirationAge = TT_DEFAULT_CACHE_EXPIRATION_AGE;
    [request setCachePolicy:TTURLRequestCachePolicyDefault];
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request setValue:cookie
   forHTTPHeaderField:@"Cookie"];

    TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
    MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);

    [request send];
}
-(void)showHUD:(NSString *)text isLoading:(BOOL) isLoading{
    if (!mHud) {
        mHud = [[MBProgressHUD alloc] initWithView:self.view];
        [mHud setDelegate:self];
        [self.view addSubview:mHud];
    }

    [mHud setAnimationType:MBProgressHUDAnimationFade];
    mHud.labelText = text;
    if (!isLoading) {
        mHud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        mHud.mode = MBProgressHUDModeCustomView;
        [mHud showWhileExecuting:@selector(testTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        [mHud show:YES];
    }
}
-(void)testTask{
    sleep(1.5);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self postUserLogout];
    }
}


- (void)itemClick:(id)sender{
    TTTableTextItem *item = (TTTableTextItem *)sender;
    if ([item.text isEqualToString:@"关于"]) {
        //
        NSString *url = [NSString stringWithFormat:@"tt://webContent/about.html"];
        TTOpenURL(url);
    }
    if ([item.text isEqualToString:@"意见反馈"]) {
        //
    }if ([item.text isEqualToString:@"版本"]) {
        //
        NSString *url = [NSString stringWithFormat:@"tt://webContent/version.html"];
        TTOpenURL(url);
    }
    if ([item.text isEqualToString:@"检查更新"]) {
        [[UpdateApp sharedManager] update:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:RGBCOLOR(151, 173, 179)];
    [self initPageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark 保存push设置
- (void)savePushSetting:(NSInteger)switchTag isOn:(BOOL)isOn{
    //10 11 12 13
    //14 15 16

    NSString *messageType = @"";
    NSInteger pushSwitch = 2;
    NSString *udid = [APService openUDID];
    switch (switchTag) {
        case 14:
        case 15:
        case 16:
            //推送开关
            if (switchTag==14) {
                if (isOn) {
                    pushSwitch = 1;
                }
            }
            else if(switchTag==15){
                if (isOn) {
                    pushSwitch = 0;
                }
            }
            else{
                if (isOn) {
                    pushSwitch = 2;
                }
            }
            break;
        case 10:
        case 11:
        case 12:
        case 13:{
            //推送消息类型

        }
            break;
    }
    UISwitch *switch10  = (UISwitch*)[self.tableView viewWithTag:10];
    if ([switch10 isOn]) {
        messageType = [messageType stringByAppendingString:@"1,"];
    }
    UISwitch *switch11  = (UISwitch*)[self.tableView viewWithTag:11];
    if ([switch11 isOn]) {
        messageType = [messageType stringByAppendingString:@"2,"];
    }
    UISwitch *switch12  = (UISwitch*)[self.tableView viewWithTag:12];
    if ([switch12 isOn]) {
        messageType = [messageType stringByAppendingString:@"4,"];
    }
    UISwitch *switch13  = (UISwitch*)[self.tableView viewWithTag:13];
    if ([switch13 isOn]) {
        messageType = [messageType stringByAppendingString:@"3,"];
    }

    UISwitch *switch17  = (UISwitch*)[self.tableView viewWithTag:17];
    if ([switch17 isOn]) {
        messageType = [messageType stringByAppendingString:@"5,"];
    }

    if ([messageType length]>0) {
        if (([messageType length]-1)>0) {
            messageType = [messageType substringToIndex:[messageType length]-1];
        }
    }

    NSString *url = [NSString stringWithFormat:INTERFACE_SAVE_PUSH,MAIN_DOMAIN,udid,[messageType stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],pushSwitch];
    debug_NSLog(@"SAVE PUSH:%@",url);

    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    [request setCachePolicy:TTURLRequestCachePolicyNone];
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request setValue:cookie
   forHTTPHeaderField:@"Cookie"];

    TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
 
    MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    if (!request.response||![request.response isKindOfClass:[MURLJSONResponse class]]) {
        debug_NSLog(@"requestDidFinishLoad response is nil");
        return;
    }
    else{
        debug_NSLog(@"requestDidFinishLoad response is not nil");
    }
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);

    NSDictionary* feed = response.rootObject;
    if ([[feed objectForKey:@"sessionTimeout"] integerValue]||[feed objectForKey:@"success"]) {
        //退出
        [mHud hide:YES];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
        [[AppDelegate sharedAppDelegate] change2LoginView];
        return;
    }
}


-(void)dealloc{
    TT_RELEASE_SAFELY(_switchNotice);
    TT_RELEASE_SAFELY(_switchBidding);
    TT_RELEASE_SAFELY(_switchAmateur);
    TT_RELEASE_SAFELY(_switchTalk);
    TT_RELEASE_SAFELY(_switchOpen);
    TT_RELEASE_SAFELY(_switchNight);
    TT_RELEASE_SAFELY(_switchClose);
    [super dealloc];
}

@end
