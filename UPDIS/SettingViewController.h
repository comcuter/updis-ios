//
//  SettingViewController.h
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Three20/Three20.h>
#import "MBProgressHUD.h"

@interface SettingViewController : TTTableViewController<TTURLRequestDelegate,MBProgressHUDDelegate>{
     MBProgressHUD *mHud;
}

@end
