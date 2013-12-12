//
//  DataBase.h
//  CubeNews
//
//  Created by Melvin on 11-1-26.
//  Copyright 2011 WDIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>


@interface DataBase : NSObject {

}
+ (PLSqliteDatabase *) setup;

+ (void) close;
@end
