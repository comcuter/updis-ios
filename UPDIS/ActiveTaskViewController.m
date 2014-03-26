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

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

@interface ActiveTaskViewController ()<UITableViewDelegate, UITableViewDataSource>

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
    
    UIView *tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    tableFooterView.backgroundColor = [UIColor clearColor];
    self.tableView.tableFooterView = tableFooterView;
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
    if (self.activeTask.showButton) {
        return 7;
    } else {
        return 6;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
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
        case 5:
            return 2;
            break;
        case 6:
            return 1;
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
            if (indexPath.row == 0) {
                commonCell.textLabel.text = @"评审人";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.directorReviewer);
                return commonCell;
            }
            
            if (indexPath.row == 1) {
                commonCell.textLabel.text = @"评审时间";
                commonCell.detailTextLabel.text = convertBlankStringToDashIfPossible(self.activeTask.directorReviewerApplyTime);
                return commonCell;
            }
            
            return nil;
            break;
        }
            
        case 6:
        {
            if (indexPath.row == 0) {
                UI7TableViewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:reviewButtonCellIdentifier];
                if (reviewCell == nil) {
                    reviewCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewButtonCellIdentifier];
                    reviewCell.textLabel.textAlignment = UITextAlignmentCenter;
                }
                
                reviewCell.textLabel.textColor = [UIColor redColor];
                reviewCell.textLabel.text = @"所长审批";
                return reviewCell;
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
    
    if (indexPath.section == 6 && indexPath.row == 0) {
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
                self.activeTask.showButton = NO;
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
