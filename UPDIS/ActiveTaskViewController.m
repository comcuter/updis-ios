//
//  ActiveTaskViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-3-16.
//  Copyright (c) 2014年 tianv. All rights reserved.
//

#import "ActiveTaskViewController.h"
#import "ActiveTaskModel.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>
#import <UI7Kit/UI7Font.h>
#import "ZongShiReviewViewController.h"

typedef enum : NSUInteger {
    AlertTagConfirmDirectorReview = 1,
    
    AlertTagConfirmProjectLeadReview = 2,
    AlertTagConfirmProjectLeadReject = 3,
    
    AlertTagCongirmZongShiReject = 5,
} AlertTag;

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

@interface ActiveTaskViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (nonatomic, retain) ActiveTaskModel *activeTask;
@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end

@implementation ActiveTaskViewController

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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadActiveTaskWithHUD:YES];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadActiveTaskWithHUD:(BOOL)showHUD
{
    if (showHUD) {
        [self showHUDWithText:@"数据加载中..." type:HUDTypeLoading];
    }
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_GET_ACTVIE_TASK, MAIN_DOMAIN, self.activeTaskId]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        if (showHUD) {
            [self.HUD hide:YES];
        }

        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            self.activeTask = [ActiveTaskModel parseActiveTaskFromRawDic:[responseDic objectForKey:@"data"]];
            [self.tableView reloadData];
        } else {
            TTAlert(@"数据加载失败");
        }
    };
    
    weakRequest.failedBlock = ^{
        if (showHUD) {
            [self.HUD hide:YES];
            TTAlert(@"数据加载失败");
        }
    };
    
    [weakRequest startAsynchronous];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    int sectionNumber = 5;
    
    if (self.activeTask.showDirectorReviewButton) {
        sectionNumber += 1;
    }
    
    // 所长审批相关
    if (self.activeTask.stateId >= 3) {
        sectionNumber += 1;
    }
    
    // 经营室相关数据
    if (self.activeTask.stateId >= 4) {
        sectionNumber += 1;
    }
    
    if (self.activeTask.showZongShiReviewButton) {
        sectionNumber += 1;
    }
    
    // 总师室相关字段.
    if (self.activeTask.stateId >= 5) {
        sectionNumber += 1;
    }
    
    if (self.activeTask.showProjectLeadReviewAndRejectButton) {
        sectionNumber += 1;
    }
    
    if (self.activeTask.stateId >= 6) {
        sectionNumber += 1;
    }

    return sectionNumber;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0: // 基本信息
            return 5;
            break;
        case 1: 
            return 3;
            break;
        case 2:
            return 5;
            break;
        case 3:
            return 4;
            break;
        case 4:
            return 3;
            break;
        case 5: // 所长签字或签字时间
            if (self.activeTask.showDirectorReviewButton) {
                return 1;
            } else {
                return 2;
            }
            break;
        case 6: // 经营室相关字段.
            return 6;
            break;
        case 7: // 总师室相关 或者 总师审批通过和打回按钮.
            if (self.activeTask.showZongShiReviewButton) {
                return 2;
            } else {
                return 6;
            }
            break;
        case 8: // 启动打回按钮 或者 负责人签字和签字时间
            return 2;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"  ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            CGSize contentSize = [self.activeTask.partner sizeWithFont:[UI7Font systemFontOfSize:17] constrainedToSize:CGSizeMake(290, 20000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else if (indexPath.row == 3) {
            CGSize contentSize = [self.activeTask.customerContact sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(200, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else {
            return 44;
        }
    } else if (indexPath.section == 7) {
        if (indexPath.row == 2) {
            CGSize contentSize = [self.activeTask.projectLead sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(170, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else if (indexPath.row == 3) {
            CGSize contentSize = [self.activeTask.zhuGuanZongShi sizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(170, 2000) lineBreakMode:UILineBreakModeCharacterWrap];
            return MAX(contentSize.height, 44);
        } else {
            return 44;
        }
    } else {
        return 44;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *stateCellIdentifier = @"StateCell";
    static NSString *commonCellIdentifier = @"CommonCell";
    static NSString *reviewButtonCellIdentifier = @"ReviewCell";
    
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:commonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:commonCellIdentifier];
        commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
        commonCell.detailTextLabel.numberOfLines = 0;
        commonCell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
    }
    commonCell.backgroundColor = [UIColor whiteColor];
    commonCell.detailTextLabel.textColor = [UIColor colorWithRed:0.22 green:0.33 blue:0.55 alpha:1.0];
    
    switch (indexPath.section) {
        case 0:
        {
            if (indexPath.row == 0) {
                UI7TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:stateCellIdentifier];
                if (cell == nil) {
                    cell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:stateCellIdentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.textLabel.textColor = [UIColor redColor];
                    cell.textLabel.font = [UIFont systemFontOfSize:20];
                }
                
                cell.textLabel.text = self.activeTask.state;
                return cell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"甲方";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.partner);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"甲方类型";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.partnerType);
                return commonCell;
            }
            
            if (indexPath.row == 3) {
                commonCell.textLabel.text = @"甲方联系人";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.customerContact);
                return commonCell;
            }
            
            if (indexPath.row == 4) {
                commonCell.textLabel.text = @"规模";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.guiMo);
                return commonCell;
            }
            
            return nil;
            break;
        }
            
        case 1:
        {
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"顾客要求形成文件否";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.yaoQiuXingChengWenJian);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"是否投标";
                commonCell.detailTextLabel.text = convertBoolToChinese(self.activeTask.shiFouTouBiao);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"投标类别";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.touBiaoLeiBie);
                return commonCell;
            }
            
            return nil;
            break;
        }
        
        case 2:
        {
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"明示要求";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.expressRequirement);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"隐含要求";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.yinHanYaoQiu);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"地方法规";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.diFangFaGui);
                return commonCell;
            }
            
            if (indexPath.row == 3) {
                commonCell.textLabel.text = @"附加要求";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.fuJiaYaoQiu);
                return commonCell;
            }
            
            if (indexPath.row == 4) {
                commonCell.textLabel.text = @"合同一致";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.heTongYiZhi);
                return commonCell;
            }
            
            return nil;
            break;
        }
            
        case 3:
        {
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"人力资源";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.ziYuanManZu);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"设备";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.sheBeiManZu);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"工期";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.gongQiManZu);
                return commonCell;
            }
            
            if (indexPath.row == 3) {
                commonCell.textLabel.text = @"设计费";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.sheJiFeiManZu);
                return commonCell;
            }
            return nil;
            break;
        }
            
        case 4:
        {
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"是否外包";
                commonCell.detailTextLabel.text = convertBoolToChinese(self.activeTask.shiFouWaiBao);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"市政配套";
                commonCell.detailTextLabel.text = convertBoolToChinese(self.activeTask.shiZhengPeiTao);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"多方合同";
                commonCell.detailTextLabel.text = convertBoolToChinese(self.activeTask.duoFangHeTong);
                return commonCell;
            }
            return nil;
            break;
        }
            
        case 5:
        {
            if (self.activeTask.showDirectorReviewButton) {
                if (indexPath.row == 0) {
                    UI7TableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                    if (reviewCell == nil) {
                        reviewCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                        reviewCell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    reviewCell.textLabel.textColor = [UIColor redColor];
                    reviewCell.textLabel.text = @"所长审批通过";
                    return reviewCell;
                }
                return nil;
                break;
            } else {
                if (indexPath.row == 0) {
                    commonCell.textLabel.text = @"所长签字";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.directorReviewer);
                    if (self.activeTask.directorReviewer.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    return commonCell;
                }
                
                if (indexPath.row == 1) {
                    commonCell.textLabel.text = @"签字时间";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.directorReviewerApplyTime);
                    if (self.activeTask.directorReviewerApplyTime.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    return commonCell;
                }
                
                return nil;
                break;
            }
        }
            
        case 6:
        {
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"评审方式";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.pingShenFangShi);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"引发措施记录";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.yinFaCuoShi);
                return commonCell;
            }
            
            if (indexPath.row == 2) {
                commonCell.textLabel.text = @"任务要求";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.renWuYaoQiu);
                return commonCell;
            }
            
            if (indexPath.row == 3) {
                commonCell.textLabel.text = @"承接部门";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.chengJieBuMen);
                return commonCell;
            }
            
            if (indexPath.row == 4) {
                commonCell.textLabel.text = @"经营室签字";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.jingYingShiReviewer);
                if (self.activeTask.jingYingShiReviewer.length > 0) {
                    commonCell.detailTextLabel.textColor = [UIColor redColor];
                    commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                }
                return commonCell;
            }
            
            if (indexPath.row == 5) {
                commonCell.textLabel.text = @"签字时间";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.jingYingShiReviewApplyTime);
                if (self.activeTask.jingYingShiReviewApplyTime.length > 0) {
                    commonCell.detailTextLabel.textColor = [UIColor redColor];
                    commonCell.backgroundColor =RGBCOLOR(226, 237, 240);
                }
                return commonCell;
            }
            return nil;
            break;
        }
        
        case 7:
        {
            if (self.activeTask.showZongShiReviewButton) {
                if (indexPath.row == 0) {
                    UI7TableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                    if (reviewCell == nil) {
                        reviewCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                        reviewCell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    reviewCell.textLabel.textColor = [UIColor redColor];
                    reviewCell.textLabel.text = @"审批通过";
                    return reviewCell;
                }
                
                if (indexPath.row == 1) {
                    UI7TableViewCell *rejectCell = [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                    if (rejectCell == nil) {
                        rejectCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                        rejectCell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    rejectCell.textLabel.textColor = [UIColor blackColor];
                    rejectCell.textLabel.text = @"打回";
                    return rejectCell;
                }
            } else {
                if (indexPath.row == 0) {
                    commonCell.textLabel.text = @"类别";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.projectCategory);
                    return commonCell;
                }
                
                if (indexPath.row == 1) {
                    commonCell.textLabel.text = @"项目管理级别";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.guanLiJiBie);
                    return commonCell;
                }
                
                if (indexPath.row == 2) {
                    commonCell.textLabel.text = @"项目负责人";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.projectLead);
                    return commonCell;
                }
                
                if (indexPath.row == 3) {
                    commonCell.textLabel.text = @"主管总师";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.zhuGuanZongShi);
                    return commonCell;
                }
                
                if (indexPath.row == 4) {
                    commonCell.textLabel.text = @"总师室签字";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.zongShiShiReviewer);
                    if (self.activeTask.zongShiShiReviewer.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    
                    return commonCell;
                }
                
                if (indexPath.row == 5) {
                    commonCell.textLabel.text = @"签字时间";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.zongShiShiReviewApplyTime);
                    if (self.activeTask.zongShiShiReviewApplyTime.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    
                    return commonCell;
                }
            }
            
            return nil;
            break;
        }
            
        case 8:
        {
            if (self.activeTask.showProjectLeadReviewAndRejectButton) {
                if (indexPath.row == 0) {
                    UI7TableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                    if (reviewCell == nil) {
                        reviewCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                        reviewCell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    reviewCell.textLabel.textColor = [UIColor redColor];
                    reviewCell.textLabel.text = @"项目启动";
                    return reviewCell;
                }
                
                if (indexPath.row == 1) {
                    UITableViewCell *rejectCell= [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                    if (rejectCell == nil) {
                        rejectCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                        rejectCell.textLabel.textAlignment = UITextAlignmentCenter;
                    }
                    
                    rejectCell.textLabel.textColor = [UIColor blackColor];
                    rejectCell.textLabel.text = @"打回";
                    return rejectCell;
                }
            
            } else {
                if (indexPath.row == 0) {
                    commonCell.textLabel.text = @"负责人签字";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.projectLeadReviewer);
                    if (self.activeTask.projectLeadReviewer.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    
                    return commonCell;
                }
                
                if (indexPath.row == 1) {
                    commonCell.textLabel.text = @"签字时间";
                    commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.projectLeadReviewApplyTime);
                    if (self.activeTask.projectLeadReviewApplyTime.length > 0) {
                        commonCell.detailTextLabel.textColor = [UIColor redColor];
                        commonCell.backgroundColor = RGBCOLOR(226, 237, 240);
                    }
                    
                    return commonCell;
                }
            }
            
            return nil;
            break;
        }
        
        default:
            return nil;
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.activeTask.showDirectorReviewButton) {
        if (indexPath.section == 5 && indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"确定审批通过?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = AlertTagConfirmDirectorReview;
            [alertView show];
        }
    }
    
    if (self.activeTask.showProjectLeadReviewAndRejectButton) {
        if (indexPath.section == 8 && indexPath.row == 0) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"确定启动项目?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = AlertTagConfirmProjectLeadReview;
            [alertView show];
        } else if (indexPath.section == 8 && indexPath.row == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"打回申请单"
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = AlertTagConfirmProjectLeadReject;
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            UITextField *textField = [alertView textFieldAtIndex:0];
            textField.placeholder = @"打回原因";
            textField.font = [UIFont systemFontOfSize:15];
            
            [alertView show];
        }
    }
    
    if (self.activeTask.showZongShiReviewButton) {
        if (indexPath.section == 7 && indexPath.row == 0) {
            [self zongShiReview];
        } else if (indexPath.section == 7 && indexPath.row == 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                                message:@"确定打回?"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag = AlertTagCongirmZongShiReject;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if (alertView.tag == AlertTagConfirmDirectorReview) {
        if (buttonIndex == 1) {
            [self directorReview];
        }
        return;
    }
    
    if (alertView.tag == AlertTagConfirmProjectLeadReview) {
        if (buttonIndex == 1) {
            [self projectLeadReview];
        }
        
        return;
    }
    
    if (alertView.tag == AlertTagConfirmProjectLeadReject) {
        if (buttonIndex == 1) {
            UITextField *commentTextField = [alertView textFieldAtIndex:0];
            [self projectLeadRejectWithComment:commentTextField.text];
        }
    }
    
    if (alertView.tag == AlertTagCongirmZongShiReject) {
        if (buttonIndex == 1) {
            [self zongShiReject];
        }
    }

}

- (void)directorReview
{
    [self showHUDWithText:@"数据提交中..." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_REVIEW_ACTIVE_TASK, MAIN_DOMAIN, self.activeTaskId]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            [self showHUDWithText:@"审批成功" type:HUDTypeMessage];
            self.activeTask.showDirectorReviewButton = NO;
            [self.tableView reloadData];
            [self loadActiveTaskWithHUD:NO];
        } else {
            TTAlert(@"审批失败!");
        }
    };
    
    weakRequest.failedBlock = ^{
        [self.HUD hide:YES];
        TTAlert(@"审批失败!");
    };
    
    [weakRequest startAsynchronous];
}

