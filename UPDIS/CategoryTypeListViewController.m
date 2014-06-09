//
//  CategoryTypeListViewController.m
//  UPDIS
//
//  Created by HaiLee on 14-6-8.
//  Copyright (c) 2014年 UPDIS. All rights reserved.
//

#import "CategoryTypeListViewController.h"
#import <UI7Kit/UI7TableView.h>
#import <UI7Kit/UI7TableViewCell.h>
#import "ZongShiReviewViewController.h"

typedef enum : NSUInteger {
    HUDTypeLoading = 1,
    HUDTypeMessage = 2,
} HUDType;

typedef enum : NSInteger {
    AlertTagOtherCategoryInput = 1,
} AlertTag;

@interface CategoryTypeListViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>

@property (nonatomic, retain) IBOutlet UI7TableView *tableView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) NSArray *categoryTypes;
@property (nonatomic, retain) CommonCellModel *currentSelectCategory;

@end

@implementation CategoryTypeListViewController

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
    
    [self loadCategoryTypes];
}

- (void)navigationBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadCategoryTypes
{
    [self showHUDWithText:@"正在加载数据" type:HUDTypeLoading];
    
    NSURL *requestURL = [NSURL URLWithString:[NSString stringWithFormat:URL_ZONG_SHI_REVIEW_CATEGORY_TYPE_LIST, MAIN_DOMAIN, self.currentSelectProjectType]];
    ASIHTTPRequest *strongRequest = [[ASIHTTPRequest alloc] initWithURL:requestURL];
    __weak ASIHTTPRequest *weakRequest = strongRequest;
    
    NSString *cookie = [NSString stringWithFormat:@"JSESSIONID=%@; Path=/rest/; HttpOnly", [[NSUserDefaults standardUserDefaults] valueForKey:@"cookies"]];
    [weakRequest addRequestHeader:@"Cookie" value:cookie];
    
    weakRequest.completionBlock = ^{
        [self.HUD hide:NO];
        
        NSError *error = nil;
        NSDictionary *responseDic = [NSJSONSerialization JSONObjectWithData:weakRequest.responseData options:0 error:&error];
        if (error == nil && [responseDic intValueForKey:SUCCESS_KEY] == 1) {
            NSArray *rawArray = [responseDic arrayValueForKey:@"data"];
            self.categoryTypes = [CommonCellModel parseDataFromRawArray:rawArray];
            [self.tableView reloadData];
        }
    };
    
    weakRequest.failedBlock = ^{
        [self.HUD hide:YES];
        TTAlert(@"数据加载失败,请重试");
    };
    
    [weakRequest startAsynchronous];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.categoryTypes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CommonCellIdentifier = @"CommonCell";
    UI7TableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:CommonCellIdentifier];
    if (commonCell == nil) {
        commonCell = [[UI7TableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CommonCellIdentifier];
    }
    commonCell.textLabel.text = ((CommonCellModel *)self.categoryTypes[indexPath.row]).name;
    return commonCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommonCellModel *commonModel = self.categoryTypes[indexPath.row];
    self.currentSelectCategory = commonModel;
    // 判断是否是其它.
    if ([commonModel.name isEqualToString:@"其它"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        alertView.tag = AlertTagOtherCategoryInput;
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *categoryElseTextField = [alertView textFieldAtIndex:0];
        categoryElseTextField.placeholder = @"请填写项目种类";
        [alertView show];
    } else {
        if (self.categoryTypeDidSelectBlock != nil) {
            self.categoryTypeDidSelectBlock(self.currentSelectProjectType, commonModel, nil);
        }
        [self popToZongShiReviewVC];
    }
}

- (void)popToZongShiReviewVC
{
    ZongShiReviewViewController *zongShiReviewVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[ZongShiReviewViewController class]]) {
            zongShiReviewVC = (ZongShiReviewViewController *)vc;
            break;
        }
    }
    
    if (zongShiReviewVC != nil) {
        [self.navigationController popToViewController:zongShiReviewVC animated:YES];
    }
}

- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    UITextField *categoryTextField = [alertView textFieldAtIndex:0];
    if (categoryTextField.text.length > 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == alertView.cancelButtonIndex) {
        return;
    }
    
    if (alertView.tag == AlertTagOtherCategoryInput) {
        if (buttonIndex == 1) {
            UITextField *categoryTextField = [alertView textFieldAtIndex:0];
            NSString *categoryElse = categoryTextField.text;
            if (self.categoryTypeDidSelectBlock != nil) {
                self.categoryTypeDidSelectBlock(self.currentSelectProjectType, self.currentSelectCategory, categoryElse);
            }
            [self popToZongShiReviewVC];
        }
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
