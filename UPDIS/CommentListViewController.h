//
//  CommentListViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-9.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "MSubListViewController.h"
#import "MBProgressHUD.h"
#import "MessageInputView.h"

@interface CommentListViewController : MSubListViewController<MBProgressHUDDelegate,UITextViewDelegate,TTURLRequestDelegate>{
    MBProgressHUD *mHud;
    BOOL showCommentView;
}

- (id)initWithContentId:(NSString *)contentId;

@property (nonatomic ,retain) NSString          *contentId;
@property (nonatomic ,retain) MessageInputView  *inputView;
@property (nonatomic ,assign) CGFloat           previousTextViewContentHeight;
@end
