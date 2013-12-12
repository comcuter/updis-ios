//
//  LoginViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NetworkAssistant.h"

@interface LoginViewController :  TTViewController<NetworkAssistantDelegate,UITextFieldDelegate>
{
    BOOL userLogin;
}

@property (nonatomic ,retain) IBOutlet UIView       *userPanel;
@property (nonatomic ,retain) IBOutlet TTImageView  *userNameBg;
@property (nonatomic ,retain) IBOutlet TTImageView  *userPwdBg;
@property (nonatomic ,retain) IBOutlet UITextField  *txtUserName;
@property (nonatomic ,retain) IBOutlet UITextField  *txtUserPwd;

@property (nonatomic ,retain) IBOutlet UIView       *phonePanel;

@property (nonatomic ,retain) IBOutlet TTImageView  *vCodeBg;
@property (nonatomic ,retain) IBOutlet UILabel      *lblPhoneNum;
@property (nonatomic ,retain) IBOutlet UITextField  *txtVCode;



@property (nonatomic ,retain) IBOutlet UIButton *btnLogin;



-(IBAction)userLogin:(id)sender;

@end
