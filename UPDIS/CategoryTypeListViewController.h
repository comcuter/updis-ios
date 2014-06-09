//
//  CategoryTypeListViewController.h
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProjectTypeListViewController.h"

@interface CategoryTypeListViewController : UIViewController

@property (nonatomic, assign) int currentSelectProjectType;
@property (nonatomic, copy) CategoryTypeDidSelectBlock categoryTypeDidSelectBlock;

@end
