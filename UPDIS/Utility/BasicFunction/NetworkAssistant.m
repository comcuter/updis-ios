//
//  NetworkAssistant.m
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "NetworkAssistant.h"
#import "BaseFunction.h"
#import "AppDelegate.h"

@implementation NetworkAssistant

#pragma mark -
#pragma mark 从服务端抓取数据
#pragma mark -
#pragma mark 从服务端抓取数据
-(void)fetchDataFromServer:(NSString*)operFlag withRootViewController:(UIViewController *)rootView
{
    if (mHud) {
        [mHud removeFromSuperview];
        TT_RELEASE_SAFELY(mHud);
    }
    
    if (!_silent) {
        if (rootView) {
            mHud = [[MBProgressHUD alloc] initWithView:rootView.view];
            [rootView.view addSubview:mHud];
        } else {
            UIWindow *window = [[UIApplication sharedApplication] keyWindow];
            mHud = [[MBProgressHUD alloc] initWithWindow:window];
            [window addSubview:mHud];
        }
        [mHud setAnimationType:MBProgressHUDAnimationFade];
        mHud.labelText = self.loadingStr?self.loadingStr:@"正在加载数据...";
        [mHud show:YES];
    }

    _operFlag = operFlag;
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                            selector:@selector(fetchData:)
                                                                              object:operFlag];
    [[AppDelegate sharedAppDelegate].operationQueue addOperation:operation];
    [operation release];
}

-(void)fetchData:(NSString *)operFlag
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    self.succeed = [BaseFunction fetchDataFromServer:operFlag parameter:self.parameter];
    [self performSelectorOnMainThread:@selector(fetchDataOver) withObject:nil waitUntilDone:NO];
    [pool release];
}

-(void)fetchDataOver{
    @try {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(fetchDataOver:operFlag:)]) {
            [self.delegate fetchDataOver:self.succeed operFlag:self.operFlag];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"fetchDataOver:%@",[exception debugDescription]);
    }
    @finally {
        [mHud hide:YES];
    }
}

-(void)dealloc
{
    TT_RELEASE_SAFELY(_parameter);
    TT_RELEASE_SAFELY(_operFlag);
    TT_RELEASE_SAFELY(_loadingStr);
    [super dealloc];
}

#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [mHud removeFromSuperview];
    TT_RELEASE_SAFELY(mHud);
}
@end