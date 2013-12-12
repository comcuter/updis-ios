//
//  CommonDetailDataSourceModel.h
//  UPDIS
//
//  Created by Melvin on 13-7-3.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20Network/Three20Network.h>
#import "MessageDataModel.h"


@interface CommonDetailDataSourceModel : TTURLRequestModel<ReLoginAssisantDelegate>

@property (nonatomic ,retain) MessageDataModel  *pageData;
@property (nonatomic ,retain) NSMutableArray*listData;
@property (nonatomic ,assign) BOOL          finished;
@property (nonatomic ,assign) BOOL          loadList;
@property (nonatomic ,retain) NSString      *contentId;
@property (nonatomic ,assign) NSInteger     totalPage;
@property (nonatomic ,assign) NSInteger     currentPage;


- (id)initWithConentId:(NSString *)contentId loadList:(BOOL)loadList;
@end
