//
//  PersonQueryViewController.m
//  UPDIS
//
//  Created by Melvin on 13-7-10.
//  Copyright (c) 2013年 tianv. All rights reserved.
//

#import "PersonQueryViewController.h"
#import "CommentListViewController.h"
#import "CommonListViewController.h"
#import "CQMFloatingController.h"
#import "NSString+MessagesView.h"
#import "UIView+AnimationOptionsForCurve.h"

@interface PersonQueryViewController ()

@property (nonatomic ,assign) QueryType queryType;
@property (nonatomic ,retain) TTImageView  *titleImageView;

@property (nonatomic ,retain) IBOutlet TTImageView *nameBg;
@property (nonatomic ,retain) IBOutlet TTImageView *deptBg;
@property (nonatomic ,retain) IBOutlet TTImageView *subjectBg;
@property (nonatomic ,retain) IBOutlet UIScrollView *scrollPanel;

-(void)showDicList:(id)sender;

@end

@implementation PersonQueryViewController

-(void)dealloc
{
    TT_RELEASE_SAFELY(_titleImageView);
    TT_RELEASE_SAFELY(_nameBg);
    TT_RELEASE_SAFELY(_deptBg);
    TT_RELEASE_SAFELY(_subjectBg);
    TT_RELEASE_SAFELY(_btnQuery);
    TT_RELEASE_SAFELY(_btnShowDept);
    TT_RELEASE_SAFELY(_btnShowSubject);
    TT_RELEASE_SAFELY(_txtUserName);
    TT_RELEASE_SAFELY(_scrollPanel);
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(QueryType)queryType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setQueryType:queryType];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
    if (!self.titleImageView) {
        TTImageView *temp = [[TTImageView alloc] initWithFrame:CGRectMake(93, 25, 135, 35)];
        self.titleImageView = temp;
        TT_RELEASE_SAFELY(temp);
    }
    [self.scrollPanel addSubview:self.titleImageView];

    if (self.queryType == QueryTypePerson) {
        [self.titleImageView setUrlPath:@"bundle://titles_1.png"];
        [self.subjectBg setHidden:NO];
    } else {
        [self.titleImageView setUrlPath:@"bundle://titles_2.png"];
        [self.subjectBg setHidden:YES];
        [self.btnQuery setTop:170];
    }

    [[self nameBg] setUrlPath:@"bundle://input3.png"];
    [[self deptBg] setUrlPath:@"bundle://input4.png"];
    [[self subjectBg] setUrlPath:@"bundle://input4.png"];

    if ([[[UIDevice currentDevice] systemVersion] floatValue] > 6.0) {
        [self.btnShowDept addTarget:self action:@selector(showDicList:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnShowSubject addTarget:self action:@selector(showDicList:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        UITapGestureRecognizer *click2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClick:)];
        
        click1.numberOfTouchesRequired = 1;
        click2.numberOfTouchesRequired = 1;
        [self.deptBg addGestureRecognizer:click1];
        [self.deptBg setTag:10];
        [self.subjectBg addGestureRecognizer:click2];
        [self.subjectBg setTag:11];
        TT_RELEASE_SAFELY(click1);
        TT_RELEASE_SAFELY(click2);
    }

    [self.btnShowDept setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [self.btnShowSubject setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    tap.numberOfTouchesRequired = 1;
    [self.scrollPanel addGestureRecognizer:tap];
    TT_RELEASE_SAFELY(tap);
}

- (void)btnClick:(UIGestureRecognizer *)sender
{
    [self.txtUserName resignFirstResponder];
    TTImageView *imageViews = (TTImageView*)sender.view;
    
    int tag = [imageViews tag];
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    CommonListViewController *commonListViewController = nil;
    if (tag==10) {
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicDept];
    } else {
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicSubject];
    }

    CGSize frameSize = CGSizeMake(320 - 66, self.view.height -30);
    [floatingController setPortraitFrameSize:frameSize];

    [floatingController showInView:[super view]
         withContentViewController:commonListViewController
                          animated:YES];

    [commonListViewController setDelegate:self];
    TT_RELEASE_SAFELY(commonListViewController);
}

-(void)showDicList:(id)sender
{
    [self.txtUserName resignFirstResponder];
    int tag = [sender tag];
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    CommonListViewController *commonListViewController = nil;
    if (tag==10) {
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicDept];
    } else {
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicSubject];
    }

    CGSize frameSize = CGSizeMake(320 - 66, self.view.height -30);
    [floatingController setPortraitFrameSize:frameSize];

    [floatingController showInView:[super view] withContentViewController:commonListViewController animated:YES];
    [commonListViewController setDelegate:self];
    TT_RELEASE_SAFELY(commonListViewController);
}

-(void)itemClick:(TTTableTextItem *)item listType:(ListType)listType
{
    if (listType==ListTypeDicDept) {
        [self.btnShowDept setTitle:item.text forState:UIControlStateNormal];
    }
    
    if (listType==ListTypeDicSubject) {
        [self.btnShowSubject setTitle:item.text forState:UIControlStateNormal];
    }

	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController dismissAnimated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController dismissAnimated:YES];
    
    [self.txtUserName resignFirstResponder];
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer
{
    [self.txtUserName resignFirstResponder];
}

#pragma mark - Text view delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

- (void)handleWillHideKeyboard:(NSNotification *)notification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollPanel.contentInset = contentInsets;
    self.scrollPanel.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{

    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollPanel.contentInset = contentInsets;
    self.scrollPanel.scrollIndicatorInsets = contentInsets;

    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.txtUserName.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.txtUserName.frame.origin.y-kbSize.height);
        [self.scrollPanel setContentOffset:scrollPoint animated:YES];
    }
}

@end
