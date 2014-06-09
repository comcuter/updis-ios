//
//  ProjectTypeListViewController.h
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveTaskModel.h"

typedef void(^CategoryTypeDidSelectBlock)(int projectTypeId, CommonCellModel *categoryModel, NSString *categoryElse);

@interface ProjectTypeListViewController : UIViewController

@property (nonatomic, copy) CategoryTypeDidSelectBlock categoryTypeDidSelectBlock;

@end
