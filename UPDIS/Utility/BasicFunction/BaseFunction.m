//
//  BaseFunction.m
//  PhoneReport
//
//  Created by Melvin on 11-6-14.
//  Copyright 2011年 ChangWei. All rights reserved.
//

#import "BaseFunction.h"
#import "AppDelegate.h"
#import "Constant.h"
#import "Debug.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import "Reachability.h"
#import "DataBase.h"

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

#define CHUNK_SIZE 1024

NSString *convertBlankStringToDashIfPossible(NSString *originalString)
{
    if (originalString.length == 0) {
        return @"-";
    } else {
        return originalString;
    }
}

NSString *convertBoolToChinese(BOOL boolValue)
{
    if (boolValue) {
        return @"是";
    } else {
        return @"否";
    }
}

@implementation BaseFunction

+ (NSString *)getMacAddress2
{
    return [APService openUDID];
}

+ (NSString *)getMacAddress
{
    int                 mgmtInfoBase[6];
    char                *msgBuffer = NULL;
    NSString            *errorFlag = NULL;
    size_t              length;

    // Setup the management Information Base (mib)
    mgmtInfoBase[0] = CTL_NET;        // Request network subsystem
    mgmtInfoBase[1] = AF_ROUTE;       // Routing table info
    mgmtInfoBase[2] = 0;
    mgmtInfoBase[3] = AF_LINK;        // Request link layer information
    mgmtInfoBase[4] = NET_RT_IFLIST;  // Request all configured interfaces

    // With all configured interfaces requested, get handle index
    if ((mgmtInfoBase[5] = if_nametoindex("en0")) == 0)
        errorFlag = @"if_nametoindex failure";
    // Get the size of the data available (store in len)
    else if (sysctl(mgmtInfoBase, 6, NULL, &length, NULL, 0) < 0)
        errorFlag = @"sysctl mgmtInfoBase failure";
    // Alloc memory based on above call
    else if ((msgBuffer = malloc(length)) == NULL)
        errorFlag = @"buffer allocation failure";
    // Get system information, store in buffer
    else if (sysctl(mgmtInfoBase, 6, msgBuffer, &length, NULL, 0) < 0)
    {
        free(msgBuffer);
        errorFlag = @"sysctl msgBuffer failure";
    }
    else
    {
        // Map msgbuffer to interface message structure
        struct if_msghdr *interfaceMsgStruct = (struct if_msghdr *) msgBuffer;

        // Map to link-level socket structure
        struct sockaddr_dl *socketStruct = (struct sockaddr_dl *) (interfaceMsgStruct + 1);

        // Copy link layer address data in socket structure to an array
        unsigned char macAddress[6];
        memcpy(&macAddress, socketStruct->sdl_data + socketStruct->sdl_nlen, 6);

        // Read from char array into a string object, into traditional Mac address format
        NSString *macAddressString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                                      macAddress[0], macAddress[1], macAddress[2], macAddress[3], macAddress[4], macAddress[5]];
        NSLog(@"Mac Address: %@", macAddressString);

        // Release the buffer memory
        free(msgBuffer);

        return macAddressString;
    }

    // Error...
    NSLog(@"Error: %@", errorFlag);

    return nil;
}

+ (BOOL)isNetworkAvailableFlags:(SCNetworkReachabilityFlags *)outFlags {
	SCNetworkReachabilityRef	defaultRouteReachability;
	struct sockaddr_in			zeroAddress;

	bzero(&zeroAddress, sizeof(zeroAddress));
	zeroAddress.sin_len = sizeof(zeroAddress);
	zeroAddress.sin_family = AF_INET;

	defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);

	SCNetworkReachabilityFlags flags;
	BOOL gotFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
	if (!gotFlags) {
        return NO;
    }
	BOOL isReachable = flags & kSCNetworkReachabilityFlagsReachable;
	BOOL noConnectionRequired = !(flags & kSCNetworkReachabilityFlagsConnectionRequired);
	if ((flags & kSCNetworkReachabilityFlagsIsWWAN)) {
		noConnectionRequired = YES;
	}

	if (outFlags) {
		*outFlags = flags;
	}

	return isReachable && noConnectionRequired;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]] lowercaseString];
}

