//
//  MURLJSONResponse.h
//  WEIDB
//
//  Created by Melvin on 13-8-28.
//  Copyright (c) 2013年 WDT. All rights reserved.
//


#import "Three20Network/TTURLResponse.h"

extern NSString* const kMJSONErrorDomain;
extern NSInteger const kMJSONErrorCodeInvalidJSON;

@interface MURLJSONResponse : NSObject<TTURLResponse>{
    id _rootObject;
}

@property (nonatomic, retain, readonly) id rootObject;

@end
