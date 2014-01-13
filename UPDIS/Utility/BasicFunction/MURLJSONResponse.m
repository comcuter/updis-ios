//
//  MURLJSONResponse.m
//  WEIDB
//
//  Created by Melvin on 13-8-28.
//  Copyright (c) 2013年 WDT. All rights reserved.
//

#import "MURLJSONResponse.h"
// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/TTDebug.h"


@implementation MURLJSONResponse

NSString* const kMJSONErrorDomain = @"three20.ext.m.json";
NSInteger const kMJSONErrorCodeInvalidJSON = 101;

@synthesize rootObject  = _rootObject;

- (void)dealloc
{
    TT_RELEASE_SAFELY(_rootObject);
    [super dealloc];
}

- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response data:(id)data
{
    TTDASSERT([data isKindOfClass:[NSData class]]);
    TTDASSERT(nil == _rootObject);
    NSError* err = nil;
    if ([data isKindOfClass:[NSData class]]) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            _rootObject = [[NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:&err] retain];
        }
    }
    return err;
}

@end
