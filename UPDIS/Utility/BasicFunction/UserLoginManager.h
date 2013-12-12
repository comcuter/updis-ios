//
//  UserLoginManager.h
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	NotLoggedIn,
	LoggingIn,
	LoggedIn
} LoginState;

@interface UserLoginManager : NSObject<TTURLRequestDelegate>{
	int _requestCount;
    id _originalUserInfo;
}

@property (nonatomic ,retain) NSDictionary *originalParameters;

@property (nonatomic ,readonly) LoginState loginState;

@property (nonatomic ,retain) NSString *requestURL;

@property (nonatomic ,assign) id<TTURLRequestDelegate> delegate;


+ (UserLoginManager *)userLoginManager;
@end
