//
//  ActiveTaskModel.m
//  UPDIS
//
//  Created by HaiLee on 14-3-16.
//  Copyright (c) 2014年 tianv. All rights reserved.
//

#import "ActiveTaskModel.h"

@implementation ActiveTaskModel

+ (ActiveTaskModel *)parseActiveTaskFromRawDic:(NSDictionary *)rawDic
{
    ActiveTaskModel *activeTask = [[ActiveTaskModel alloc] init];
    activeTask.stateId = [rawDic intValueForKey:@"stateId"];
    activeTask.state = [rawDic stringValueForKey:@"state"];
    activeTask.partner = [rawDic stringValueForKey:@"partner"];
    activeTask.partnerType = [rawDic stringValueForKey:@"partnerType"];
    activeTask.customerContact = [rawDic stringValueForKey:@"customerContact"];
    activeTask.guiMo = [rawDic stringValueForKey:@"guiMo"];
    
    activeTask.yaoQiuXingChengWenJian = [rawDic stringValueForKey:@"yaoQiuXingChengWenJian"];
    activeTask.shiFouTouBiao = [rawDic boolValueForKey:@"shiFouTouBiao"];
    activeTask.touBiaoLeiBie = [rawDic stringValueForKey:@"touBiaoLeiBie"];
    
    activeTask.expressRequirement = [rawDic stringValueForKey:@"expressRequirement"];
    activeTask.yinHanYaoQiu = [rawDic stringValueForKey:@"yinHanYaoQiu"];
    activeTask.diFangFaGui = [rawDic stringValueForKey:@"diFangFaGui"];
    activeTask.fuJiaYaoQiu = [rawDic stringValueForKey:@"fuJiaYaoQiu"];
    activeTask.heTongYiZhi = [rawDic stringValueForKey:@"heTongYiZhi"];
    
    activeTask.ziYuanManZu = [rawDic stringValueForKey:@"ziYuanManZu"];
    activeTask.sheBeiManZu = [rawDic stringValueForKey:@"sheBeiManZu"];
    activeTask.gongQiManZu = [rawDic stringValueForKey:@"gongQiManZu"];
    activeTask.sheJiFeiManZu = [rawDic stringValueForKey:@"sheJiFeiManZu"];
    
    activeTask.shiFouWaiBao = [rawDic boolValueForKey:@"shiFouWaiBao"];
    activeTask.shiZhengPeiTao = [rawDic boolValueForKey:@"shiZhengPeiTao"];
    activeTask.duoFangHeTong = [rawDic boolValueForKey:@"duoFangHeTong"];
    
    activeTask.directorReviewer = [rawDic stringValueForKey:@"directorReviewer"];
    activeTask.directorReviewerApplyTime = [rawDic stringValueForKey:@"directorReviewerApplyTime"];
    
    activeTask.showDirectorReviewButton = [rawDic boolValueForKey:@"showDirectorReviewButton"];
    
    activeTask.pingShenFangShi = [rawDic stringValueForKey:@"pingShenFangShi"];
    activeTask.yinFaCuoShi = [rawDic stringValueForKey:@"yinFaCuoShi"];
    activeTask.renWuYaoQiu = [rawDic stringValueForKey:@"renWuYaoQiu"];
    activeTask.chengJieBuMen = [rawDic stringValueForKey:@"chengJieBuMen"];
    activeTask.jingYingShiReviewer = [rawDic stringValueForKey:@"jingYingShiReviewer"];
    activeTask.jingYingShiReviewApplyTime = [rawDic stringValueForKey:@"jingYingShiReviewApplyTime"];
    
    activeTask.showZongShiReviewButton = [rawDic boolValueForKey:@"showZongShiReviewButton"];
    activeTask.projectCategory = [rawDic stringValueForKey:@"projectCategory"];
    activeTask.guanLiJiBie = [rawDic stringValueForKey:@"guanLiJiBie"];
    activeTask.projectLead = [rawDic stringValueForKey:@"projectLead"];
    activeTask.zhuGuanZongShi = [rawDic stringValueForKey:@"zhuGuanZongShi"];
    activeTask.zongShiShiReviewer = [rawDic stringValueForKey:@"zongShiShiReviewer"];
    activeTask.zongShiShiReviewApplyTime = [rawDic stringValueForKey:@"zongShiShiReviewApplyTime"];
    
    activeTask.showProjectLeadReviewAndRejectButton = [rawDic boolValueForKey:@"showProjectLeadReviewAndRejectButton"];
    activeTask.projectLeadReviewer = [rawDic stringValueForKey:@"projectLeadReviewer"];
    activeTask.projectLeadReviewApplyTime = [rawDic stringValueForKey:@"projectLeadReviewApplyTime"];
    
    return activeTask;
}

@end

@implementation CommonCellModel

+ (NSArray *)parseDataFromRawArray:(NSArray *)rawArray
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (NSDictionary *rawModel in rawArray) {
        CommonCellModel *model = [[CommonCellModel alloc] init];
        model.modelId = [rawModel intValueForKey:@"id"];
        model.name = [rawModel stringValueForKey:@"name"];
        [resultArray addObject:model];
    }
    
    return resultArray;
}

@end
