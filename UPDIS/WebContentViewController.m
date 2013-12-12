//
//  WebContentViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-15.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "WebContentViewController.h"
#import "MURLJSONResponse.h"
#import "UserModel.h"
#import "BaseFunction.h"


@interface WebContentViewController ()

@end

@implementation WebContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithFileName:(NSString *)fileName pageData:(NSDictionary *)pageData
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setFileName:fileName];
        [self setPageData:pageData];
    }
    return self;
}

- (id)initWithFileName:(NSString *)fileName
{
    self = [super init];
    if (self) {
        // Custom initialization
        [self setFileName:fileName];
    }
    return self;
}


- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadPageData];
}

-(void)loadPageData{
    [self showHUD:@"正在获取数据" isLoading:YES];
    NSString* url = [NSString stringWithFormat:INTERFACE_FETCH_USER_DETAIL,MAIN_DOMAIN,[[self.pageData objectForKey:@"userId"] integerValue]];
    if ([self.fileName isEqualToString:@"about.html"]) {
        url = [NSString stringWithFormat:INTERFACE_FETCH_ABOUT,MAIN_DOMAIN];
    }
    if ([self.fileName isEqualToString:@"version.html"]) {
        url = [NSString stringWithFormat:INTERFACE_FETCH_VERSION,MAIN_DOMAIN,2];
    }
    
    TTURLRequest* request = [TTURLRequest
                             requestWithURL: url
                             delegate: self];
    request.cacheExpirationAge = TT_CACHE_EXPIRATION_AGE_NEVER;
    [request setCachePolicy:TTURLRequestCachePolicyDefault];
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [request setValue:cookie
   forHTTPHeaderField:@"Cookie"];

    TTDPRINT(@"cookie:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]);
    MURLJSONResponse* response = [[MURLJSONResponse alloc] init];
    request.response = response;
    TT_RELEASE_SAFELY(response);

    [request send];
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
-(void)loadView{
    [super loadView];
    if (!self.webView) {
        UIWebView *temp = [[UIWebView alloc] initWithFrame:self.view.frame];
        self.webView = temp;
        TT_RELEASE_SAFELY(temp);
        [self.webView setDelegate:self];

        [self.webView setBackgroundColor:[UIColor clearColor]];
//        [(UIScrollView *)[[self.webView subviews] objectAtIndex:0] setBounces:NO];
        [self.view addSubview:self.webView];

        CGFloat paddingY = 30;
        if ([self.fileName isEqualToString:@"about.html"]||[self.fileName isEqualToString:@"version.html"]) {
            paddingY = 0;

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


            TTImageView *itemTitle = [[TTImageView alloc] init];
            [itemTitle setUrlPath:@"bundle://logo3.png"];
            [self.navigationItem setTitleView:itemTitle];
            TT_RELEASE_SAFELY(itemTitle);
        }

        [self.view setHeight:self.view.height-paddingY-49];
        [self.webView setHeight:self.webView.height-paddingY-49];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
}
-(void)dealloc{
    TT_RELEASE_SAFELY(_fileName);
    TT_RELEASE_SAFELY(_pageData);
    [_webView stopLoading];
    [_webView setDelegate:self];
    TT_RELEASE_SAFELY(_webView);
    [mHud setDelegate:nil];
    [super dealloc];
}

-(void)leftNavClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark -
#pragma mark UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *requestString = [[request URL] absoluteString];
    debug_NSLog(@"requestString:%@",requestString);
	NSArray *components = [requestString componentsSeparatedByString:@"::"]; //提交数组
	if ([components count] > 1 && [[(NSString *)[components objectAtIndex:0] lowercaseString] isEqualToString:@"gotoapp"])
	{
		if([[(NSString *)[components objectAtIndex:1] lowercaseString] isEqualToString:@"back"]){
            if (self.delegate&&[self.delegate respondsToSelector:@selector(back2ListView)]) {
                [self.delegate back2ListView];
            }
		}

		return NO;
	}
	return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{

}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [mHud hide:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}
-(void)loadWebViewDataByString:(NSString *)data{

    NSString *path = [[[NSBundle mainBundle] bundlePath]
                      stringByAppendingPathComponent:self.fileName];

    NSString *templateStr = [[NSString alloc]initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];

    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$about"
                                                         withString:data];

    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$version"
                                                         withString:data];

    [self.webView loadHTMLString:templateStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
}
-(void)loadWebViewData:(UserModel *)userModel{
    //read local html file
    
    NSString *path = [[[NSBundle mainBundle] bundlePath]
                      stringByAppendingPathComponent:self.fileName];

    NSString *templateStr = [[NSString alloc]initWithContentsOfFile:path
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];


    

    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$name"
                                                         withString:userModel.name];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$dept"
                                                         withString:userModel.dept];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$birthday"
                                                         withString:userModel.birthday];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$gender"
                                                         withString:userModel.gender];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$specialty"
                                                         withString:userModel.specialty];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$educational"
                                                         withString:userModel.educational];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$degree"
                                                         withString:userModel.degree];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$graduationdate"
                                                         withString:userModel.graduationDate];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$entrydate"
                                                         withString:userModel.entryDate];

    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$rank"
                                                         withString:userModel.rank];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$titles"
                                                         withString:userModel.titles];
    
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$resume"
                                                         withString:userModel.resume];


    //data:image/jpg;base64,
    NSData *imageData = UIImagePNGRepresentation(TTIMAGE(userModel.iconUrl));

    NSString *pictureDataString = [imageData base64Encoding];

    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$iconurl"
                                                         withString:[@"data:image/png;base64," stringByAppendingString:pictureDataString]];


    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$mobilePhone"
                                                         withString:userModel.mobilePhone];
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$officePhone"
                                                         withString:userModel.officePhone];
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$homeNum"
                                                         withString:userModel.homeNum];
    templateStr = [templateStr stringByReplacingOccurrencesOfString:@"$mail"
                                                         withString:userModel.mail];


    [self.webView loadHTMLString:templateStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
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

    if ([feed objectForKey:@"aboutContent"]) {
        //关于
        [self loadWebViewDataByString:[feed objectForKey:@"aboutContent"]];
        return;
    }
    if ([self.fileName isEqualToString:@"version.html"]) {
        [self loadWebViewDataByString:[feed objectForKey:@"releaseVersion"]];
        return;
    }
    
    NSDictionary* entry = [feed objectForKey:@"data"];
    UserModel *userModel = [[UserModel alloc] init];
    userModel.userId = [entry objectForKey:@"userId"];
    userModel.name = [entry objectForKey:@"name"];
    if ([BaseFunction checkIsNull:[entry objectForKey:@"dept"]]) {
        userModel.dept = [entry objectForKey:@"dept"];
    }
    else{
        userModel.dept = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"birthday"]]) {
        userModel.birthday = [entry objectForKey:@"birthday"];
    }
    else{
        userModel.birthday = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"gender"]]) {
        userModel.gender = [entry objectForKey:@"gender"];
    }
    else{
        userModel.gender = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"specialty"]]) {
        userModel.specialty = [entry objectForKey:@"specialty"];
    }
    else{
        userModel.specialty = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"dept"]]) {
        userModel.dept = [entry objectForKey:@"dept"];
    }
    else{
        userModel.dept = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"educational"]]) {
        userModel.educational = [entry objectForKey:@"educational"];
    }
    else{
        userModel.educational = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"degree"]]) {
        userModel.degree = [entry objectForKey:@"degree"];
    }
    else{
        userModel.degree = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"graduationDate"]]) {
        userModel.graduationDate = [entry objectForKey:@"graduationDate"];
    }
    else{
        userModel.graduationDate = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"entryDate"]]) {
        userModel.entryDate = [entry objectForKey:@"entryDate"];
    }
    else{
        userModel.entryDate = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"rank"]]) {
        userModel.rank = [entry objectForKey:@"rank"];
    }
    else{
        userModel.rank = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"titles"]]) {
        userModel.titles = [entry objectForKey:@"titles"];
    }
    else{
        userModel.titles = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"resume"]]) {
        userModel.resume = [entry objectForKey:@"resume"];
    }
    else{
        userModel.resume = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"mobilePhone"]]) {
        userModel.mobilePhone = [entry objectForKey:@"mobilePhone"];
    }
    else{
        userModel.mobilePhone = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"officePhone"]]) {
        userModel.officePhone = [entry objectForKey:@"officePhone"];
    }
    else{
        userModel.officePhone = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"homeNum"]]) {
        userModel.homeNum = [entry objectForKey:@"homeNum"];
    }
    else{
        userModel.homeNum = @"";
    }
    if ([BaseFunction checkIsNull:[entry objectForKey:@"mail"]]) {
        userModel.mail = [entry objectForKey:@"mail"];
    }
    else{
        userModel.mail = @"";
    }

    if ([BaseFunction checkIsNull:[entry objectForKey:@"iconUrl"]]) {
        userModel.iconUrl = [entry objectForKey:@"iconUrl"];
    }
    else{
        userModel.iconUrl = @"//default_user_icon.png";
    }

    [self loadWebViewData:[userModel autorelease]];
}

@end
