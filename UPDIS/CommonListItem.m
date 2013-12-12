//
//  CommonListItem.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListItem.h"
// Core
#import "Three20Core/TTCorePreprocessorMacros.h"

@implementation CommonListItem
@synthesize title     = _title;
@synthesize caption   = _caption;
@synthesize dateStr   = _dateStr;
@synthesize imageURL  = _imageURL;
@synthesize contentId = _contentId;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_title);
    TT_RELEASE_SAFELY(_caption);
    TT_RELEASE_SAFELY(_dateStr);
    TT_RELEASE_SAFELY(_imageURL);
    TT_RELEASE_SAFELY(_contentId);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp URL:(NSString*)URL {
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.URL = URL;
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
          timestamp:(NSDate*)timestamp imageURL:(NSString*)imageURL URL:(NSString*)URL {
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.imageURL = imageURL;
    item.URL = URL;
    return item;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title
            caption:(NSString*)caption
               text:(NSString*)text
            datestr:(NSString*)datestr
           imageURL:(NSString*)imageURL
                URL:(NSString*)URL{
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.dateStr = datestr;
    item.imageURL = imageURL;
    item.URL = URL;
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
           delegate:(id)delegate
           selector:(SEL)selector{
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.dateStr = datestr;
    item.imageURL = imageURL;
    item.URL = URL;
    item.delegate = delegate;
    item.selector = selector;
    return item;
}




///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title caption:(NSString*)caption text:(NSString*)text
            datestr:(NSString*)datestr imageURL:(NSString*)imageURL URL:(NSString*)URL
           delegate:(id)delegate
           selector:(SEL)selector
          contentId:(NSString *)contentId{
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.dateStr = datestr;
    item.imageURL = imageURL;
    item.URL = URL;
    item.delegate = delegate;
    item.selector = selector;
    item.contentId = contentId;
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
+ (id)itemWithTitle:(NSString*)title
            caption:(NSString*)caption
               text:(NSString*)text
            datestr:(NSString*)datestr
           imageURL:(NSString*)imageURL
                URL:(NSString*)URL
          contentId:(NSString *)contentId{
    CommonListItem* item = [[[self alloc] init] autorelease];
    item.title = title;
    item.caption = caption;
    item.text = text;
    item.dateStr = datestr;
    item.imageURL = imageURL;
    item.URL = URL;
    item.contentId = contentId;
    return item;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark NSCoding


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithCoder:(NSCoder*)decoder {
	self = [super initWithCoder:decoder];
    if (self) {
        self.title = [decoder decodeObjectForKey:@"title"];
        self.caption = [decoder decodeObjectForKey:@"caption"];
        self.contentId = [decoder decodeObjectForKey:@"contentId"];
        self.dateStr = [decoder decodeObjectForKey:@"dateStr"];
        self.imageURL = [decoder decodeObjectForKey:@"imageURL"];
    }
    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)encodeWithCoder:(NSCoder*)encoder {
    [super encodeWithCoder:encoder];
    if (self.title) {
        [encoder encodeObject:self.title forKey:@"title"];
    }
    if (self.caption) {
        [encoder encodeObject:self.caption forKey:@"caption"];
    }
    if (self.dateStr) {
        [encoder encodeObject:self.dateStr forKey:@"dateStr"];
    }
    if (self.imageURL) {
        [encoder encodeObject:self.imageURL forKey:@"imageURL"];
    }
}
@end
