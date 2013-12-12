//
//  CommonDetailItemCell.m
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonDetailItemCell.h"
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



@implementation CommonDetailItemCell

-(void)dealloc{
    TT_RELEASE_SAFELY(_webView);
    TT_RELEASE_SAFELY(_toolBarView);
    [super dealloc];
}

@end
