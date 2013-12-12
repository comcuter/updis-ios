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

@end

@implementation PersonQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withType:(QueryType)queryType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setQueryType:queryType];


    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadView{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    [self.view setBackgroundColor:[UIColor colorWithPatternImage:TTIMAGE(@"bundle://bg2.png")]];
    if(!self.titleImageView){
        TTImageView *temp = [[TTImageView alloc] initWithFrame:CGRectMake(93, 25, 135, 35)];
        self.titleImageView = temp;
        TT_RELEASE_SAFELY(temp);
    }
    [self.scrollPanel addSubview:self.titleImageView];

    // Do any additional setup after loading the view from its nib.
    if (self.queryType==QueryTypePerson) {
        [self.titleImageView setUrlPath:@"bundle://titles_1.png"];
        [self.subjectBg setHidden:NO];
    }
    else{
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
    }
    else{
        UITapGestureRecognizer *click1 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(btnClick:)];


        UITapGestureRecognizer *click2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(btnClick:)];
        //    swipe.direction = UISwipeGestureRecognizerDirectionDown;
        
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleSwipe:)];
//    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    tap.numberOfTouchesRequired = 1;
    [self.scrollPanel addGestureRecognizer:tap];
    TT_RELEASE_SAFELY(tap);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)btnClick:(UIGestureRecognizer *)sender{
    
    [self.txtUserName resignFirstResponder];

     TTImageView *imageViews = (TTImageView*) sender.view;
    
    int tag = [imageViews tag];
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    CommonListViewController *commonListViewController = nil;
    if (tag==10) {
        //单位列表
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicDept];
    }
    else{
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicSubject];
    }

    CGSize frameSize =CGSizeMake(320 - 66, self.view.height -30);
    [floatingController setPortraitFrameSize:frameSize];

    [floatingController showInView:[super view]
         withContentViewController:commonListViewController
                          animated:YES];

    [commonListViewController setDelegate:self];
    TT_RELEASE_SAFELY(commonListViewController);

}
-(void)showDicList:(id)sender{

    [self.txtUserName resignFirstResponder];
    int tag = [sender tag];
	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    CommonListViewController *commonListViewController = nil;
    if (tag==10) {
        //单位列表
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicDept];
    }
    else{
        commonListViewController = [[CommonListViewController alloc] initWithListType:ListTypeDicSubject];
    }

    CGSize frameSize =CGSizeMake(320 - 66, self.view.height -30);
    [floatingController setPortraitFrameSize:frameSize];

    [floatingController showInView:[super view]
         withContentViewController:commonListViewController
                          animated:YES];

    [commonListViewController setDelegate:self];
    TT_RELEASE_SAFELY(commonListViewController);
}

#pragma mark -
#pragma mark CommonListDataSourceDelegate
-(void)itemClick:(TTTableTextItem *)item listType:(ListType)listType{
    if (listType==ListTypeDicDept) {
        [self.btnShowDept setTitle:item.text forState:UIControlStateNormal];
        [self.btnShowDept setTitle:item.text forState:UIControlStateHighlighted];
        [self.btnShowDept setTitle:item.text forState:UIControlStateSelected];
    }
    if (listType==ListTypeDicSubject) {
        [self.btnShowSubject setTitle:item.text forState:UIControlStateNormal];
        [self.btnShowSubject setTitle:item.text forState:UIControlStateHighlighted];
        [self.btnShowSubject setTitle:item.text forState:UIControlStateSelected];
    }

	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];
    [floatingController dismissAnimated:YES];
}


-(IBAction)query:(id)sender{
}

-(void)dealloc{
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

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self scrollToBottomAnimated:NO];

//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillShowKeyboard:)
//												 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//	[[NSNotificationCenter defaultCenter] addObserver:self
//											 selector:@selector(handleWillHideKeyboard:)
//												 name:UIKeyboardWillHideNotification
//                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

	CQMFloatingController *floatingController = [CQMFloatingController sharedFloatingController];

    [floatingController dismissAnimated:YES];
    
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

    [self.txtUserName resignFirstResponder];
}

- (void)handleSwipe:(UIGestureRecognizer *)guestureRecognizer{
    [self.txtUserName resignFirstResponder];
}

- (void)scrollToBottomAnimated:(BOOL)animated{
 
}

#pragma mark - Text view delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}

#pragma mark - Keyboard notifications
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



- (void)keyboardWillShowHide:(NSNotification *)notification{

    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollPanel.contentInset = contentInsets;
    self.scrollPanel.scrollIndicatorInsets = contentInsets;

    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.txtUserName.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, self.txtUserName.frame.origin.y-kbSize.height);
        [self.scrollPanel setContentOffset:scrollPoint animated:YES];
    }
}

@end
