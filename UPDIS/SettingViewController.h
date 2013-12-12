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

@property (nonatomic ,retain) UISwitch *switchNotice;   //通知
@property (nonatomic ,retain) UISwitch *switchBidding;  //招标信息
@property (nonatomic ,retain) UISwitch *switchTalk;     //畅所欲言
@property (nonatomic ,retain) UISwitch *switchAmateur;  //业余生活
@property (nonatomic ,retain) UISwitch *switchProject;  //在谈项目

@property (nonatomic ,retain) UISwitch *switchOpen;  //开启
@property (nonatomic ,retain) UISwitch *switchNight;  //只在夜间
@property (nonatomic ,retain) UISwitch *switchClose;  //关闭
@end
