//
//  ProjectModel.m
//  UPDIS
//
//  Created by admin on 1/19/14.
//  Copyright (c) 2014 tianv. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel

+ (NSArray *)parseProjectsFromRawArray:(NSArray *)rawArray
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSDictionary *projectDic in rawArray) {
        ProjectModel *p = [[ProjectModel alloc] init];
        p.projectId = [[projectDic valueForKey:@"projectId"] intValue];
        p.projectName = [projectDic valueForKey:@"projectName"];
        p.projectNumber = [projectDic valueForKey:@"projectNumber"];
        p.partyAName = [projectDic valueForKey:@"partyAName"];
        p.designDepartment = [projectDic valueForKey:@"designDepartment"];
        p.projectLeaders = [projectDic valueForKey:@"projectLeaders"];
        p.projectScale = [projectDic valueForKey:@"projectScale"];
        
        [result addObject:p];
    }
    
    return result;
}

@end