+ (NSString*)fileMD5:(NSString*)path
{
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];
    if( handle== nil ) return @"ERROR GETTING FILE MD5"; // file didnt exist

    CC_MD5_CTX md5;

    CC_MD5_Init(&md5);

    BOOL done = NO;
    while(!done)
    {
        NSData* fileData = [handle readDataOfLength: CHUNK_SIZE ];
        CC_MD5_Update(&md5, [fileData bytes], [fileData length]);
        if( [fileData length] == 0 ) done = YES;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(digest, &md5);
    NSString* s = [NSString stringWithFormat: @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                   digest[0], digest[1],
                   digest[2], digest[3],
                   digest[4], digest[5],
                   digest[6], digest[7],
                   digest[8], digest[9],
                   digest[10], digest[11],
                   digest[12], digest[13],
                   digest[14], digest[15]];
    return s;
}

+(BOOL)fetchDataFromServer:(NSString *)operFlag parameter:(NSDictionary *)parameter
{
    BOOL succeed = NO;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", MAIN_DOMAIN, operFlag]];    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    debug_NSLog(@"url:%@",url);
    [request setUseCookiePersistence:YES];
    [request setTimeOutSeconds:FETCH_TIME_OUT];
    if (parameter) {
        for (NSString * key in parameter) {
            [request setPostValue:[parameter objectForKey:key] forKey:key];
        }
    }
    [request startSynchronous];
    
    NSData *responseData = nil;
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseData];
    }
    if (!error) {
        NSString *dataStr =[[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding] autorelease];
        if (!dataStr) {
            dataStr = [responseData description];
        }
        
        if (dataStr) {
            debug_NSLog(@"%@",dataStr);
            @try {
                succeed = YES;
                id result;
                NSError *e = nil;
                result = [NSJSONSerialization JSONObjectWithData:[dataStr dataUsingEncoding:NSUTF8StringEncoding]
                                                         options:NSJSONReadingMutableContainers
                                                           error:&e];
                if ([operFlag isEqualToString:USER_LOGIN]) {
                    if (result) {
                        for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
                            TTDPRINT(@"Cookie name: %@, domain: %@, value: %@", cookie.name, cookie.domain, cookie.value);
                            TTDPRINT(@"Saving cookie: %@", cookie.name);
                            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"cookies"];
                        }

                        debug_NSLog(@"result:%@",result);
                        [dataStr writeToFile:USER_LOGIN_CACHE_FILE atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    }
                }
                
                if ([operFlag isEqualToString:USER_REGPHONE]) {
                    if (result) {
                        debug_NSLog(@"result:%@",result);
                        [dataStr writeToFile:USER_REG_PHONE_CACHE_FILE atomically:YES encoding:NSUTF8StringEncoding error:nil];
                    }
                }
            }
            @catch (NSException *exception) {
                debug_NSLog(@"%@",[exception debugDescription]);
            }
        }
    } else {
        debug_NSLog(@"error:%@",[error domain]);
    }
    return succeed;
}

+ (BOOL)checkIsNull:(id)object{
    BOOL sFlag = NO;
    @try {
        if (![object isKindOfClass:[NSNull class]] &&
            object&&
            ![object isEqualToString:@"<null>"]&&
            ![[NSString stringWithFormat:@"%@",object] isEqualToString:@"<null>"]&&
            ![[NSString stringWithFormat:@"%@",object] isEqualToString:@"null"]) {
            sFlag = YES;
        }
    }
    @catch (NSException *exception) {
        debug_NSLog(@"%@",[exception debugDescription]);
        sFlag = NO;
    }
    return sFlag;
}

+ (NSString *)flattenHTML:(NSString *)html
{
    NSScanner *theScanner;
    NSString *text = nil;
    theScanner = [NSScanner scannerWithString:html];

    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString: [ NSString stringWithFormat:@"%@>", text] withString:@" "];
    }
    return html;
}

@end
