//
//  CommonDetailItemCell.h
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>

@interface CommonDetailItemCell : TTTableLinkedItemCell

@property (nonatomic ,readonly ,retain) UIWebView *webView;
@property (nonatomic ,readonly ,retain) UIView    *toolBarView;

@end
