//
//  CommonListView.m
//  UPDIS
//  通用列表
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "CommonListView.h"

@implementation CommonListView

@synthesize pageIndex = _pageIndex;
@synthesize reuseIdentifier = _reuseIdentifier;

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithFrame:CGRectZero])) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithReuseIdentifier:nil];
}

- (void)setPageIndex:(NSInteger)pageIndex {
    _pageIndex = pageIndex;


    UIColor* bgColor;
    UIColor* textColor;
    // Change the background and text color depending on the index.
    switch (pageIndex % 4) {
        case 0:
            bgColor = [UIColor redColor];
            textColor = [UIColor whiteColor];
            break;
        case 1:
            bgColor = [UIColor blueColor];
            textColor = [UIColor whiteColor];
            break;
        case 2:
            bgColor = [UIColor yellowColor];
            textColor = [UIColor blackColor];
            break;
        case 3:
            bgColor = [UIColor greenColor];
            textColor = [UIColor blackColor];
            break;
    }

    self.backgroundColor = bgColor;
    
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
