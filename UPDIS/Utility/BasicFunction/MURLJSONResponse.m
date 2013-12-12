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


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_rootObject);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTURLResponse


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSError*)request:(TTURLRequest*)request processResponse:(NSHTTPURLResponse*)response
               data:(id)data {
    // This response is designed for NSData objects, so if we get anything else it's probably a
    // mistake.
    TTDASSERT([data isKindOfClass:[NSData class]]);
    TTDASSERT(nil == _rootObject);
    NSError* err = nil;
    if ([data isKindOfClass:[NSData class]]) {

        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 4.9) {
            _rootObject = [[NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:&err] retain];
        }
        else{
//            @try {
//
//                NSString* json = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
//                _rootObject = [[json objectFromJSONString] retain];
//            }
//            @catch (NSException *exception) {
//                err = [NSError errorWithDomain:kMJSONErrorDomain
//                                          code:kMJSONErrorCodeInvalidJSON
//                                      userInfo:[exception userInfo]];
//            }
//            @finally {
//                
//            }
        }
    }
    return err;
}



@end
