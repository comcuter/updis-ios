//
//  SendMessageViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-17.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "SendMessageViewController.h"
#import "MURLJSONResponse.h"
#import "XCDFormInputAccessoryView.h"

@interface SendMessageViewController ()

@end

@implementation SendMessageViewController {
	XCDFormInputAccessoryView *_inputAccessoryView;
}

- (void)dealloc
{
    TT_RELEASE_SAFELY(_titleImageView);
    TT_RELEASE_SAFELY(_btnCategory);
    TT_RELEASE_SAFELY(_txtDept);
    TT_RELEASE_SAFELY(_txtTitle);
    TT_RELEASE_SAFELY(_txtContent);
    [_pickerView setDelegate:nil];
    [_pickerView setDataSource:nil];
    TT_RELEASE_SAFELY(_pickerView);
    TT_RELEASE_SAFELY(_pickerData);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil messageType:(SendMessageType)messageType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setSendMessageType:messageType];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
    if (!self.titleImageView) {
        TTImageView *temp = [[TTImageView alloc] initWithFrame:CGRectMake(93, 15, 135, 35)];
        self.titleImageView = temp;
        TT_RELEASE_SAFELY(temp);
    }
    [self.scrollView addSubview:self.titleImageView];
    if (self.sendMessageType==SendMessageTypePostMessage) {
        [self.titleImageView setUrlPath:@"bundle://titles_4.png"];
    } else {
        [self.titleImageView setUrlPath:@"bundle://titles_7.png"];
    }

    [[self categoryBg] setUrlPath:@"bundle://input4.png"];
    [[self deptBg] setUrlPath:@"bundle://input3.png"];
    [[self titleBg] setUrlPath:@"bundle://input3.png"];
    [[self contentBg] setUrlPath:@"bundle://input7.png"];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.width, self.btnPost.bottom)];
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.height, 320, 216)];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
    [self.pickerView setShowsSelectionIndicator:YES];
    [self.view addSubview:self.pickerView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UITapGestureRecognizer *swipe = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(handleSwipe:)];
    swipe.numberOfTouchesRequired = 1;
    [self.scrollView addGestureRecognizer:swipe];
    TT_RELEASE_SAFELY(swipe);
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
        [self.btnCategory addTarget:self action:@selector(showPickView:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnPost addTarget:self action:@selector(postMessage:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UITapGestureRecognizer *click = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(showPickView:)];
        click.numberOfTouchesRequired = 1;
        [self.categoryBg addGestureRecognizer:click];
        TT_RELEASE_SAFELY(click);
        
        UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(postMessage:)];
        click1.numberOfTouchesRequired = 1;
        [self.btnPost addGestureRecognizer:click1];
        TT_RELEASE_SAFELY(click1);
    }
}

- (void)selectedPicker
{
    [self closePickView];
}

- (void)showPickView:(id)sender
{
    if (self.pickerData) {
        [self.pickerData removeAllObjects];
    }
    
    BOOL isSpecailUser = [[[NSUserDefaults standardUserDefaults] valueForKey:@"isSpecialUser"] integerValue];
    self.pickerData = [NSMutableArray arrayWithObjects:@"通知",@"招标信息",@"畅所欲言",nil];
    if (isSpecailUser) {
        [self.pickerData addObject:@"在谈项目"];
    }
    [self.pickerView reloadAllComponents];
    [self closePickView];
}

- (void)closePickView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [self.pickerView setFrame:CGRectMake(0, isShow ? self.view.height : self.view.height - 216, 320, 411)];
    isShow = !isShow;
	[UIView commitAnimations];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.pickerData count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.pickerData objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    selectedIndex = row;
    [self.btnCategory setTitle:[self.pickerData objectAtIndex:selectedIndex] forState:UIControlStateNormal];
    [self closePickView];
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer{

    if (isShow) {
        [self closePickView];
    }
    [self.txtDept resignFirstResponder];
    [self.txtTitle resignFirstResponder];
    [self.txtContent resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillShowKeyboard:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleWillHideKeyboard:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    if (self.scrollView.top < 0) {
        [self.scrollView setFrame:self.view.frame];
    }
}

- (void)postMessage:(id)sender
{
    NSInteger messageType =1;
    NSString *category = [self.btnCategory titleForState:UIControlStateNormal];
    if (!category) {
        TTAlert(@"请选择分类");
        return;
    }
    NSString *dept = [self.txtDept text];
    NSString *title = [self.txtTitle text];
    NSString *content = [self.txtContent text];
    if ([category isEqualToString:@"通知"]) {
        if (!dept) {
            TTAlert(@"请输入部门");
            [self.txtDept becomeFirstResponder];
            return;
        }
    } else if ([category isEqualToString:@"招标信息"]){
        messageType = 2;
    } else if ([category isEqualToString:@"畅所欲言"]){
        messageType = 3;
    } else {
        messageType=5;
    }
    
    if (!title) {
        TTAlert(@"请输入标题");
        [self.txtTitle becomeFirstResponder];
        return;
    }
    
    if (!content) {
        TTAlert(@"请输入内容");
        [self.txtContent becomeFirstResponder];
        return;
    }
    [self showHUD:@"正在发布消息" isLoading:YES];

    //%@/messages/postMessage?categoryType=%d&title=%@&content=%@&publishDept=%@&SMScontent=%@
    NSString* url = [NSString stringWithFormat:INTERFACE_POST_MESSAGE, MAIN_DOMAIN, messageType,[title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [dept stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], [content stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    debug_NSLog(@"url:%@",url);
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    [request setCachePolicy:TTURLRequestCachePolicyNone];
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request setValue:cookie forHTTPHeaderField:@"Cookie"];
    TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
    MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);
    [request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request
{
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);
    NSDictionary* feed = response.rootObject;
    if ([[feed objectForKey:@"sessionTimeout"] integerValue]) {
        return;
    }
    
    if ([[feed objectForKey:@"success"] integerValue] == 0) {
        TTAlert([feed objectForKey:@"msg"]);
    } else {
        [self showHUD:@"消息发布成功" isLoading:NO];
        [self.btnCategory setTitle:nil forState:UIControlStateNormal];
        self.txtDept.text = nil;
        self.txtTitle.text = nil;
        self.txtContent.text = nil;
    }
}

- (void)showHUD:(NSString *)text isLoading:(BOOL)isLoading
{
    if (!mHud) {
        mHud = [[MBProgressHUD alloc] initWithView:self.view];
        [mHud setDelegate:self];
        [self.view addSubview:mHud];
    }

    [mHud setAnimationType:MBProgressHUDAnimationFade];
    mHud.labelText = text;
    if (!isLoading) {
        mHud.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]] autorelease];
        mHud.mode = MBProgressHUDModeCustomView;
        [mHud hide:YES afterDelay:2];
    } else {
        [mHud show:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (isShow) {
        [self closePickView];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if (textField.tag==10) {
        [self.txtTitle becomeFirstResponder];
    }
    
    if (textField.tag==11) {
        [self.txtContent becomeFirstResponder];
    }
    
    return YES;
}

- (void)hudWasHidden:(MBProgressHUD *)hud
{
    [mHud removeFromSuperview];
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(mHud);
}

@end
