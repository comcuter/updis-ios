//
//  ZongShiReviewViewController.h
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActiveTaskModel;
@interface ZongShiReviewViewController : UIViewController

@property (nonatomic, assign) int activeTaskId;
@property (nonatomic, retain) ActiveTaskModel *activeTask;

@end
