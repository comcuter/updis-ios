//
//  ZongShiReviewViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "ZongShiReviewViewController.h"
#import "ActiveTaskModel.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>
#import "ProjectTypeListViewController.h"
#import "ChiefEngineerListViewController.h"

typedef enum : NSInteger {
    TaskManageLevelNone = 1,
    TaskManageLevelYuanJi = 2,
    TaskManageLevelSuoJi = 3,
} TaskManageLevel;

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

typedef enum : NSInteger {
    AlertTagConfirmReview = 1,
} AlertTag;

@interface ZongShiReviewViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, UIActionSheetDelegate>

@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

// 项目种类
@property (nonatomic, assign) int currentProjectTypeID;
// 项目类别
@property (nonatomic, retain) CommonCellModel *currentCategory;
// 当项目类别选择为其它时,手工填的类别名
@property (nonatomic, retain) NSString *currentCategoryElse;
// 管理级别
@property (nonatomic, assign) TaskManageLevel currentManageLevel;
// 当前选中的主管总师
@property (nonatomic, retain) NSArray *currentChiefEngineers;

@end

@implementation ZongShiReviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *backImage = [UIImage imageNamed:@"ico_arr"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backImage forState:UIControlStateNormal];
    backButton.bounds = CGRectMake(0, 0, backImage.size.width, backImage.size.height);
    [backButton addTarget:self action:@selector(navigationBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo3"]];
    self.navigationItem.titleView = titleImageView;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor colorWithRed:229./255 green:229./255 blue:229./255 alpha:1.0];
    
    self.currentManageLevel = TaskManageLevelNone;
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGSize contentSize = [self.activeTask.projectLead sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(180, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else if (indexPath.row == 3) {
            NSMutableArray *chiefEngineerNames = [NSMutableArray array];
            for (CommonCellModel *model in self.currentChiefEngineers) {
                [chiefEngineerNames addObject:model.name];
            }
            NSString *chiefEngineerNameString = [chiefEngineerNames componentsJoinedByString:@", "];
            CGSize contentSize = [chiefEngineerNameString sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(180, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        if (self.currentManageLevel == TaskManageLevelYuanJi) {
            return 4;
        } else {
            return 3;
        }
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommonCellIdentifier = @"CommonCell";
    static NSString *ReviewButtonIdentifier = @"ReviewCell";
    
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CommonCellIdentifier];
        commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        commonCell.detailTextLabel.numberOfLines = 0;
        commonCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            commonCell.textLabel.text = @"项目种类";
            if (self.currentCategory == nil) {
                commonCell.detailTextLabel.text = @"请选择";
            } else {
                NSString *categoryName = self.currentCategory.name;
                if ([categoryName isEqualToString:@"其它"]) {
                    categoryName = [categoryName stringByAppendingString:[NSString stringWithFormat:@" %@", self.currentCategoryElse]];
                }
                commonCell.detailTextLabel.text = categoryName;
            }
            
            return commonCell;
        } else if (indexPath.row == 1) {
            commonCell.accessoryType = UITableViewCellAccessoryNone;
            commonCell.textLabel.text = @"项目负责人";
            commonCell.detailTextLabel.text = self.activeTask.projectLead;
            
            return commonCell;
        } else if (indexPath.row == 2) {
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            commonCell.textLabel.text = @"管理级别";
            if (self.currentManageLevel == TaskManageLevelNone) {
                commonCell.detailTextLabel.text = @"请选择";
            } else if (self.currentManageLevel == TaskManageLevelSuoJi) {
                commonCell.detailTextLabel.text = @"所级";
            } else if (self.currentManageLevel == TaskManageLevelYuanJi) {
                commonCell.detailTextLabel.text = @"院级";
            }
            
            return commonCell;
        } else if (indexPath.row == 3) {
            commonCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            commonCell.textLabel.text = @"主管总师";
            if (self.currentChiefEngineers.count == 0) {
                commonCell.detailTextLabel.text = @"请选择";
            } else {
                NSMutableArray *chiefEngineerNames = [NSMutableArray array];
                for (CommonCellModel *model in self.currentChiefEngineers) {
                    [chiefEngineerNames addObject:model.name];
                }
                commonCell.detailTextLabel.text = [chiefEngineerNames componentsJoinedByString:@","];
            }
            
            return commonCell;
        }
    } else if (indexPath.section == 1) {
        UI7TableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:ReviewButtonIdentifier];
        if (reviewCell == nil) {
            reviewCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReviewButtonIdentifier];
            reviewCell.textLabel.textAlignment = UITextAlignmentCenter;
        }
        
        reviewCell.textLabel.textColor = [UIColor redColor];
        reviewCell.textLabel.text = @"审批通过";
        return reviewCell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // 项目种类
            ProjectTypeListViewController *projectTypeVC = [[ProjectTypeListViewController alloc] init];
            projectTypeVC.categoryTypeDidSelectBlock = ^(int projectTypeId, CommonCellModel *category, NSString *categoryElse) {
                self.currentProjectTypeID = projectTypeId;
                self.currentCategory = category;
                self.currentCategoryElse = categoryElse;
                
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:projectTypeVC animated:YES];
        } else if (indexPath.row == 1) {
            // 项目负责人
            // do nothing.
        } else if (indexPath.row == 2) {
            // 管理级别
            UIActionSheet *manageLevelAction = [[UIActionSheet alloc] initWithTitle:@"选择管理级别"
                                                                           delegate:self
                                                                  cancelButtonTitle:@"取消"
                                                             destructiveButtonTitle:nil
                                                                  otherButtonTitles:@"院级", @"所级", nil];
            [manageLevelAction showFromTabBar:self.tabBarController.tabBar];
        } else if (indexPath.row == 3) {
            // 主管总师
            ChiefEngineerListViewController *chiefEngineerVC = [[ChiefEngineerListViewController alloc] init];
            chiefEngineerVC.chiefEngineerDidSelectBlock = ^(NSArray *chiefEnginners) {
                self.currentChiefEngineers = chiefEnginners;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:chiefEngineerVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        if (self.currentCategory == nil) {
            TTAlert(@"请选择项目种类");
            return;
        }
        
        if (self.currentManageLevel == TaskManageLevelNone) {
            TTAlert(@"请选择管理级别");
            return;
        }
        
        if (self.currentManageLevel == TaskManageLevelYuanJi && self.currentChiefEngineers.count == 0) {
            TTAlert(@"请选择主管总师");
            return;
        }
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:@"确定审批通过?"
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = AlertTagConfirmReview;
        [alertView show];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    
    if (buttonIndex == 0) {
        self.currentManageLevel = TaskManageLevelYuanJi;
    } else if (buttonIndex == 1) {
        self.currentManageLevel = TaskManageLevelSuoJi;
    }
    
    [self.tableView reloadData];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if (alertView.tag == AlertTagConfirmReview) {
        if (buttonIndex == 1) {
            [self zongShiReview];
        }
    }
}

- (void)zongShiReview
{
    [self showHUDWithText:@"数据提交中...." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_ZONG_SHI_REVIEW_ACTIVE_TASK, MAIN_DOMAIN]];
    ASIFormDataRequest *strongRequest = [[ASIFormDataRequest alloc] initWithURL:requestURL];
    __weak ASIFormDataRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    [strongRequest addPostValue:@(self.activeTaskId) forKey:@"activeTaskId"];
    [strongRequest addPostValue:@(self.currentProjectTypeID) forKey:@"projectTypeId"];
    [strongRequest addPostValue:@(self.currentCategory.modelId) forKey:@"projectCategoryId"];
    if (self.currentCategoryElse != nil) {
        [strongRequest addPostValue:self.currentCategoryElse forKey:@"projectCategoryElse"];
    }
    NSString *manageLevelId = @"LH200307240002";
    if (self.currentManageLevel == TaskManageLevelYuanJi) {
        manageLevelId = @"LH200307240001";
    }
    [strongRequest addPostValue:manageLevelId forKey:@"manageLevelId"];
    if (self.currentChiefEngineers.count > 0) {
        for (CommonCellModel *chiefEngineer in self.currentChiefEngineers) {
            [strongRequest addPostValue:@(chiefEngineer.modelId) forKey:@"chiefEngineerIds"];
        }
    }
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        NSLog(@"%@", responseDic);
        
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            [self showHUDWithText:@"审批通过" type:HUDTypeMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            TTAlert(@"审批通过失败");
        }
    };
    
    weakRequest.failedBlock = ^{
        NSLog(@"%@", weakRequest.error);
        [self.HUD hide:YES];
        TTAlert(@"提交数据失败");
    };
    
    [weakRequest startAsynchronous];
}

- (void)showHUDWithText:(NSString *)text type:(HUDType)type
{
    if (self.HUD == nil) {
        self.HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:self.HUD];
        self.HUD.animationType = MBProgressHUDAnimationFade;
    }
    
    self.HUD.labelText = text;
    if (type == HUDTypeLoading) {
        [self.HUD show:YES];
    } else {
        self.HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
        self.HUD.mode = MBProgressHUDModeCustomView;
        [self.HUD show:YES];
        [self.HUD hide:YES afterDelay:2];
    }
}

@end
