//
//  ChiefEngineerListViewController.h
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ChiefEngineerDidSelectBlock)(NSArray *chiefEngineers);

@interface ChiefEngineerListViewController : UIViewController

@property (nonatomic, copy) ChiefEngineerDidSelectBlock chiefEngineerDidSelectBlock;

@end
