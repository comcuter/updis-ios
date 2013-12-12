//
//  CommonListDataSource.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "CommonListDataSourceModel.h"


@protocol CommonListDataSourceDelegate <NSObject>
@optional
- (void)itemClick:(TTTableTextItem *)item;
- (void)dataLoadError;
- (void)dataLoadOver;
@end

@interface CommonListDataSource : TTListDataSource

@property (nonatomic ,retain) CommonListDataSourceModel *commonListDataSourceModel;
@property (nonatomic ,assign) id<CommonListDataSourceDelegate> delegate;
@property (nonatomic ,assign) ListType listType;


- (void)setPostParm:(NSDictionary *)parm;
- (id)initWithListType:(ListType)listType;
@end
