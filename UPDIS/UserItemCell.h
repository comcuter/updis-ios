//
//  UserItemCell.h
//  UPDIS
//
//  Created by Melvin on 13-8-12.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface UserItemCell : TTTableLinkedItemCell{
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTImageView*  _imageView2;
    UIView*       _contentPanel;
}


@property (nonatomic, readonly) TTImageView* custAccessoryView;
@property (nonatomic, readonly, retain) UILabel             *titleLabel;
@property (nonatomic, readonly)         UILabel             *captionLabel;
@property (nonatomic, readonly, retain) UILabel             *timestampLabel;
@property (nonatomic, readonly, retain) TTImageView         *imageView2;
@property (nonatomic, retain) UIView              *contentPanel;



@end
