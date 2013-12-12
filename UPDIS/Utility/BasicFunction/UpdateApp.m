//
//  UpdateApp.m
//  UPDIS
//
//  Created by Melvin on 13-8-20.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "UpdateApp.h"
#import "MURLJSONResponse.h"
#import "BaseFunction.h"

static const int DEFAULT_UPDATE_HOUR = 1 * 24;
/**
 * 一小时
 */
static const long HOUR_TIME = 3600000;



@implementation UpdateApp


+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}

-(void)dealloc{

    TT_RELEASE_SAFELY(_downUrl);
    [super dealloc];
}

-(BOOL)checkUpdate{
    float ctime = [[NSUserDefaults standardUserDefaults] floatForKey:@"check_update"];
    if (((([[NSDate date] timeIntervalSince1970]*1000) - ctime) > HOUR_TIME
         * DEFAULT_UPDATE_HOUR)) {
        return YES;
    }
    return NO;
}

-(void)showHUD:(NSString *)text{
    if (!mHud) {

        UIWindow *window = [[UIApplication sharedApplication] keyWindow];
        mHud = [[MBProgressHUD alloc] initWithWindow:window];
        [mHud setDelegate:self];
        [window addSubview:mHud];
    }

    [mHud setAnimationType:MBProgressHUDAnimationFade];
    mHud.labelText = text;
    [mHud show:YES];
}


-(void)update:(BOOL)focus{
    [self setIsFocus:focus];
    BOOL canUpdate = [self checkUpdate];
    if (!canUpdate) {
        if (self.isFocus)
            canUpdate = true;
    }
    if (canUpdate) {
        if (self.isFocus) {
            [self showHUD:@"正在检查更新"];
        }
        NSString* url = [NSString stringWithFormat:INTERFACE_FETCH_VERSION,MAIN_DOMAIN,2];



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

}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [mHud removeFromSuperview];
    TT_RELEASE_SAFELY(mHud);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {

    [mHud hide:YES];
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* feed = response.rootObject;


    [[NSUserDefaults standardUserDefaults] setFloat:[[NSDate date] timeIntervalSince1970]*1000
                                             forKey:@"check_update"];

    [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
    NSInteger buildVersion = [[feed objectForKey:@"buildVersion"] integerValue];
    NSInteger nowVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] integerValue];
    [self setDownUrl:[feed objectForKey:@"downloadURL"]];
    if (buildVersion>nowVersion) {
        //获取更新
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新"
                                                        message:[NSString stringWithFormat:@"Updis %@ 版本更新发布 \n%@ ",[feed objectForKey:@"releaseVersion"]
                                                                 ,[feed objectForKey:@"releaseNote"]]
                                                       delegate:self
                                              cancelButtonTitle:@"暂不升级"
                                              otherButtonTitles:@"立即更新", nil];
        [alert show];
        [alert release];
    }
    else{
        if (self.isFocus) {
            TTAlertNoTitle(@"已是最新版");
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==0) {

    }
    else{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:UPDATE_URL,self.downUrl]]];
    }
}



@end
