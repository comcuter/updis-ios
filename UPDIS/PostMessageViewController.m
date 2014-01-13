//
//  PostMessageViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-17.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "PostMessageViewController.h"

@interface PostMessageViewController ()

@end

@implementation PostMessageViewController

- (id)initWithPageType:(PageType)pageType
{
    self = [super init];
    if (self) {
        [self setPageType:pageType];
        self.tableViewStyle = UITableViewStylePlain;
        self.autoresizesForKeyboard = YES;
        self.variableHeightRows = YES;
    }
    return self;
}
-(void)dealloc{
    TT_RELEASE_SAFELY(_titleImageView);
    TT_RELEASE_SAFELY(_btnCategory);
    TT_RELEASE_SAFELY(_txtDept);
    TT_RELEASE_SAFELY(_txtTitle);
    TT_RELEASE_SAFELY(_txtContent);
    [super dealloc];
}
-(void)loadView{
    [super loadView];
    [self.tableView setWidth:300];
    [self.tableView setLeft:10];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
    if(!self.titleImageView){
        TTImageView *temp = [[TTImageView alloc] initWithFrame:CGRectMake(93, 15, 135, 35)];
        self.titleImageView = temp;
        TT_RELEASE_SAFELY(temp);
    }
    if (self.pageType==PageTypePostMessage) {
        [self.titleImageView setUrlPath:@"bundle://titles_4.png"];
    }
    else{
        [self.titleImageView setUrlPath:@"bundle://titles_7.png"];
    }
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 45)];
    [self.titleImageView setCenter:headView.center];
    [headView addSubview:self.titleImageView];
    [self.tableView setTableHeaderView:headView];
    [headView release];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.txtTitle) {
        UITextField* textField = [[UITextField alloc] init];
        self.txtTitle = textField;
        [self.txtTitle setDelegate:self];
        textField.font = TTSTYLEVAR(font);
        TT_RELEASE_SAFELY(textField);
    }

    if (!self.txtDept) {
        UITextField* textField = [[UITextField alloc] init];
        self.txtDept = textField;
        [self.txtDept setDelegate:self];
        textField.font = TTSTYLEVAR(font);
        TT_RELEASE_SAFELY(textField);
    }

    if (!self.txtContent) {
        UITextView* textField = [[UITextView alloc] init];
        self.txtContent = textField;
        [self.txtContent setDelegate:self];
        textField.font = TTSTYLEVAR(font);
        TT_RELEASE_SAFELY(textField);
    }

    self.dataSource = [TTListDataSource dataSourceWithObjects:
                       self.txtDept,self.txtTitle,self.txtContent,
                       nil];

}

@end
