//
//  UserItemCell.m
//  UPDIS
//
//  Created by Melvin on 13-8-12.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "UserItemCell.h"

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

#import "UserItem.h"


static const NSInteger  kMessageTextLineCount       = 2;
static const NSInteger  kPaddingX                   = 8.0f;
static const CGFloat    kDefaultMessageImageWidth   = 70.0f;
static const CGFloat    kDefaultMessageImageHeight  = 70.0f;

@implementation UserItemCell

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)identifier {
	self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    if (self) {

        if (!self.contentPanel) {
            UIView *temp = [[UIView alloc] init];
            self.contentPanel = temp;
            TT_RELEASE_SAFELY(temp);
        }
        [self.contentPanel setBackgroundColor:[UIColor whiteColor]];
        CGFloat paddingY = 4;
        [self.contentPanel setFrame:CGRectMake(kPaddingX, paddingY, self.contentView.width-kPaddingX*2, 90-paddingY*2)];

        self.contentPanel.layer.cornerRadius = 2.5; 
        self.contentPanel.layer.masksToBounds = YES;
        
        [self.contentView insertSubview:self.contentPanel atIndex:0];


        self.textLabel.font = TTSTYLEVAR(font);
        self.textLabel.textColor = TTSTYLEVAR(tableSubTextColor);
        self.textLabel.highlightedTextColor = TTSTYLEVAR(highlightedTextColor);
        self.textLabel.backgroundColor = TTSTYLEVAR(backgroundTextColor);
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.textLabel.contentMode = UIViewContentModeTop;
        self.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
        self.textLabel.numberOfLines = kMessageTextLineCount;
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
        [_custAccessoryView setUrlPath:@"bundle://category_arrow.png"];
        [_custAccessoryView setTop:(self.contentPanel.height-_custAccessoryView.height)/2];
        [_custAccessoryView setLeft:self.contentPanel.width-_custAccessoryView.width-10];
        [self.contentPanel addSubview:_custAccessoryView];
//        self.accessoryView = _custAccessoryView;

    }

    return self;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    TT_RELEASE_SAFELY(_titleLabel);
    TT_RELEASE_SAFELY(_timestampLabel);
    TT_RELEASE_SAFELY(_imageView2);
    TT_RELEASE_SAFELY(_custAccessoryView);
    TT_RELEASE_SAFELY(_contentPanel);
    
    [super dealloc];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTTableViewCell class public


///////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object {
    // XXXjoe Compute height based on font sizes
    return 90;
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
    //    _stylelabel = nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
    [super layoutSubviews];

    CGFloat paddingY = 10;
    CGFloat left = 0.0f;
    if (_imageView2) {
        _imageView2.frame = CGRectMake(kTableCellSmallMargin+kPaddingX, paddingY,
                                       kDefaultMessageImageWidth, kDefaultMessageImageHeight);
        left += kTableCellSmallMargin + kDefaultMessageImageHeight + kTableCellSmallMargin+kPaddingX;

    } else {
        left = kTableCellMargin;
    }

    CGFloat width = self.contentView.width - left;
    CGFloat top = paddingY;

    if (_titleLabel.text.length) {
        _titleLabel.frame = CGRectMake(left, top, width, _titleLabel.font.ttLineHeight);
        top += _titleLabel.height;

    } else {
        _titleLabel.frame = CGRectZero;
    }

    if (self.captionLabel.text.length) {
        top+=kTableCellSmallMargin;
        self.captionLabel.frame = CGRectMake(left, top, width, self.captionLabel.font.ttLineHeight);
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

        UserItem* item = object;
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

@end


@interface UIImage(UIImageScale)
-(UIImage*)getSubImage:(CGRect)rect;
-(UIImage*)scaleToSize:(CGSize)size;
@end

@implementation UIImage(UIImageScale)

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));

    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();

    return smallImage;
}

//等比例缩放
-(UIImage*)scaleToSize:(CGSize)size
{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);

    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;

    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }

    width = width*radio;
    height = height*radio;

    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;

    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);

    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];

    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // 使当前的context出堆栈
    UIGraphicsEndImageContext();

    // 返回新的改变大小后的图片
    return scaledImage;
}
@end
