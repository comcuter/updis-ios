//
//  PostMessageViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-17.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
typedef enum
{
	PageTypePostMessage,     //发布消息
	PageTypeMyMessage,    //我的信息
}PageType;

@interface PostMessageViewController : TTTableViewController<UITextFieldDelegate,UITextViewDelegate>

- (id)initWithPageType:(PageType)pageType;
@property (nonatomic ,retain) TTImageView  *titleImageView;
@property (nonatomic ,assign) PageType pageType;

@property (nonatomic ,retain) UIButton      *btnCategory;
@property (nonatomic ,retain) UITextField   *txtDept;
@property (nonatomic ,retain) UITextField   *txtTitle;
@property (nonatomic ,retain) UITextView    *txtContent;
//@property (nonatomic ,retain) UITextField *txt
@end
