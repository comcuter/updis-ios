//
//  CommentModel.h
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic ,retain) NSString  *commentId;
@property (nonatomic ,retain) NSString  *author;
@property (nonatomic ,retain) NSString  *datetime;
@property (nonatomic ,retain) NSString  *iconUrl;
@property (nonatomic ,retain) NSString  *content;
@property (nonatomic ,assign) BOOL      isAnonymous;
@end
