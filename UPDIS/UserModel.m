//
//  UserModel.m
//  UPDIS
//
//  Created by Melvin on 13-7-11.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
-(void)dealloc{
    TT_RELEASE_SAFELY(_userId);
    TT_RELEASE_SAFELY(_name);
    TT_RELEASE_SAFELY(_dept);
    TT_RELEASE_SAFELY(_birthday);
    TT_RELEASE_SAFELY(_gender);
    TT_RELEASE_SAFELY(_specialty);
    TT_RELEASE_SAFELY(_educational);
    TT_RELEASE_SAFELY(_degree);
    TT_RELEASE_SAFELY(_graduationDate);
    TT_RELEASE_SAFELY(_entryDate);
    TT_RELEASE_SAFELY(_rank);
    TT_RELEASE_SAFELY(_titles);
    TT_RELEASE_SAFELY(_iconUrl);
    TT_RELEASE_SAFELY(_resume);
    TT_RELEASE_SAFELY(_mobilePhone);
    TT_RELEASE_SAFELY(_officePhone);
    TT_RELEASE_SAFELY(_homeNum);
    TT_RELEASE_SAFELY(_mail);
    [super dealloc];
}
@end
