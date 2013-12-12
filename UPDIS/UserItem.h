//
//  UserItem.h
//  UPDIS
//
//  Created by Melvin on 13-8-12.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface UserItem : TTTableTextItem{

    NSString    *_title;
    NSString    *_caption;
    NSString    *_dateStr;
    NSString    *_imageURL;
    NSString    *_userId;
}

@property (nonatomic, copy)   NSString* title;
@property (nonatomic, copy)   NSString* caption;
@property (nonatomic, copy)   NSString* dateStr;
@property (nonatomic, copy)   NSString* imageURL;
@property (nonatomic, copy)   NSString* userId;


+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr
           imageURL:(NSString*)imageURL
                URL:(NSString*)URL
             userId:(NSString *)userId
           delegate:(id)delegate
           selector:(SEL)selector;


@end
