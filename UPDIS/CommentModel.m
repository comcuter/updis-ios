//
//  CommentModel.m
//  UPDIS
//
//  Created by Melvin on 13-7-2.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel


-(void)dealloc{
    TT_RELEASE_SAFELY(_commentId);
    TT_RELEASE_SAFELY(_author);
    TT_RELEASE_SAFELY(_datetime);
    TT_RELEASE_SAFELY(_iconUrl);
    TT_RELEASE_SAFELY(_content);
    [super dealloc];
}
@end
