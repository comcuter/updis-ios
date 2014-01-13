//
//  BaseFunction.h
//  PhoneReport
//
//  Created by Melvin on 11-6-14.
//  Copyright 2011年 ChangWei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"
#import "DataBase.h"
#import "CoreAnimationEffect.h"

@interface BaseFunction : NSObject

+ (NSString *)getMacAddress;
+ (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags;
+ (NSString *)md5:(NSString *)str;
+ (NSString*)fileMD5:(NSString*)path;
+ (BOOL)fetchDataFromServer:(NSString *)operFlag parameter:(NSDictionary *)parameter;

+(BOOL)checkIsNull:(id)object;
+ (NSString *)flattenHTML:(NSString *)html;
@end
