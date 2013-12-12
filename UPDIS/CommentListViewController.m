//
//  CommentListViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-9.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommentListViewController.h"
#import "NTStyleSheet.h"
#import "CoreAnimationEffect.h"
#import "NSString+MessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "MURLJSONResponse.h"
//#import "DetailStyle.h"
#import "CommonDetailDataSource.h"

static const CGFloat INPUT_HEIGHT = 40.0f;

@interface CommentListViewController ()

@end

@implementation CommentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithContentId:(NSString *)contentId
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setContentId:contentId];
        self.variableHeightRows = YES;
        self.tableViewStyle = UITableViewStylePlain;
    }
    return self;
}

-(void)loadView{
    [super loadView];

    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
//    [bgView setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
//    [self.tableView setBackgroundView:bgView];
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
//    [bgView release];


}

-(void)showHUD:(NSString *)text isLoading:(BOOL) isLoading{
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
        [mHud showWhileExecuting:@selector(testTask) onTarget:self withObject:nil animated:YES];
    }
    else{
        [mHud show:YES];
    }
}
-(void)testTask{
    sleep(1.5);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    self.dataSource = [[[CommonDetailDataSource alloc]
                        initWithConentId:self.contentId loadList:YES] autorelease];
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}


- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillShowKeyboard:)
												 name:UIKeyboardWillShowNotification
                                               object:nil];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(handleWillHideKeyboard:)
												 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)dealloc{
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(_contentId);
    TT_RELEASE_SAFELY(_inputView);
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    UIImage *leftNavImage = TTIMAGE(@"bundle://ico_arr.png");
    UIImage *leftNavImageH = TTIMAGE(@"bundle://ico_arr.png");

    UIButton *leftNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftNavButton.bounds = CGRectMake(0, 0, leftNavImage.size.width, leftNavImage.size.height);
    [leftNavButton setImage:leftNavImage forState:UIControlStateNormal];
    [leftNavButton setImage:leftNavImageH forState:UIControlStateHighlighted];
    [leftNavButton addTarget:self action:@selector(leftNavClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftNavBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftNavButton];
    [self.navigationItem setLeftBarButtonItem:leftNavBarButton];
    TT_RELEASE_SAFELY(leftNavBarButton);

    [self initPageView];


    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:RGBCOLOR(151, 173, 179)];

}
-(void)leftNavClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
//    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [mHud removeFromSuperview];
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(mHud);
}

-(void)sendPressed:(id)sender{
    if (!self.inputView.textView.text) {
        TTAlertNoTitle(@"请输入评论内容");
        return;
    }
    [self.inputView.textView resignFirstResponder];

    [self showHUD:@"正在提交评论" isLoading:YES];
    NSString* url = [NSString stringWithFormat:INTERFACE_POST_COMMENT,MAIN_DOMAIN,self.contentId,[self.inputView.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],(self.inputView.selectButton.selected?@"true":@"false")];
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request setValue:cookie
   forHTTPHeaderField:@"Cookie"];

    TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
    MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);

    [request send];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)requestDidFinishLoad:(TTURLRequest*)request {
    MURLJSONResponse* response = request.response;
    TTDASSERT([response.rootObject isKindOfClass:[NSDictionary class]]);

    NSDictionary* feed = response.rootObject;
    if ([[feed objectForKey:@"sessionTimeout"] integerValue]) {
        //超时
        return;
    }
    if ([[feed objectForKey:@"success"] integerValue]) {
        [self showHUD:@"评论成功" isLoading:NO];
        [self.dataSource load:TTURLRequestCachePolicyNone more:NO];
    }
}

-(void)selectedPressed:(id)sender{
    UIButton *temp = (UIButton *)sender;
    [temp setSelected:!temp.selected];
}
- (void) initPageView {

    CGRect tableFrame = CGRectMake(0.0f, 0.0f, self.view.width, self.view.height - INPUT_HEIGHT);
    [self.tableView setFrame:tableFrame];
    
    if (!self.inputView) {
        MessageInputView *temp = [[MessageInputView alloc] initWithFrame:CGRectMake(0, self.view.height-INPUT_HEIGHT, self.view.width, INPUT_HEIGHT)];
        self.inputView = temp;
        TT_RELEASE_SAFELY(temp);

        self.inputView.textView.delegate = self;
        [self.inputView.sendButton addTarget:self action:@selector(sendPressed:)
                            forControlEvents:UIControlEventTouchUpInside];


        [self.inputView.selectButton addTarget:self action:@selector(selectedPressed:)
                              forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:self.inputView];
    }
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSwipe:)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    swipe.numberOfTouchesRequired = 1;
    [self.inputView addGestureRecognizer:swipe];
    TT_RELEASE_SAFELY(swipe);
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer{
    [self.inputView.textView resignFirstResponder];
}


- (void)scrollToBottomAnimated:(BOOL)animated
{
    NSInteger rows = [self.tableView numberOfRowsInSection:0];

    if(rows > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:animated];
    }
}

#pragma mark - Text view delegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView becomeFirstResponder];

    if(!self.previousTextViewContentHeight)
		self.previousTextViewContentHeight = textView.contentSize.height;

    [self scrollToBottomAnimated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat maxHeight = [MessageInputView maxHeight];
    CGFloat textViewContentHeight = textView.contentSize.height;
    CGFloat changeInHeight = textViewContentHeight - self.previousTextViewContentHeight;

    changeInHeight = (textViewContentHeight + changeInHeight >= maxHeight) ? 0.0f : changeInHeight;

    if(changeInHeight != 0.0f) {
        [UIView animateWithDuration:0.25f
                         animations:^{
                             UIEdgeInsets insets = UIEdgeInsetsMake(0.0f, 0.0f, self.tableView.contentInset.bottom + changeInHeight, 0.0f);
                             self.tableView.contentInset = insets;
                             self.tableView.scrollIndicatorInsets = insets;

                             [self scrollToBottomAnimated:NO];

                             CGRect inputViewFrame = self.inputView.frame;
                             self.inputView.frame = CGRectMake(0.0f,
                                                               inputViewFrame.origin.y - changeInHeight,
                                                               inputViewFrame.size.width,
                                                               inputViewFrame.size.height + changeInHeight);
                         }
                         completion:^(BOOL finished) {
                         }];

        self.previousTextViewContentHeight = MIN(textViewContentHeight, maxHeight);
    }

    self.inputView.sendButton.enabled = ([textView.text trimWhitespace].length > 0);
}

#pragma mark - Keyboard notifications
- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];

    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[UIView animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;

                         CGRect inputViewFrame = self.inputView.frame;
                         self.inputView.frame = CGRectMake(inputViewFrame.origin.x,
                                                           keyboardY - inputViewFrame.size.height,
                                                           inputViewFrame.size.width,
                                                           inputViewFrame.size.height);

                         UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                                                0.0f,
                                                                self.view.frame.size.height - self.inputView.frame.origin.y - INPUT_HEIGHT,
                                                                0.0f);

                         self.tableView.contentInset = insets;
                         self.tableView.scrollIndicatorInsets = insets;
                     }
                     completion:^(BOOL finished) {
                     }];
}


@end
