//
//  PostCommentView.h
//  UPDIS
//
//  Created by Melvin on 13-7-4.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostCommentViewDelegate <NSObject>

-(void)postCommentState:(BOOL)success;

@end

@interface PostCommentView : UIView<UITextViewDelegate>

@property (nonatomic ,assign) id<PostCommentViewDelegate> delegate;
@property (nonatomic ,retain) UITextView    *txtComment;
@property (nonatomic ,retain) UIButton      *btnPost;
@property (nonatomic ,retain) UIButton      *btnSelect;

+ (CGFloat)textViewLineHeight;
+ (CGFloat)maxLines;
+ (CGFloat)maxHeight;
@end
