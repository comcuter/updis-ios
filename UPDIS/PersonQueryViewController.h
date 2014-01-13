//
//  PersonQueryViewController.h
//  UPDIS
//
//  Created by Melvin on 13-7-10.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListViewController.h"
#import "TPKeyboardAvoidingScrollView.h"

typedef enum {
	QueryTypePerson,     //人员查询
	QueryTypeContacts,    //通讯录
} QueryType;

@interface PersonQueryViewController : TTViewController<UITextFieldDelegate,CommonListViewControllerDelegate>

@property (nonatomic ,retain) IBOutlet UITextField *txtUserName;
@property (nonatomic ,retain) IBOutlet UIButton *btnShowDept;
@property (nonatomic ,retain) IBOutlet UIButton *btnShowSubject;

@property (nonatomic ,retain) IBOutlet UIButton *btnQuery;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(QueryType)queryType;

@end
