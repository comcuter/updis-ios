//
//  CommonDetailViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonDetailViewController.h"
#import "CommonDetailDataSource.h"
#import "NTStyleSheet.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "CoreAnimationEffect.h"
#import "NSString+MessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"
#import "MURLJSONResponse.h"
#import "BaseFunction.h"

static const CGFloat postViewHeight = 40.0f;

@interface CommonDetailViewController ()

@end

@implementation CommonDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)loadView{
    [super loadView];

    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.tableView setHeight:self.tableView.height-postViewHeight];
}
- (id)initWithContentId:(NSString *)contnetId
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        [self setContnetId:contnetId];
        self.variableHeightRows = YES;
    }
    return self;
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

-(void)dealloc{
    debug_NSLog(@"dealloc detail");
    [_commonDetailDataSource setDelegate:nil];
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(_commonDetailDataSource);
    TT_RELEASE_SAFELY(_contnetId);
    TT_RELEASE_SAFELY(_headView);
    [_webView setDelegate:nil];
    TT_RELEASE_SAFELY(_webView);
    TT_RELEASE_SAFELY(_toolBarView);
    TT_RELEASE_SAFELY(_btnShowAll);
    TT_RELEASE_SAFELY(_btnWriteComment);
    TT_RELEASE_SAFELY(_commentList);
    TT_RELEASE_SAFELY(_inputView);
    [_networkAssistant setDelegate:nil];
    TT_RELEASE_SAFELY(_networkAssistant);
    [super dealloc];
}

#pragma mark -
#pragma mark 初始化内容页
-(void)initHeadView{
    if (!self.headView) {
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 200)];
        self.headView = temp;
        TT_RELEASE_SAFELY(temp);
        [self.headView setBackgroundColor:[UIColor clearColor]];
    }
    if (!self.webView) {
        UIWebView *temp = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 175)];
        self.webView = temp;
        TT_RELEASE_SAFELY(temp);
        [self.webView setDelegate:self];
        [self.webView setOpaque:YES];
        [self.webView setBackgroundColor:[UIColor clearColor]];
        [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
        [self.headView addSubview:self.webView];
    }
    if (!self.toolBarView) {
        UIView *temp = [[UIView alloc] initWithFrame:CGRectMake(0, self.webView.height, self.view.width, 25)];
        self.toolBarView = temp;
        TT_RELEASE_SAFELY(temp);
        [self.toolBarView setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg_1.png")]];
        [self.headView addSubview:self.toolBarView];
    }
    self.commentList = [self createButtonWithTitle:@"评论列表"
                                             image:@"bundle://ico_que.png"
                                            imageH:@"bundle://ico_que.png"];
    [self.commentList setLeft:5];
    [self.commentList setTag:10];
    [self.commentList setTop:(self.toolBarView.height-self.commentList.height)/2];
    [self.commentList setTitleColor:RGBCOLOR(33, 36, 33) forState:UIControlStateNormal];
    [self.toolBarView addSubview:self.commentList];


    //查看全部
    self.btnShowAll = [self createButtonWithTitle:@"查看全部"
                                             image:nil
                                            imageH:nil];
    [self.btnShowAll setLeft:self.toolBarView.width-self.btnShowAll.width-5];
    [self.btnShowAll setTag:11];
    [self.btnShowAll setTop:(self.toolBarView.height-self.btnShowAll.height)/2];
    [self.btnShowAll setTitleColor:RGBCOLOR(0, 77, 142) forState:UIControlStateNormal];
    [self.toolBarView addSubview:self.btnShowAll];

    debug_NSLog(@"btn show all:%@",NSStringFromCGRect(self.btnShowAll.frame));

    //说2句
    self.btnWriteComment = [self createButtonWithTitle:@"说两句"
                                             image:@"bundle://ico_write.png"
                                            imageH:@"bundle://ico_write.png"];
    [self.btnWriteComment setLeft:self.btnShowAll.left-self.btnWriteComment.width-5];
    [self.btnWriteComment setTag:12];
    [self.btnWriteComment setTop:(self.toolBarView.height-self.btnWriteComment.height)/2];
    [self.btnWriteComment setTitleColor:RGBCOLOR(0, 77, 142) forState:UIControlStateNormal];
//    [self.toolBarView addSubview:self.btnWriteComment];


    if (!self.inputView) {
        MessageInputView *temp = [[MessageInputView alloc] initWithFrame:CGRectMake(0, self.view.height-postViewHeight, self.view.width, postViewHeight)];
        self.inputView = temp;
        TT_RELEASE_SAFELY(temp);

        self.inputView.textView.delegate = self;
        [self.inputView.sendButton addTarget:self action:@selector(sendPressed:)
                            forControlEvents:UIControlEventTouchUpInside];


        [self.inputView.selectButton addTarget:self action:@selector(selectedPressed:)
                              forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:self.inputView];
    }
//    [self toggleBanner];
}

