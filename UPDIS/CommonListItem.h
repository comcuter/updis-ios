//
//  CommonListItem.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//


#import "Three20UI/TTTableTextItem.h"
@class TTStyledText;

@interface CommonListItem : TTTableTextItem{
    NSString    *_title;
    NSString    *_caption;
    NSString    *_dateStr;
    NSString    *_imageURL;
    NSString    *_contentId;
}

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* caption;
@property (nonatomic, copy)   NSString* dateStr;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSString* contentId;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL;


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL;



///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
           delegate:(id)delegate
           selector:(SEL)selector;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
           delegate:(id)delegate
           selector:(SEL)selector contentId:(NSString *)contentId;

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title
            caption:(NSString*)caption
               text:(NSString*)text
            datestr:(NSString*)datestr
           imageURL:(NSString*)imageURL
                URL:(NSString*)URL
          contentId:(NSString *)contentId;
@end
