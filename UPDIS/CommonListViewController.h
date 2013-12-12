//
//  CommonListViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListDataSource.h"

@protocol CommonListViewControllerDelegate <NSObject>
@optional
-(void)itemClick:(TTTableTextItem *)item listType:(ListType)listType;
@end

@interface CommonListViewController : TTTableViewController<CommonListDataSourceDelegate>

@property (nonatomic ,assign) ListType listType;
@property (nonatomic ,assign) id<CommonListViewControllerDelegate> delegate;
@property (nonatomic ,retain) CommonListDataSource *commonListDataSource;
@property (nonatomic ,retain) NSDictionary  *parm;
- (id)initWithListType:(ListType)listType;
@end
