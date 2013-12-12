//
//  TabPageView.h
//  UPDIS
//  顶部导航
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TabPageView;

@protocol TabPageViewDataSource <NSObject>
@required
- (UIImage*) selectedItemImageForTab:(TabPageView*) tabView;
- (UIColor*) backgroundColorForTab:(TabPageView*) tabView;
- (int) numberOfItemsForTab:(TabPageView*) tabView;

- (NSString*) tabPageView:(TabPageView*) tabPageView titleForItemAtIndex:(NSUInteger) index;
@end

@protocol TabPageViewDelegate <NSObject>
@required
- (void)tabPageView:(TabPageView*) tabPageView itemSelectedAtIndex:(NSUInteger) index;
@end


@interface TabPageView : UIScrollView{
    int _itemCount;
    UIImage *_selectedImage;
    NSMutableArray *_titles;
    id <TabPageViewDataSource> dataSource;
    id <TabPageViewDelegate> itemSelectedDelegate;
}

@property (nonatomic, retain) NSMutableArray *titles;
@property (nonatomic, assign) id <TabPageViewDelegate> itemSelectedDelegate;
@property (nonatomic, retain) id <TabPageViewDataSource> dataSource;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) int itemCount;

-(void) reloadData;
-(void) setSelectedIndex:(int) index animated:(BOOL) animated;
@end
