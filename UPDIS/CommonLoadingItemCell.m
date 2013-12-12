//
//  CommonLoadingItemCell.m
//  UPDIS
//
//  Created by Melvin on 13-8-13.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonLoadingItemCell.h"
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

#import "CommonLoadingItem.h"

@implementation CommonLoadingItemCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {
        self.detailTextLabel.font = TTSTYLEVAR(font);
        self.detailTextLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        self.detailTextLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.detailTextLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.detailTextLabel.contentMode = UIViewContentModeCenter;
        self.detailTextLabel.textAlignment = UITextAlignmentCenter;

        
        [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://list1.png")]];
    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    return 46;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UIView


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)prepareForReuse {
    [super prepareForReuse];
    self.captionLabel.text = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat left = kTableCellMargin;
    CGFloat width = self.contentView.width - left*2;
    CGFloat top = kTableCellSmallMargin;

    if (self.captionLabel.text.length) {
        self.captionLabel.frame = CGRectMake(left, top+kTableCellSmallMargin, width, self.captionLabel.font.ttLineHeight);
        top += self.captionLabel.height;

    } else {
        self.captionLabel.frame = CGRectZero;
    }

    if (self.detailTextLabel.text.length) {
        CGFloat textHeight = self.detailTextLabel.font.ttLineHeight * 1;
        top = (self.contentView.height-textHeight)/2;
        self.detailTextLabel.frame = CGRectMake(left, top, width, textHeight);
    } else {
        self.detailTextLabel.frame = CGRectZero;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didMoveToSuperview {
    [super didMoveToSuperview];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setObject:(id)object {
    if (_item != object) {
        [super setObject:object];

        CommonLoadingItem* item = object;
        if (item.text.length) {
            self.detailTextLabel.text = item.text;
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UILabel*)captionLabel {
    return self.textLabel;
}

@end
