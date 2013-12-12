//
//  CommonListItemCell.m
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListItemCell.h"
// UI
#import "Three20UI/TTImageView.h"
#import "Three20UI/TTTableMessageItem.h"
#import "Three20UI/UIViewAdditions.h"
#import "Three20Style/UIFontAdditions.h"

// Style
#import "Three20Style/TTGlobalStyle.h"
#import "Three20Style/TTDefaultStyleSheet.h"

// Core
#import "Three20Core/TTCorePreprocessorMacros.h"
#import "Three20Core/NSDateAdditions.h"

#import "CommonListItem.h"

static const NSInteger  kMessageTextLineCount       = 2;
static const CGFloat    kDefaultMessageImageWidth   = 55.0f;
static const CGFloat    kDefaultMessageImageHeight  = 55.0f;

@implementation CommonListItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {
//        _bgimageView = [[TTImageView alloc] init];
//        [self]

        self.textLabel.font = TTSTYLEVAR(font);
        self.textLabel.textColor = TTSTYLEVAR(textColor);
        self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.textLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.adjustsFontSizeToFitWidth = YES;
        self.textLabel.contentMode = UIViewContentModeLeft;

        self.detailTextLabel.font = TTSTYLEVAR(font);
        self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.detailTextLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.detailTextLabel.textAlignment = UITextAlignmentLeft;
        self.detailTextLabel.contentMode = UIViewContentModeTop;
        self.detailTextLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.detailTextLabel.numberOfLines = kMessageTextLineCount;
        self.detailTextLabel.contentMode = UIViewContentModeLeft;

        _custAccessoryView = [[TTImageView alloc] init];
        [_custAccessoryView setUrlPath:@"bundle://list1.png"];
        self.accessoryView = _custAccessoryView;
        [self.accessoryView setHidden:YES];


        [_titleLabel setBackgroundColor:[UIColor clearColor]];

        [self.contentView setWidth:self.width];
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://list1.png")]];
    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_timestampLabel);
    TT_RELEASE_SAFELY(_imageView2);
    TT_RELEASE_SAFELY(_bgimageView);
    TT_RELEASE_SAFELY(_custAccessoryView);
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    CommonListItem *item = object;
    if (item.imageURL) {
        return 90;
    }
    else{
        return 70;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    [_imageView2 unsetImage];
    _titleLabel.text = nil;
    _timestampLabel.text = nil;
    self.captionLabel.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];

    [self.accessoryView setFrame:CGRectZero];
    [self.contentView setWidth:self.width];
    CGFloat left = 0.0f;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin, kTableCellSmallMargin,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin;

    } else {
        left = kTableCellMargin;
    }

    CGFloat width = self.contentView.width - left;
    CGFloat top = kTableCellSmallMargin;

    if (_titleLabel.text.length) {
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
        top += _titleLabel.height;

    } else {
        _titleLabel.frame = CGRectZero;
    }
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    if (self.captionLabel.text.length) {
        self.captionLabel.frame = CGRectMake(left, top+kTableCellSmallMargin, width, self.captionLabel.font.ttLineHeight);
        top += self.captionLabel.height;

    } else {
        self.captionLabel.frame = CGRectZero;
    }

    if (self.detailTextLabel.text.length) {
        CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * kMessageTextLineCount;
        self.detailTextLabel.frame = CGRectMake(left, top, width, textHeight);

    } else {
        self.detailTextLabel.frame = CGRectZero;
    }


    if (_timestampLabel.text.length) {
        _timestampLabel.alpha = !self.showingDeleteConfirmation;
        [_timestampLabel sizeToFit];
        _timestampLabel.left = self.contentView.width - (_timestampLabel.width + kTableCellSmallMargin);
        _timestampLabel.top = _titleLabel.top;
        _titleLabel.width -= _timestampLabel.width + kTableCellSmallMargin*2;

    } else {
        _timestampLabel.frame = CGRectZero;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
    [super didMoveToSuperview];

    if (self.superview) {
        _imageView2.backgroundColor = self.backgroundColor;
        _titleLabel.backgroundColor = self.backgroundColor;
        _timestampLabel.backgroundColor = self.backgroundColor;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];

        CommonListItem* item = object;
        if (item.title.length) {
            self.titleLabel.text = item.title;
        }
        if (item.caption.length) {
            self.captionLabel.text = item.caption;
        }
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
        if (item.dateStr) {
            self.timestampLabel.text = item.dateStr;
        }
        if (item.imageURL) {
            self.imageView2.urlPath = item.imageURL;
        }

        if (item.URL) {

        } else if (nil != item.delegate && nil != item.selector) {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = TTSTYLEVAR(tableSelectionStyle);

        } else {
            self.accessoryType = UITableViewCellAccessoryNone;
            self.selectionStyle = UITableViewCellSelectionStyleNone;
        }

    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.highlightedTextColor = [UIColor whiteColor];
        _titleLabel.font = TTSTYLEVAR(tableFont);
        _titleLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)captionLabel {
    return self.textLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)timestampLabel {
    if (!_timestampLabel) {
        _timestampLabel = [[UILabel alloc] init];
        _timestampLabel.font = TTSTYLEVAR(tableTimestampFont);
        _timestampLabel.textColor = TTSTYLEVAR(timestampTextColor);
        _timestampLabel.highlightedTextColor = [UIColor whiteColor];
        _timestampLabel.contentMode = UIViewContentModeLeft;
        [self.contentView addSubview:_timestampLabel];
    }
    return _timestampLabel;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTImageView*)imageView2 {
    if (!_imageView2) {
        _imageView2 = [[TTImageView alloc] init];
        //    _imageView2.defaultImage = TTSTYLEVAR(personImageSmall);
        //    _imageView2.style = TTSTYLE(threadActorIcon);
        [self.contentView addSubview:_imageView2];
    }
    return _imageView2;
}

#pragma mark -
#pragma mark MStyleLabelDelegate
-(void)textViewUrlTapped:(NSString *)urlValue{
    debug_NSLog(@"textViewUrlTapped:%@",urlValue);
    if (!urlValue) {
        debug_NSLog(@"show detail");
    }
    if ([[urlValue substringToIndex:1] isEqualToString:@"#"]) {
        //微博主题
        //        substringToIndex:[self.highlightedNode description].length-1]
        NSString *url = [NSString stringWithFormat:@"tt://sendWeiBo/%@/0/0",[[[urlValue substringToIndex:urlValue.length-1] substringFromIndex:1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSLog(@"url:%@",url);
        TTOpenURL(url);
    }
    else if([[urlValue substringToIndex:1] isEqualToString:@"@"]){
        NSString *url = [NSString stringWithFormat:@"tt://personDetailByName/%@",[[urlValue substringFromIndex:1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        TTOpenURL(url);
    }
    else{
        TTOpenURL(urlValue);
    }
}

@end
