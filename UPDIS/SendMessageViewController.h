//
//  SendMessageViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-17.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "MBProgressHUD.h"
#import "TPKeyboardAvoidingScrollView.h"

typedef enum
{
	SendMessageTypePostMessage,     //发布消息
	SendMessageTypeMyMessage,    //我的信息
}SendMessageType;
@interface SendMessageViewController : TTViewController<TTURLRequestDelegate,MBProgressHUDDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextViewDelegate,UIGestureRecognizerDelegate>{
    NSInteger selectedIndex;
    BOOL isShow;
    MBProgressHUD *mHud;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil messageType:(SendMessageType)messageType;


@property (nonatomic ,retain) TTImageView  *titleImageView;
@property (nonatomic ,assign) SendMessageType sendMessageType;


-(void)showPickView:(id)sender;



@property (nonatomic ,retain) IBOutlet TTImageView      *categoryBg;
@property (nonatomic ,retain) IBOutlet TTImageView      *deptBg;
@property (nonatomic ,retain) IBOutlet TTImageView      *titleBg;
@property (nonatomic ,retain) IBOutlet TTImageView      *contentBg;


@property (nonatomic ,retain) IBOutlet UIScrollView     *scrollView;
@property (nonatomic ,retain) IBOutlet UIButton         *btnCategory;
@property (nonatomic ,retain) IBOutlet UIButton         *btnPost;
@property (nonatomic ,retain) IBOutlet UITextField      *txtDept;
@property (nonatomic ,retain) IBOutlet UITextField      *txtTitle;
@property (nonatomic ,retain) IBOutlet UITextView       *txtContent;


@property (nonatomic ,retain) NSMutableArray *pickerData;
@property (nonatomic ,retain) UIPickerView *pickerView;

@end
