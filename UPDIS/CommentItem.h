//
//  CommentItem.h
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
@class TTStyledText;

@interface CommentItem :  TTTableTextItem {
    NSString    *_title;
    NSString    *_caption;
    NSDate      *_timestamp;
    NSString    *_dateStr;
    NSString    *_imageURL;
    NSString    *_userId;
    TTStyledText* _styleText;
}

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* caption;
@property (nonatomic, retain) NSDate*   timestamp;
@property (nonatomic, copy)   NSString* dateStr;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSString* userId;
@property (nonatomic, retain) TTStyledText* styleText;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL;
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL;
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
          styleText:(TTStyledText *)styleText;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
           delegate:(id)delegate
           selector:(SEL)selector;

+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr
           imageURL:(NSString*)imageURL
                URL:(NSString*)URL
             userId:(NSString *)userId
           delegate:(id)delegate
           selector:(SEL)selector;

@end
