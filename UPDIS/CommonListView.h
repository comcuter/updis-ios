//
//  CommonListView.h
//  UPDIS
//  通用列表View
//  Created by Melvin on 13-4-23.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusPagingScrollView.h"

@interface CommonListView : UIView<NIPagingScrollViewPage>

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@end
