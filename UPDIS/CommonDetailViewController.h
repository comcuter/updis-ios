//
//  CommonDetailViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MSubListViewController.h"
#import "CommonDetailDataSource.h"
#import "MBProgressHUD.h"
#import "PostCommentView.h"
#import "MessageInputView.h"
#import "NetworkAssistant.h"

@interface CommonDetailViewController : MSubListViewController<PostCommentViewDelegate,CommonDetailDataSourceDelegate,MBProgressHUDDelegate,UIWebViewDelegate,UITextViewDelegate,NetworkAssistantDelegate,TTURLRequestDelegate>{
    MBProgressHUD *mHud;
    BOOL showCommentView;
    BOOL zeroComment;
}

@property (nonatomic ,retain) CommonDetailDataSource *commonDetailDataSource;
@property (nonatomic ,retain) NSString  *contnetId;
@property (nonatomic ,retain) UIView    *headView;
@property (nonatomic ,retain) UIWebView *webView;
@property (nonatomic ,retain) UIView    *toolBarView;
@property (nonatomic ,retain) UIButton  *btnShowAll;
@property (nonatomic ,retain) UIButton  *commentList;
@property (nonatomic ,retain) UIButton  *btnWriteComment;
//@property (nonatomic ,retain) PostCommentView *postCommentView;
@property (nonatomic ,retain) MessageInputView *inputView;
@property (nonatomic ,assign) CGFloat   previousTextViewContentHeight;
@property (nonatomic ,retain) NetworkAssistant  *networkAssistant;


- (id)initWithContentId:(NSString *)contnetId;
@end
