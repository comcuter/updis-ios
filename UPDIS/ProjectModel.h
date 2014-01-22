//
//  ProjectModel.h
//  UPDIS
//
//  Created by admin on 1/19/14.
//  Copyright (c) 2014 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProjectModel : NSObject

@property (nonatomic, assign) int projectId;
@property (nonatomic, retain) NSString *projectNumber;
@property (nonatomic, retain) NSString *projectName;
@property (nonatomic, retain) NSString *partyAName;
@property (nonatomic, retain) NSString *designDepartment;
@property (nonatomic, retain) NSArray *projectLeaders;
@property (nonatomic, retain) NSString *projectScale;

+ (NSArray *)parseProjectsFromRawArray:(NSArray *)rawArray;

@end
