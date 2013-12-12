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

typedef enum
{
	QueryTypePerson,     //人员查询
	QueryTypeContacts,    //通讯录
}QueryType;

@interface PersonQueryViewController : TTViewController<UITextFieldDelegate,CommonListViewControllerDelegate>{
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
             withType:(QueryType)queryType;


@property (nonatomic ,assign) QueryType queryType;
@property (nonatomic ,retain) TTImageView  *titleImageView;

@property (nonatomic ,retain) IBOutlet TTImageView       *nameBg;
@property (nonatomic ,retain) IBOutlet TTImageView       *deptBg;
@property (nonatomic ,retain) IBOutlet TTImageView       *subjectBg;
@property (nonatomic ,retain) IBOutlet UIScrollView         *scrollPanel;

@property (nonatomic ,retain) IBOutlet UITextField       *txtUserName;
@property (nonatomic ,retain) IBOutlet UIButton     *btnQuery;
@property (nonatomic ,retain) IBOutlet UIButton     *btnShowDept;
@property (nonatomic ,retain) IBOutlet UIButton     *btnShowSubject;
@property (nonatomic ,assign) CGFloat           previousTextViewContentHeight;


-(IBAction)query:(id)sender;
-(void)showDicList:(id)sender;
@end
