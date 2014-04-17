//
//  ActiveTaskModel.h
//  UPDIS
//
//  Created by HaiLee on 14-3-16.
//  Copyright (c) 2014年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveTaskModel : NSObject

@property (nonatomic, assign) int stateId;
@property (nonatomic, retain) NSString *state;
@property (nonatomic, retain) NSString *partner;
@property (nonatomic, retain) NSString *partnerType;
@property (nonatomic, retain) NSString *customerContact;
@property (nonatomic, retain) NSString *guiMo;

@property (nonatomic, retain) NSString *yaoQiuXingChengWenJian;
@property (nonatomic, assign) BOOL shiFouTouBiao;
@property (nonatomic, retain) NSString *touBiaoLeiBie;

@property (nonatomic, retain) NSString *expressRequirement;
@property (nonatomic, retain) NSString *yinHanYaoQiu;
@property (nonatomic, retain) NSString *diFangFaGui;
@property (nonatomic, retain) NSString *fuJiaYaoQiu;
@property (nonatomic, retain) NSString *heTongYiZhi;

@property (nonatomic, retain) NSString *ziYuanManZu;
@property (nonatomic, retain) NSString *sheBeiManZu;
@property (nonatomic, retain) NSString *gongQiManZu;
@property (nonatomic, retain) NSString *sheJiFeiManZu;

@property (nonatomic, assign) BOOL shiFouWaiBao;
@property (nonatomic, assign) BOOL shiZhengPeiTao;
@property (nonatomic, assign) BOOL duoFangHeTong;

@property (nonatomic, retain) NSString *directorReviewer;
@property (nonatomic, retain) NSString *directorReviewerApplyTime;

@property (nonatomic, assign) BOOL showDirectorReviewButton;

// 经营室相关字段.
@property (nonatomic, retain) NSString *pingShenFangShi;
@property (nonatomic, retain) NSString *yinFaCuoShi;
@property (nonatomic, retain) NSString *renWuYaoQiu;
@property (nonatomic, retain) NSString *chengJieBuMen;
@property (nonatomic, retain) NSString *jingYingShiReviewer;
@property (nonatomic, retain) NSString *jingYingShiReviewApplyTime;

// 总师室相关字段
@property (nonatomic, retain) NSString *projectCategory;
@property (nonatomic, retain) NSString *guanLiJiBie;
@property (nonatomic, retain) NSString *projectLead;
@property (nonatomic, retain) NSString *zhuGuanZongShi;
@property (nonatomic, retain) NSString *zongShiShiReviewer;
@property (nonatomic, retain) NSString *zongShiShiReviewApplyTime;

// 负责人签字相关字段
@property (nonatomic, assign) BOOL showProjectLeadReviewAndRejectButton;
@property (nonatomic, retain) NSString *projectLeadReviewer;
@property (nonatomic, retain) NSString *projectLeadReviewApplyTime;

+ (ActiveTaskModel *)parseActiveTaskFromRawDic:(NSDictionary *)rawDic;

@end
