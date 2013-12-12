//
//  UserLoginManager.m
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "UserLoginManager.h"

#define LOGIN_SUCCESS 1
#define LOGIN_FAIL 0

static UserLoginManager *gUserLoginManager = nil;

@implementation UserLoginManager

+ (UserLoginManager *)userLoginManager {
	if(!gUserLoginManager){
		TTDPRINT(@"Initializing the login controller");
		gUserLoginManager = [[UserLoginManager alloc] init];
	}
	return gUserLoginManager;
}

- (id)init {
	if(self = [super init]){
		_requestCount = 0;
		_loginState = NotLoggedIn;
	}
	return self;
}

- (void)dealloc {
	_delegate = nil;
	gUserLoginManager = nil;
	self.requestURL = nil;
    TT_RELEASE_SAFELY(_originalParameters);
	[super dealloc];
}

/**
 *	Overwrote this to actually return the shared instance of the LoginController and NOT a new instance which will be created
 */
-(id)initWithNavigatorURL:(NSURL *)URL query:(NSDictionary *)query {
	TTDPRINT(@"Returning the shared controller");
	return [[self class] userLoginManager];
}


#pragma mark -
#pragma mark Send/Parse Request
/**
 *  There could be an instance where you just want to simply log
 *  the user in and do nothing else.  In that case, specify
 *  a login URL and make the userInfo some sort of special
 *  string that denotes this is a login request
 */
//- (void)loginWithDelegate:(id<TTURLRequestDelegate>)delegate {
//	[self sendRequestWithURL:LOGIN_URL delegate:delegate userInfo:nil parameters:nil];
//}

- (void)sendRequestWithURL:(NSString *)URL delegate:(id<TTURLRequestDelegate>)delegate {
    [self sendRequestWithURL:URL delegate:delegate userInfo:nil parameters:nil];
}

- (void)sendRequestWithURL:(NSString *)URL delegate:(id<TTURLRequestDelegate>)delegate userInfo:(id)userInfo {
    [self sendRequestWithURL:URL delegate:delegate userInfo:userInfo parameters:nil];
}

- (void)sendRequestWithURL:(NSString *)URL delegate:(id<TTURLRequestDelegate>)delegate userInfo:(id)userInfo parameters:(NSDictionary *)parameters {
	_delegate = delegate;
	self.requestURL = URL;
    _originalUserInfo = userInfo;
    _originalParameters = [parameters retain];

	TTDPRINT(@"Going to user URL: %@", URL);
	TTURLRequest *request = [TTURLRequest requestWithURL:URL delegate:self];
	request.cachePolicy = TTURLRequestCachePolicyNone;
	request.response = [[TTURLDataResponse alloc] init];

    request.userInfo = _originalUserInfo;
    if(_originalParameters) {
        request.httpMethod = @"POST";
        [request.parameters setValuesForKeysWithDictionary:_originalParameters];
    }
    else {
        request.httpMethod = @"GET";
    }

	TTDPRINT(@"Original user info: %@ request parameters: %@", _originalParameters, request.parameters);

    /**
     *  There could be an instance where you just want to simply log
     *  the user in and do nothing else.  In that case, specify
     *  a login URL and make the userInfo some sort of special
     *  string that denotes this is a login request
     */
	//if ([self.requestURL isEqualToString:LOGIN_URL]) {
	//	request.userInfo = LOGIN_REQUEST;
	//}

	[request send];
}

- (void)requestDidFinishLoad:(TTURLRequest*)request {
	TTURLDataResponse *response = request.response;
	NSString *responseBody = [[NSString	alloc] initWithData:response.data encoding:NSUTF8StringEncoding];
	TTDPRINT(@"Logincontroller response: %@", responseBody);

	int loginStatus = 0;
	TTDPRINT(@"Login status: %i", loginStatus);
	switch (loginStatus) {
		case LOGIN_SUCCESS:
			[self successfulLoginWithRequest:request];
			break;
		case LOGIN_FAIL:
			[self failedLogin];
			break;
		default:
			break;
	}

	TT_RELEASE_SAFELY(responseBody);
}


#pragma mark -
#pragma mark Private Methods
/**
 *	Tries to load from NSUserDefaults if the cookies aren't set (automatic) before showing the login form
 */
- (void)failedLogin {
	TTDPRINT(@"Not logged in, showing the login form");
}

/**
 *	Save the cookies, username and password in NSUserDefaults and then call the delegate requestDidFinishLoad
 */
- (void)successfulLoginWithRequest:(TTURLRequest*)request {
	TTDPRINT(@"I'm logged in! Hooray!");

	//Only save atvescape cookies
	NSMutableArray *saveCookies = [NSMutableArray array];
	for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
		TTDPRINT(@"Cookie name: %@, domain: %@, value: %@", cookie.name, cookie.domain, cookie.value);
        //Could optionally check the cookie domain here to only save specific cookies
        TTDPRINT(@"Saving cookie: %@", cookie.name);
        [saveCookies addObject:cookie];
	}
	[[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:saveCookies] forKey:@"cookies"];
	_loginState = LoggedIn;

	[[[TTNavigator navigator] visibleViewController] dismissModalViewController];
	[_delegate requestDidFinishLoad:request];
	_delegate = nil;
	self.requestURL = nil;
    _originalUserInfo = nil;
    TT_RELEASE_SAFELY(_originalParameters);
}

/*
 *	Submits the username and password to the server
 */
- (void)submitLoginForm {
	_loginState = LoggingIn;
	_requestCount++;
    

	TTURLRequest *request = [TTURLRequest requestWithURL:_requestURL delegate:self];
	//Don't use a cache because it can be pretty dynamic content
	request.cachePolicy = TTURLRequestCachePolicyNone;
	request.response = [[TTURLDataResponse alloc] init];
	request.httpMethod = @"POST";
	[request.parameters setObject:[_usernameField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"username"];
	[request.parameters setObject:[_passwordField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"password"];
	request.userInfo = _originalUserInfo;
    if(_originalParameters) {
        [request.parameters setValuesForKeysWithDictionary:_originalParameters];
    }
    TTDPRINT(@"Original user info: %@ request parameters: %@", _originalUserInfo, request.parameters);

	if ([self.requestURL isEqualToString:LOGIN_URL]) {
		request.userInfo = LOGIN_REQUEST;
	}

	[request send];
	TTDPRINT(@"Sent the login form");
}
@end
