//
//  UpdateApp.h
//  UPDIS
//
//  Created by Melvin on 13-8-20.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface UpdateApp : NSObject<MBProgressHUDDelegate>{
    MBProgressHUD *mHud;
}
@property (nonatomic ,assign) BOOL isFocus;
@property (nonatomic ,copy) NSString *downUrl;

+ (id)sharedManager;
-(void)update:(BOOL)focus;
@end
