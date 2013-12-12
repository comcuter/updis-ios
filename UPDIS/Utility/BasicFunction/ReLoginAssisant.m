//
//  ReLoginAssisant.m
//  UPDIS
//
//  Created by Melvin on 13-7-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "ReLoginAssisant.h"
#import "MURLJSONResponse.h"
#import "BaseFunction.h"

@implementation ReLoginAssisant

+ (id)sharedManager
{
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{instance = self.new;});
    return instance;
}
- (void)reloginUser{
    NSString *userName = [[NSUserDefaults standardUserDefaults] valueForKey:@"userName"];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] valueForKey:@"pwd"];
    


       NSDictionary * parms = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",
                 pwd,@"pwd",
                 [BaseFunction getMacAddress],@"mac", nil];

    
    NetworkAssistant *networkAssistant =[[NetworkAssistant alloc] init];
    [networkAssistant setDelegate:self];
    [networkAssistant setParameter:parms];
    [networkAssistant setLoadingStr:nil];
    [networkAssistant fetchDataFromServer:USER_LOGIN withRootViewController:nil];
    [networkAssistant release];
    
}

-(void)fetchDataOver:(BOOL)succeed operFlag:(NSString *)operFlag{
    if (succeed) {

        NSString *str = [NSString stringWithContentsOfFile:USER_LOGIN_CACHE_FILE
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];


        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];

        debug_NSLog(@"%@",[userDic objectForKey:@"success"]);
        if ([[userDic objectForKey:@"success"] integerValue]) {
            //登录成功,检查设备
            NSInteger registered = [[userDic objectForKey:@"registered"] integerValue];
            if (registered==1) {
                //设备正常
                if (self.delegate&&[self.delegate respondsToSelector:@selector(relogin:)]) {
                    [self.delegate relogin:YES];
                }
                
            }
            else{
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
                [[AppDelegate sharedAppDelegate] change2LoginView];
            }
            
        }
    }
    else{

        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
        [[AppDelegate sharedAppDelegate] change2LoginView];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* feed = response.rootObject;
    if ([[feed objectForKey:@"success"] integerValue]) {
        if ([[feed objectForKey:@"registered"] integerValue]) {
            if (self.delegate&&[self.delegate respondsToSelector:@selector(relogin:)]) {
                [self.delegate relogin:YES];
            }
        }
        else{
            //强制退出
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"islogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
            [[AppDelegate sharedAppDelegate] change2LoginView];
        }

    }
}
@end