-(UIButton *)createButtonWithTitle:(NSString *)title
                             image:(NSString *)image
                            imageH:(NSString *)imageH{
    UIButton *temp = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [temp setTitle:title forState:UIControlStateNormal];
    }
    if (image) {
        [temp setImage:TTIMAGE(image) forState:UIControlStateNormal];
    }
    if (imageH) {
        [temp setImage:TTIMAGE(imageH) forState:UIControlStateHighlighted];
    }
    [temp addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [[temp titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [temp sizeToFit];
    return temp;
}


#pragma mark -
#pragma mark 按纽事件
-(void)buttonClick:(id)sender{
    int tag = [sender tag];
    if (tag==11) {
        //查看全部
        NSString *url = [NSString stringWithFormat:@"tt://commemtList/%@",self.contnetId];
        TTOpenURL(url);
    }
    if (tag==12) {
        //说两句
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createModel {
    if (!self.commonDetailDataSource) {
        CommonDetailDataSource *temp = [[CommonDetailDataSource alloc] initWithConentId:self.contnetId loadList:NO];
        self.commonDetailDataSource = temp;
        TT_RELEASE_SAFELY(temp);
        [self.commonDetailDataSource setDelegate:self];
    }
    self.dataSource = self.commonDetailDataSource;
}
///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<UITableViewDelegate>)createDelegate {
    return [[[TTTableViewDragRefreshDelegate alloc] initWithController:self] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //init left nav bar
    [self showHUD:@"正在加载数据" isLoading:YES];
    [self.tableView setHidden:YES];
    
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

    [self initHeadView];
    [self.tableView setTableHeaderView:self.headView];



    [self.tableView setBackgroundView:nil];
    [self.view setBackgroundColor:RGBCOLOR(151, 173, 179)];
}
-(void)leftNavClick:(id)sender{
//    [[self presentingViewController] dismissModalViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    // 键盘高度变化通知，ios5.0新增的
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];

    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.inputView setTop:self.view.height-(keyboardRect.size.height+self.inputView.height)];
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary* userInfo = [notification userInfo];

    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];

    NSTimeInterval animationDuration;
    [self.inputView setTop:self.view.height-self.inputView.height];
//    showCommentView = NO;

    [animationDurationValue getValue:&animationDuration];
    
}


#pragma mark -
#pragma mark MBProgressHUDDelegate methods
- (void)hudWasHidden:(MBProgressHUD *)hud {
    [mHud removeFromSuperview];
    [mHud setDelegate:nil];
    TT_RELEASE_SAFELY(mHud);
}

#pragma mark -
#pragma mark CommonDetailDataSourceDelegate
-(void)contentLoadOver:(MessageDataModel *)dataModel{
    if (!dataModel.comments||[dataModel.comments count]<=0){
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        zeroComment = YES;
    }
    else{
        zeroComment = NO;
    }
    
    //read local html file
    NSString *path = [[[NSBundle mainBundle] bundlePath]
                      stringByAppendingPathComponent:@"content.htm"];

    NSString *templateStr = [[NSString alloc]initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$title"
                                                         withString:dataModel.title];
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$custlist"
                                                         withString:dataModel.messageDetailMeta];
  
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$content"
                                                         withString:dataModel.content];
    

    [self.webView loadHTMLString:templateStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [mHud hide:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.tableView setHidden:NO];
    CGSize actualSize = [webView sizeThatFits:CGSizeZero];
    CGRect newFrame = webView.frame;
    newFrame.size.height = actualSize.height;
    webView.frame = newFrame;
    [self.toolBarView setTop:webView.height];
//    [self.toolBarView setTop:self.tableView.height-self.toolBarView.height];
    CGFloat height = webView.height+self.toolBarView.height;
    
    UIView *view=self.tableView.tableHeaderView;
    [view setHeight:height];
    self.tableView.tableHeaderView =view;

    NSString *meta = [NSString stringWithFormat:@"document.getElementsByName(\"viewport\")[0].content = \"width=%f, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no\"", webView.frame.size.width];
    [webView stringByEvaluatingJavaScriptFromString:meta];
    
    [UIView commitAnimations];
}


