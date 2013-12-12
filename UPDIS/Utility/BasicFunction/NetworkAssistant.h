//
//  NetworkAssistant.h
//  UPDIS
//
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@protocol NetworkAssistantDelegate <NSObject>
-(void)fetchDataOver:(BOOL)succeed operFlag:(NSString *)operFlag;
@end

@interface NetworkAssistant : NSObject<MBProgressHUDDelegate>{
    MBProgressHUD *mHud;
}
@property (nonatomic ,assign)id<NetworkAssistantDelegate>delegate;
@property (nonatomic ,assign) BOOL succeed;
@property (nonatomic ,assign) BOOL silent;
@property (nonatomic ,retain) NSDictionary *parameter;
@property (nonatomic ,retain) NSString *operFlag;
@property (nonatomic ,retain) NSString *loadingStr;


-(void)fetchDataFromServer:(NSString*)operFlag withRootViewController:(UIViewController *)rootView;

@end
