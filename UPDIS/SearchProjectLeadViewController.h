//
//  SearchProjectLeadViewController.h
//  UPDIS
//
//  Created by HaiLee on 14-7-13.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ProjectLeadDidSelectBlock) (NSArray *projectLeads);
@interface SearchProjectLeadViewController : UIViewController

@property (nonatomic, copy) ProjectLeadDidSelectBlock projectLeadDidSelectBlock;

@end
