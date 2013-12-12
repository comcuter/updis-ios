//
//  MessageDataModel.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageDataModel : NSObject

@property (nonatomic ,retain) NSString  *contentId;
@property (nonatomic ,retain) NSString  *subtitle;
@property (nonatomic ,retain) NSString  *author;
@property (nonatomic ,retain) NSString  *title;
@property (nonatomic ,retain) NSString  *iconUrl;
@property (nonatomic ,retain) NSString  *datetime;
@property (nonatomic ,retain) NSString  *dept;
@property (nonatomic ,retain) NSString  *readCount;
@property (nonatomic ,retain) NSArray   *comments;
@property (nonatomic ,retain) NSString  *content;
@property (nonatomic ,retain) NSString  *category;
@property (nonatomic ,retain) NSString  *messageListMeta;
@property (nonatomic ,retain) NSString  *messageDetailMeta;
@end
