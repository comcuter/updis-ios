//
//  LoginViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "LoginViewController.h"
#import "BaseFunction.h"
#import "AppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    TT_RELEASE_SAFELY(_userPanel);
    TT_RELEASE_SAFELY(_userNameBg);
    TT_RELEASE_SAFELY(_userPwdBg);
    [_txtUserName setDelegate:nil];
    TT_RELEASE_SAFELY(_txtUserName);
    [_txtUserPwd setDelegate:nil];
    TT_RELEASE_SAFELY(_txtUserPwd);
    TT_RELEASE_SAFELY(_phonePanel);
    TT_RELEASE_SAFELY(_vCodeBg);
    TT_RELEASE_SAFELY(_lblPhoneNum);
    TT_RELEASE_SAFELY(_txtVCode);
    TT_RELEASE_SAFELY(_btnLogin);
    [super dealloc];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[[TTNavigator navigator].topViewController navigationController] setNavigationBarHidden:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    userLogin = YES;
    TTImageView *bgView = [[TTImageView alloc] init];
    [bgView setUrlPath:(iPhone5? @"bundle://login_bg_5.png": @"bundle://login_bg.png")];
    [self.view insertSubview:bgView atIndex:0];
    TT_RELEASE_SAFELY(bgView);

    //初始化登录窗口
    //    [[[self userPanel] layer] setBorderColor:[[UIColor blueColor] CGColor]];
    //    [[[self userPanel] layer] setBorderWidth:1];

    [[self userNameBg] setUrlPath:@"bundle://input1.png"];
    [[self userPwdBg] setUrlPath:@"bundle://input1.png"];


    [self.txtUserName resignFirstResponder];
    [self.txtUserPwd resignFirstResponder];

}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([textField returnKeyType] != UIReturnKeyGo){
        NSInteger nextTag = [textField tag] + 1;
        UIView *nextTextField = [[self view] viewWithTag:nextTag];
        [nextTextField becomeFirstResponder];
    }
    else {
        [textField resignFirstResponder];
        [self userLogin];

    }
    return YES;
}
-(void)userLogin{
    NSDictionary *parms = nil;
    if (userLogin) {
        NSString *userName = [self.txtUserName text];
        if(!userName){
            TTAlert(@"请输入账号");
            return;
        }
        NSString *userPwd = [BaseFunction md5:[self.txtUserPwd text]];
        if(!userPwd){
            TTAlert(@"请输入密码");
            return;
        }
        parms = [NSDictionary dictionaryWithObjectsAndKeys:userName,@"userName",
                 userPwd,@"pwd",
                 [BaseFunction getMacAddress],@"mac", nil];
    }
    else{
        NSString *vCode = [self.txtVCode text];
        if(!vCode){
            TTAlert(@"请输入验证码");
            return;
        }
        parms = [NSDictionary dictionaryWithObjectsAndKeys:vCode,@"verificationCode", nil];
    }
    NetworkAssistant *networkAssistant =[[NetworkAssistant alloc] init];
    [networkAssistant setDelegate:self];
    [networkAssistant setParameter:parms];
    [networkAssistant fetchDataFromServer:userLogin?USER_LOGIN:USER_REGPHONE withRootViewController:self];
    [networkAssistant release];

    [self.txtUserName resignFirstResponder];
    [self.txtUserPwd resignFirstResponder];
    [self.txtVCode resignFirstResponder];


}
-(IBAction)userLogin:(id)sender{
    [self userLogin];
}

-(void)fetchDataOver:(BOOL)succeed operFlag:(NSString *)operFlag{

    if (!succeed) {
        TTAlert(@"用户认证失败");
        return;
    }
    if ([operFlag isEqualToString:USER_REGPHONE]) {
        NSString *str = [NSString stringWithContentsOfFile:USER_REG_PHONE_CACHE_FILE
                                                  encoding:NSUTF8StringEncoding
                                                     error:nil];

        NSDictionary *userDic = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding]
                                                                options:NSJSONReadingMutableContainers
                                                                  error:nil];
        if ([[userDic objectForKey:@"success"] integerValue]) {
            //缓存数据
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
            [[AppDelegate sharedAppDelegate] change2RootView];
        }
        else{
            TTAlert([userDic objectForKey:@"msg"]);
        }
    }
    if ([operFlag isEqualToString:USER_LOGIN]) {
     
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
                [[AppDelegate sharedAppDelegate] change2RootView];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"islogin"];
            }
            if(registered==0){
                //需要注册设备
                [CoreAnimationEffect animationPushDown:self.userPanel];
                [self.userPanel setHidden:YES];
                [self.phonePanel setHidden:NO];
                [CoreAnimationEffect animationPushUp:self.phonePanel];
                userLogin = NO;
                [self.lblPhoneNum setText:[NSString stringWithFormat:@"您的手机号码为:%@ \n请将短信中的验证码输入下框内",[userDic objectForKey:@"phonenum"]]];
            }
            if(registered==99){
                //需要填写手机号码
                TTAlert(@"您没有登记手机号码,请登录内网个人信息修改页面添加手机号码后再登录.");
            }

            [[NSUserDefaults standardUserDefaults] setValue:[userDic objectForKey:@"userid"]
                                                     forKey:@"userid"];

            [[NSUserDefaults standardUserDefaults] setValue:[BaseFunction md5:[self.txtUserPwd text]]
                                                     forKey:@"pwd"];

            [[NSUserDefaults standardUserDefaults] setValue:[self.txtUserName text] forKey:@"userName"];

            [[NSUserDefaults standardUserDefaults] setValue:[userDic objectForKey:@"isSpecialUser"]
                                                     forKey:@"isSpecialUser"];
            [[NSUserDefaults standardUserDefaults] synchronize];//表示同步保存
        }
        else{
            TTAlert([userDic objectForKey:@"msg"]);
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
