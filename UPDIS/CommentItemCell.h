//
//  CommentItemCell.h
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface CommentItemCell : TTTableLinkedItemCell{
    UILabel*      _titleLabel;
    UILabel*      _timestampLabel;
    TTImageView*  _imageView2;
    TTStyledTextLabel* _stylelabel;
    UIImageView*         _tempBgView;
}

@property (nonatomic, readonly) TTImageView* custAccessoryView;
@property (nonatomic, readonly, retain) UILabel             *titleLabel;
@property (nonatomic, readonly)         UILabel             *captionLabel;
@property (nonatomic, readonly, retain) TTStyledTextLabel   *stylelabel;
@property (nonatomic, readonly, retain) UILabel             *timestampLabel;
@property (nonatomic, readonly, retain) TTImageView         *imageView2;
@property (nonatomic, retain) UIImageView                        *tempBgView;

@end
