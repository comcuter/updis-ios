//
//  CommonListDataSourceModel.h
//  UPDIS
//
//  Created by Melvin on 13-7-1.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20Network/Three20Network.h>
#import "NetworkAssistant.h"

typedef enum
{
    ListTypeNone,       //默认
	ListTypeNotice,     //通知
	ListTypeBidding,    //招标信息
    ListTypeTalk,       //畅所欲言
    ListTypeAmateur,    //业余生活
    ListTypeProject,    //在谈项目
    ListTypeDicDept,    //部门数据字典
    ListTypeDicSubject, //专业数据字典
    ListTypeQueryPersonList,    //人员查询列表
}ListType;

@interface CommonListDataSourceModel : TTURLRequestModel<ReLoginAssisantDelegate>

@property (nonatomic ,assign) BOOL          finished;
@property (nonatomic ,assign) NSInteger     totalPage;
@property (nonatomic ,assign) NSInteger     currentPage;
@property (nonatomic ,assign) ListType      listType;
@property (nonatomic ,retain) NSDictionary  *pageData;
@property (nonatomic ,retain) NSDictionary  *parm;
@property (nonatomic ,retain) NSMutableArray*listData;

- (id)initWithListType:(ListType)listType;
@end
