//
//  MessageDataModel.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "MessageDataModel.h"

@implementation MessageDataModel


-(void)dealloc{
    TT_RELEASE_SAFELY(_contentId);
    TT_RELEASE_SAFELY(_subtitle);
    TT_RELEASE_SAFELY(_author);
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_iconUrl);
    TT_RELEASE_SAFELY(_datetime);
    TT_RELEASE_SAFELY(_dept);
    TT_RELEASE_SAFELY(_readCount);
    TT_RELEASE_SAFELY(_comments);
    TT_RELEASE_SAFELY(_content);
    TT_RELEASE_SAFELY(_category);
    TT_RELEASE_SAFELY(_messageListMeta);
    TT_RELEASE_SAFELY(_messageDetailMeta);
    [super dealloc];
}

@end
