//
//  TabPageView.m
//  UPDIS
//  顶部导航
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "TabPageView.h"
#define kButtonBaseTag 10000
#define kLeftOffset 4

@implementation TabPageView

@synthesize titles = _titles;
@synthesize selectedImage = _selectedImage;

@synthesize itemSelectedDelegate;
@synthesize dataSource;
@synthesize itemCount = _itemCount;



-(void) reloadData
{
    self.itemCount = [dataSource numberOfItemsForTab:self];
    self.backgroundColor = [dataSource backgroundColorForTab:self];
    self.selectedImage = [dataSource selectedItemImageForTab:self];

    self.bounces = YES;
    self.scrollEnabled = YES;
    self.alwaysBounceHorizontal = YES;
    self.alwaysBounceVertical = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    UIFont *buttonFont = [UIFont boldSystemFontOfSize:14];
    int buttonPadding = 1;

    int tag = kButtonBaseTag;
    int xPos = kLeftOffset;
    float buttonWidth = 155/2;
    
    for(int i = 0 ; i < self.itemCount; i ++)
    {
        NSString *title = [dataSource tabPageView:self titleForItemAtIndex:i];
        UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [customButton setTitle:title forState:UIControlStateNormal];
        customButton.titleLabel.font = buttonFont;
        [customButton setBackgroundImage:self.selectedImage forState:UIControlStateSelected];

        customButton.tag = tag++;
        [customButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];

//        int buttonWidth = [title sizeWithFont:customButton.titleLabel.font
//                            constrainedToSize:CGSizeMake(150, 28)
//                                lineBreakMode:UILineBreakModeClip].width;

        
        customButton.frame = CGRectMake(xPos, 0,buttonWidth+buttonPadding, 30);
        xPos += buttonWidth;
        xPos += buttonPadding;

//        UIEdgeInsets insets;
//        insets.left=insets.right=10;
//        customButton.contentEdgeInsets=insets;
        [self addSubview:customButton];
    }
    self.contentSize = CGSizeMake(xPos, 30);
    [self layoutSubviews];
}


-(void) setSelectedIndex:(int) index animated:(BOOL) animated
{
    for(int i = 0; i < self.itemCount; i++)
    {
        UIButton *thisButton = (UIButton*) [self viewWithTag:i + kButtonBaseTag];
        if(i + kButtonBaseTag == index + kButtonBaseTag)
            thisButton.selected = YES;
        else
            thisButton.selected = NO;
    }
    
//    UIButton *thisButton = (UIButton*) [self viewWithTag:index + kButtonBaseTag];
//    thisButton.selected = YES;
//    [self setContentOffset:CGPointMake(thisButton.frame.origin.x - kLeftOffset, 0) animated:animated];
//    [self.itemSelectedDelegate horizTab:self itemSelectedAtIndex:index];
    [self.itemSelectedDelegate tabPageView:self itemSelectedAtIndex:index];
}

-(void) buttonTapped:(id) sender
{
    UIButton *button = (UIButton*) sender;

    for(int i = 0; i < self.itemCount; i++)
    {
        UIButton *thisButton = (UIButton*) [self viewWithTag:i + kButtonBaseTag];
        if(i + kButtonBaseTag == button.tag)
            thisButton.selected = YES;
        else
            thisButton.selected = NO;
    }
    [self.itemSelectedDelegate tabPageView:self itemSelectedAtIndex:button.tag - kButtonBaseTag];
}


- (void)dealloc
{
    [_selectedImage release];
    _selectedImage = nil;
    [_titles release];
    _titles = nil;

    [super dealloc];
}

@end