-(void)loadURL:(NSURL*)url
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //    ASIWebPageRequest *request= [ASIWebPageRequest requestWithURL:url];
    [request setDelegate:self];
    //    [request setUrlReplacementMode:ASIReplaceExternalResourcesWithData];
    [request setDidFailSelector:@selector(webPageFetchFailed:)];
    [request setDidFinishSelector:@selector(webPageFetchSucceeded:)];
    //设置缓存
    [request setDownloadCache:[ASIDownloadCache sharedCache]];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    //    [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setDownloadDestinationPath:[[ASIDownloadCache sharedCache]pathToStoreCachedResponseDataForRequest:request]];
    [request startAsynchronous];
}

- (void)webPageFetchFailed:(ASIHTTPRequest *)theRequest
{
    // Obviously you should handle the error properly...
    NSLog(@"%@",[theRequest error]);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"error1.html" ofType:nil inDirectory:@"WebResources/Error"];
    NSURL  *url=[NSURL fileURLWithPath:path];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (void)webPageFetchSucceeded:(ASIHTTPRequest *)theRequest
{

    debug_NSLog(@"responseEncoding:%d",[theRequest responseEncoding]);
    NSString *response = [NSString stringWithContentsOfFile:
                          [theRequest downloadDestinationPath]
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil];
    // Note we're setting the baseURL to the url of the page we downloaded. This is important!
    [self.webView loadHTMLString:response baseURL:[theRequest url]];
    //[viewer loadHTMLString:response baseURL:nil];
}

-(void)sendPressed:(id)sender{
    if (!self.inputView.textView.text) {
        TTAlertNoTitle(@"请输入评论内容");
        return;
    }
    [self.inputView.textView resignFirstResponder];

    [self showHUD:@"正在提交评论" isLoading:YES];
    NSString* url = [NSString stringWithFormat:INTERFACE_POST_COMMENT,MAIN_DOMAIN,self.commonDetailDataSource.contentId,[self.inputView.textView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],(self.inputView.selectButton.selected?@"true":@"false")];
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
        self.inputView.sendButton.enabled = NO;
        [[self.inputView textView] setText:nil];
        [self.commonDetailDataSource.commonDetailDataSourceModel
         load:TTURLRequestCachePolicyNone
         more:NO];
    }
}


-(void)fetchDataOver:(BOOL)succeed operFlag:(NSString *)operFlag{
    if (succeed) {
        [self showHUD:@"评论成功" isLoading:NO];
        [self reload];
    }
}

-(void)selectedPressed:(id)sender{
    UIButton *temp = (UIButton *)sender;
    [temp setSelected:!temp.selected];
}

- (void) toggleBanner {
    if (!self.inputView) {
        MessageInputView *temp = [[MessageInputView alloc] initWithFrame:CGRectMake(0, self.view.height+postViewHeight, self.view.width, postViewHeight)];
        self.inputView = temp;
        TT_RELEASE_SAFELY(temp);

        self.inputView.textView.delegate = self;
        [self.inputView.sendButton addTarget:self action:@selector(sendPressed:)
                            forControlEvents:UIControlEventTouchUpInside];


        [self.inputView.selectButton addTarget:self action:@selector(selectedPressed:)
                            forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:self.inputView];
    }
    if (showCommentView) {
        [self.inputView setTop:self.view.height+self.inputView.height];
        [CoreAnimationEffect animationMoveDown:self.inputView duration:0.5];
        [[self.inputView textView] resignFirstResponder];
        showCommentView = NO;
    }
    else{
        [self.inputView setTop:self.view.height-self.inputView.height];
        [CoreAnimationEffect animationMoveUp:self.inputView duration:0.5];
        showCommentView = YES;
    }
}


- (void)scrollToBottomAnimated:(BOOL)animated{
    
}
#pragma mark -
#pragma mark PostCommentViewDelegate
-(void)postCommentState:(BOOL)success{
    if (success) {
        [self showHUD:@"评论成功" isLoading:NO];
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

@end
