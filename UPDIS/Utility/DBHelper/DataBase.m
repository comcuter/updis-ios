//
//  DataBase.m
//  CubeNews
//
//  Created by Melvin on 11-1-26.
//  Copyright 2011 WDIT. All rights reserved.
//

#import "DataBase.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "Constant.h"
#import "Debug.h"
static PLSqliteDatabase * dbPointer;

@implementation DataBase
+ (PLSqliteDatabase *) setup{
	if (dbPointer) {
		return dbPointer;
	}
	NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSString *realPath = [documentPath stringByAppendingPathComponent:@"travel.db"];
	
	NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"travel" ofType:@"db"];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	if (![fileManager fileExistsAtPath:realPath]) {
		NSError *error;
		if (![fileManager copyItemAtPath:sourcePath toPath:realPath error:&error]) {
		}
	}
	//把dbpointer地址修改为可修改的realPath。
	dbPointer = [[PLSqliteDatabase alloc] initWithPath:sourcePath];
	[dbPointer open];
	return dbPointer;
}

+(void) DataBaseSetup
{
	
}

+ (void) close{
	if (dbPointer) {
		[dbPointer close];
		dbPointer = NULL;
	}
}
@end
