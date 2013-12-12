//
//  ReLoginAssisant.h
//  UPDIS
//
//  Created by Melvin on 13-7-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkAssistant.h"

@protocol ReLoginAssisantDelegate <NSObject>
@required
- (void)relogin:(BOOL)success;
@end

@interface ReLoginAssisant : NSObject<TTURLRequestDelegate,NetworkAssistantDelegate>

@property (nonatomic ,assign) id<ReLoginAssisantDelegate> delegate;


+ (id)sharedManager;
- (void)reloginUser;

@end
