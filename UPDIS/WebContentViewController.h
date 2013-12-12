//
//  WebContentViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-15.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "MBProgressHUD.h"


@protocol WebContentViewControllerDelegate <NSObject>
@optional
-(void)back2ListView;
@end

@interface WebContentViewController : TTViewController<UIWebViewDelegate,MBProgressHUDDelegate,TTURLRequestDelegate>{
     MBProgressHUD *mHud;
}

@property (nonatomic ,retain) UIWebView     *webView;
@property (nonatomic ,retain) NSDictionary  *pageData;
@property (nonatomic ,retain) NSString      *fileName;
@property (nonatomic ,assign) id<WebContentViewControllerDelegate> delegate;

- (id)initWithFileName:(NSString *)fileName;
- (id)initWithFileName:(NSString *)fileName pageData:(NSDictionary *)pageData;
@end
