//
//  CommonListItemCell.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "Three20UI/TTTableLinkedItemCell.h"

@class TTImageView;

@interface CommonListItemCell : TTTableLinkedItemCell{
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTImageView*  _imageView2;
}

@property (nonatomic, readonly) TTImageView* custAccessoryView;
@property (nonatomic, readonly, retain) UILabel             *titleLabel;
@property (nonatomic, readonly)         UILabel             *captionLabel;
@property (nonatomic, readonly, retain) UILabel             *timestampLabel;
@property (nonatomic, readonly, retain) TTImageView         *imageView2;
@property (nonatomic, readonly, retain) TTImageView         *bgimageView;

@end
