//
//  CommonDetailDataSource.h
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20UI/Three20UI.h>
#import "CommonDetailDataSourceModel.h"


@protocol CommonDetailDataSourceDelegate <NSObject>
@required
-(void)contentLoadOver:(MessageDataModel *)dataModel;
@end

@interface CommonDetailDataSource : TTListDataSource

@property (nonatomic ,assign) id<CommonDetailDataSourceDelegate> delegate;
@property (nonatomic ,retain) CommonDetailDataSourceModel *commonDetailDataSourceModel;
@property (nonatomic ,retain) NSString  *contentId;
@property (nonatomic ,assign) BOOL          loadList;


- (id)initWithConentId:(NSString *)contentId loadList:(BOOL)loadList;
@end