- (void)projectLeadReview
{
    [self showHUDWithText:@"数据提交中..." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_PROJECT_LEAD_REVIEW_ACTIVE_TASK, MAIN_DOMAIN, self.activeTaskId]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            [self showHUDWithText:@"项目启动成功" type:HUDTypeMessage];
            self.activeTask.showProjectLeadReviewAndRejectButton = NO;
            [self.tableView reloadData];
            [self loadActiveTaskWithHUD:NO];
        } else {
            TTAlert(@"提交数据失败!");
        }
    };
    
    weakRequest.failedBlock = ^{
        [self.HUD hide:YES];
        TTAlert(@"提交数据失败!");
    };
    
    [weakRequest startAsynchronous];
}

- (void)projectLeadRejectWithComment:(NSString *)comment
{
    [self showHUDWithText:@"数据提交中..." type:HUDTypeLoading];
    
    if (comment == nil) {
        comment = @"";
    }
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_PROJECT_LEAD_REJECT_ACTIVE_TASK, MAIN_DOMAIN]];
    ASIFormDataRequest *strongRequest = [[ASIFormDataRequest alloc] initWithURL:requestURL];
    [strongRequest setPostValue:@(self.activeTaskId) forKey:@"id"];
    [strongRequest setPostValue:comment forKey:@"comment"];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        NSLog(@"%@", responseDic);
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            [self showHUDWithText:@"打回成功" type:HUDTypeMessage];
            self.activeTask.showProjectLeadReviewAndRejectButton = NO;
            [self.tableView reloadData];
            [self loadActiveTaskWithHUD:NO];
        } else {
            TTAlert(@"提交数据失败!");
        }
    };
    
    weakRequest.failedBlock = ^{
        NSLog(@"%@", weakRequest.error);
        [self.HUD hide:YES];
        TTAlert(@"提交数据失败!");
    };
    
    [weakRequest startAsynchronous];
}

- (void)zongShiReview
{
    ZongShiReviewViewController *zongShiReviewVC = [[ZongShiReviewViewController alloc] init];
    zongShiReviewVC.activeTask = self.activeTask;
    zongShiReviewVC.activeTaskId = self.activeTaskId;
    [self.navigationController pushViewController:zongShiReviewVC animated:YES];
}

- (void)zongShiReject
{
    [self showHUDWithText:@"数据提交中..." type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_ZONG_SHI_REJECT_ACTIVE_TASK, MAIN_DOMAIN, self.activeTaskId]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        NSLog(@"%@", responseDic);
        
        if (error == nil && [responseDic intValueForKey:@"success"] == 1) {
            [self showHUDWithText:@"打回成功" type:HUDTypeMessage];
            self.activeTask.showZongShiReviewButton = NO;
            [self.tableView reloadData];
            [self loadActiveTaskWithHUD:NO];
        } else {
            TTAlert(@"提交数据失败!");
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
