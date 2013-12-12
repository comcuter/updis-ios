//
//  Keychain.h
//  Utility Save data to keychain
//
//  Created by Melvin Young on 11-11-2.
//  Copyright (c) 2011年 ChangWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>


@interface Keychain : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)delete:(NSString *)service;
@end
